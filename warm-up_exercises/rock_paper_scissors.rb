# I wrote my rock-paper-scissors code this way for fun. I know it's not as
# tight as it could be, but I wanted to isolate the logic into methods,
# and declare a constant, just to get used to doing it in ruby. :3

CHOICES = ['Rock', 'Paper', 'Scissors']

def say(msg, title = nil)
  unless title == nil
    puts title.center(62, '~')
  end
  puts  "=> #{msg}".ljust(62)
end

def valid_user_turn(rps)
  if rps.downcase != 'r' && rps.downcase != 'p' && rps.downcase != 's'
    say("Invalid choice. Choose one: [R/P/S]")
    valid_user_turn(gets.chomp)
  end
  case rps.downcase
  when 'r'
    say("You chose Rock.")
    return 'Rock'
  when 'p'
    say("You chose Paper.")
    return 'Paper'
  when 's'
    say("You chose Scissors.")
    return 'Scissors'
  end
end

def computer_turn
  random_choice = CHOICES.sample
  say("The computer chose #{random_choice}.")
  random_choice
end

def winning_message(winning_choice)
  case
  when 'Rock'
    say('Rock smashes scissors!', 'Results!')
  when 'Paper'
    say('Paper covers rock!', 'Results!')
  when 'Scissors'
    say('Scissors cuts paper!', 'Results!')
  end
end

def calculate_results(user_choice, computer_choice)
  if user_choice == computer_choice
    say("It's a tie!", 'Results!')
  elsif (user_choice == 'Rock' && computer_choice == 'Scissors') || (user_choice == 'Paper' && computer_choice == 'Rock') || (user_choice == 'Scissors' && computer_choice == 'Paper')
    winning_message(user_choice)
    say('You win!')
  else
    winning_message(computer_choice)
    say('You lose!')
  end
end

def play_again?
  say('[Y/N]', 'Play again?')
  y_n = gets.chomp
  if y_n.downcase != 'y' && y_n.downcase != 'n'
    say('Invalid choice.')
    play_again?
  end
  y_n.downcase == 'y' ? (return true) : (return false)
end

loop do
say('Choose one: [R/P/S]', "Let's Play Rock Paper Scissors!")
user_choice = valid_user_turn(gets.chomp)
computer_choice = computer_turn
game_result = calculate_results(user_choice, computer_choice)
break unless play_again? == true
end
say('Thanks for playing!')
