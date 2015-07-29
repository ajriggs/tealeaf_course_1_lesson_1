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

# stretch goals: Add in betting/money pool, w/ running out
# of money as a gameOver condition. Add in multiplayer.

require 'pry'

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
  return name
end

def explain_rules
  if yes_or_no?("Would you like me to explain the rules? [Y/N]")
    system 'clear'
    say(nil, 'Rules')
    say("I'll deal us each two cards. Your cards are visible to all, \n" +
        "but you can only see the first card that I deal to myself. \n" +
        "Try to make the value of your cards total 21, but no higher. \n \n" +
        "Aces are worth 11, unless 11 would make you bust. Then, \n" +
        "Aces are automatically worth 1 instead. Face cards are \n" +
        "each worth 10, and numbered cards are worth their number. \n \n" +
        "After dealing, I'll ask you: HIT or STAY? If you HIT, \n" +
        "you'll get another card. If you haven't busted (22+), \n" +
        "or gotten blackjack (21), you can HIT again, or STAY. \n" +
        "Choose 'STAY' at any point to end your turn. \n \n" +
        "I'll reveal my cards at the end, and unless you bust, \n" +
        "if your cards total higher than mine, you win! If we \n" +
        "both bust, the person with the highest total wins. \n \n" +
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
  randomize_order(deck)
  deck
end

def randomize_order(deck)
  shuffled = []
  while deck.count > 0
    random_card_index = rand(deck.count - 1)
    shuffled << deck[random_card_index]
    deck.delete_at(random_card_index)
  end
  shuffled.each { |card| deck << card }
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

def hand_contains_ace?(hand)
  hand.each do |card|
    return true if card[:rank] == 'Ace'
  end
  false
end

def number_of_aces(hand)
  aces = 0
  hand.each do |card|
    aces += 1 if card[:rank] == 'Ace'
  end
  aces
end

def calculate_hand_total(hand)
  total = 0
  aces = number_of_aces(hand)
  hand.each do |card|
    next if card[:rank] == 'Ace'
    total += card[:value]
  end
  if aces > 0
    total += aces if (total + 11 + (aces - 1) > 21) || (total + aces) >= 21
    total += (11 + (aces - 1)) if (total + 11 + (aces - 1) <= 21)
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

system 'clear'
deck = initialize_deck
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
end
say("Thanks for playing, #{name}!")
