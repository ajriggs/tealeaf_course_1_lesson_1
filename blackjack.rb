# pseudo code:
# player sits down, provides name, and available gambling funds
# player bets some money
# shuffle a deck
# give each player a card face up, including the dealer
# give everyone but the dealer another card face up
# dealer gets a 2nd card, face down
# check players for blackjack.
# dealer asks player to hit/stay
# if player hits
#   check for blackjack or bust
#   else ask again, hit or stay?
# move on to next player's turn if current player stays
# after all players take turn, dealer's turn starts
# while the dealer's cards total less than 17
#   dealer hits
# otherwise
#   dealer stays
# dealer reveals all cards
# if player's cards total more than dealer's (but do not bust)
#   player wins, and gets double their bet
# otherwise
# player loses their bet
# game ends when player runs out of money
# play again?

# Had some fun with this. In particular, I added in a shuffle_deck() method
# that attempts to model the way a dealer shuffles cards at a table, with
# a little randomness baked in. Also added in advanced win/tie conditions,
# for things like when both players bust, for ex.
# Hope everything isn't TOO abstracted!

# stretch goals: Add in betting & money pool, with running out
# of money as a gameOver condition. Add 1+ additional decks.
# Maybe add in multiplayer?

def say(msg, title = nil)
  if title
    puts title.center(70, '~')
  end
  if msg
    puts  "=> #{msg}".ljust(70)
  end
end

def yes_or_no?(msg, title = nil)
  say(msg, title)
  loop do
    input = gets.chomp.downcase
    unless (input == 'y') || (input == 'n')
      say "Invalid input. \n" + 'Choose: [Y/N]'
    end
    return true if input == 'y'
    return false if input == 'n'
  end
end

def get_player_name
  say("What's your name?", "Let's Play Blackjack!")
  name = gets.chomp.capitalize
end

def explain_rules
  if yes_or_no?("Would you like me to explain the rules? [Y/N]")
    system 'clear'
    say(nil, 'Rules')
    say("I'll deal us each two cards. Your cards are visible to all, \n" +
        "but you can only see the first card that I deal to myself. \n" +
        "Try to make the value of your cards total 21...but no higher, \n" +
        "or else you'll bust! \n \n" +
        "CARD VALUES: \n" +
        "-Numbers 2-10 are valued at their number. \n" +
        "-Face cards (K, Q, J) are worth 10 each. \n" +
        "-Aces are worth 1 or 11, whichever benefits you more. \n" +
        "*NOTE: the value of an Ace can change at any time. \n\n" +
        "After dealing, I'll ask you: HIT or STAY? If you HIT, \n" +
        "you'll get another card. If you haven't busted (22+), \n" +
        "or gotten blackjack (21), you can HIT again, or STAY. \n" +
        "Choose 'STAY' at any point to end your turn. \n \n" +
        "I'll reveal my cards at the end. Unless you bust and I \n" +
        "don't, if your cards total higher than mine, you win!  \n \n" +
        "Hit ENTER/RETURN to continue.")
  else
    say("Ok. Then let's get started! Hit ENTER/RETURN to continue.")
  end
end

def announce_player_hand(hand, name)
  system 'clear'
  say(nil, "#{name}'s Hand")
  hand.each do |card|
    say("           #{card[:rank]} of #{card[:suit]}")
  end
  unless bust?(hand)
    say("           Total: #{calculate_hand_total(hand)}")
  else
    say("           Total: #{calculate_bust_total(hand)}")
  end
end

def announce_dealer_hand(hand, final_turn = false)
  say(nil, 'My Hand')
  if hand.count == 2 && !final_turn
    say("My first card is the #{hand[0][:rank]} of #{hand[0][:suit]}. "\
        "I have one other, hidden card.")
  else
    hand.each do |card|
      if card == hand.first
        say("My hand: #{card[:rank]} of #{card[:suit]}")
      else
        next if (hand.index(card) == 1) && !final_turn
        say("         #{card[:rank]} of #{card[:suit]}")
        say("         plus one hidden card!") unless final_turn
      end
    end
  end
end

def announce_player_results(hand, name)
  if blackjack?(hand)
    say("#{name} got a blackjack!")
  elsif bust?(hand)
    say("You busted, #{name}! Your total is: "\
        "#{calculate_bust_total(hand)}")
  else
    say("#{name}, Your final total is: #{calculate_hand_total(hand)}")
  end
end

def announce_dealer_results(hand)
  if blackjack?(hand)
    say('I got Blackjack!')
  elsif bust?(hand)
    say("I busted! My total is: #{calculate_bust_total(hand)}")
  else
    say("My final total is: #{calculate_hand_total(hand)}")
  end
end

def announce_final_results(player_hand, dealer_hand, player_name)
  player_total = calculate_hand_total(player_hand)
  player_bust = bust?(player_hand)
  player_bust_total = calculate_bust_total(player_hand)
  dealer_total = calculate_hand_total(dealer_hand)
  dealer_bust = bust?(dealer_hand)
  dealer_bust_total = calculate_bust_total(dealer_hand)
  say(nil, 'Final Results')
  if (player_total <= 21 && player_total == dealer_total) || ((player_bust && dealer_bust) && player_bust_total == dealer_bust_total)
    say("It's a tie!")
  elsif (!player_bust && dealer_bust) || ((!player_bust && !dealer_bust) && (player_total > dealer_total)) || ((player_bust && dealer_bust) && (player_bust_total > dealer_bust_total))
    say("You Won, #{player_name}!")
  else
    say("You Lost, #{player_name}. Better luck next time!")
  end
end

def play_again?
  yes_or_no?('Do you want to play again? [Y/N]')
end

def initialize_deck
  deck = []
  suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  ranks = ['Ace', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven',
           'Eight', 'Nine', 'Ten', 'Jack', 'Queen', 'King']
  suits.each do |suit|
    ranks.each do |rank|
      if rank == 'Ace'
        deck << {rank: rank, suit: suit, value_1: 1, value_2: 11}
      elsif rank == 'Jack' || rank == 'Queen' || rank == 'King'
        deck << {rank: rank, suit: suit, value: 10}
      else
        deck << {rank: rank, suit: suit, value: ranks.index(rank) + 1}
      end
    end
  end
  deck.shuffle!
end

def shuffle_deck(deck)
  cut = deck.slice!((24 + (rand 5))..51)
  cut.each_with_index do |card, index|
    deck.insert((index - 1) + (rand 2), card)
  end
end

def deal_starting_hands(deck)
  player_hand = []
  dealer_hand = []
  player_hand << deck.shift
  dealer_hand << deck.shift
  player_hand << deck.shift
  dealer_hand << deck.shift
  [player_hand, dealer_hand]
end

def discard_hands(player_hand, dealer_hand, discard_pile)
  discard_pile << player_hand
  discard_pile << dealer_hand
  discard_pile.flatten!
end

def hand_contains_ace?(hand)
  false
  true if hand.select{|card| card[:rank] == 'Ace'}.count > 0
end

def number_of_aces(hand)
  hand.select{|card| card[:rank] == 'Ace'}.count
end

def calculate_hand_total(hand)
  total = 0
  aces = number_of_aces(hand)
  hand.each do |card|
    next if card[:rank] == 'Ace'
    total += card[:value]
  end
  if aces > 0
    total += aces if (total + 10 + aces > 21) || (total + aces >= 21)
    total += 10 + aces if (total + 10 + aces <= 21)
  end
  total
end

def calculate_bust_total(hand)
  total = calculate_hand_total(hand)
  aces = number_of_aces(hand)
  total += 10 * aces
end

def stay?
  say('HIT or STAY?', 'Your Turn')
  loop do
    input = gets.chomp.downcase
    unless (input == 'hit') || (input == 'stay')
      say "Invalid input. \n" + 'Choose HIT or STAY.'
    end
    return true if input == 'stay'
    return false if input == 'hit'
  end
end

def hit(deck, hand)
  hand << deck.shift
end

def blackjack?(hand)
  false
  true if calculate_hand_total(hand) == 21
end

def bust?(hand)
  false
  true if calculate_hand_total(hand) > 21
end

system 'clear'
deck = initialize_deck
discard_pile = []
name = get_player_name
say("Hi, #{name}!")
begin
  explain_rules
end until gets.chomp
loop do
  starting_hands = deal_starting_hands(deck)
  announce_player_hand(player_hand = starting_hands[0], name)
  announce_dealer_hand(dealer_hand = starting_hands[1])
  unless blackjack?(player_hand)
    until stay?
      hit(deck, player_hand)
      announce_player_hand(player_hand, name)
      announce_dealer_hand(dealer_hand)
      break if  blackjack?(player_hand) || bust?(player_hand)
    end
  end
  announce_player_hand(player_hand, name)
  announce_player_results(player_hand, name)
  until calculate_hand_total(dealer_hand) >= 17
    hit(deck, dealer_hand)
  end
  announce_dealer_hand(dealer_hand, true)
  announce_dealer_results(dealer_hand)
  announce_final_results(player_hand, dealer_hand, name)
  break unless play_again?
  discard_hands(player_hand, dealer_hand, discard_pile)
  if deck.count < 26
    deck += discard_pile
    shuffle_deck(deck)
  end
end
say("Thanks for playing, #{name}!")
