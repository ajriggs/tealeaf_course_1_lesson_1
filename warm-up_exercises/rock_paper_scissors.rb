# I wrote my rock-paper-scissors code this way for fun. I know it's not as
# tight as it could be, but I wanted to isolate all of the logic into methods,
# and provide validation on user inputs, just to get used to doing it in ruby. :3

# Stretch goals: add in scorekeeping functionality, match results, & make computer
# ask for 3 games of 5, 5 of 7, etc. if it's losing. I also  want to be able to ask
# the computer if it will go 3 of 5, 5 of 7, etc., with computer
# randomly accepting or denying the request.

CHOICES = ['Rock', 'Paper', 'Scissors']

def say(msg, title = nil)
  unless title == nil
    puts title.center(62, '~')
  end
  puts  "=> #{msg}".ljust(62)
end

def user_turn
  input = ''
  loop do
    input << gets.chomp
    if input.downcase != 'r' && input.downcase != 'p' && input.downcase != 's'
      say("Invalid choice. Rock, Paper, or Scissors? [R/P/S]")
      input.clear
    end
    break if input.downcase == 'r' || input.downcase == 'p' || input.downcase == 's'
  end
  case input.downcase
  when 'r'
    return 'Rock'
  when 'p'
    return 'Paper'
  when 's'
    return 'Scissors'
  end
end

def computer_turn
  CHOICES.sample
end

def print_winning_message(winning_choice)
  case
  when 'Rock'
    say('Rock smashes scissors!')
  when 'Paper'
    say('Paper covers rock!')
  when 'Scissors'
    say('Scissors cuts paper!')
  end
end

def print_results(user_choice, computer_choice)
  if user_choice == computer_choice
    say("It's a tie!")
  elsif (user_choice == 'Rock' && computer_choice == 'Scissors') || (user_choice == 'Paper' && computer_choice == 'Rock') || (user_choice == 'Scissors' && computer_choice == 'Paper')
    print_winning_message(user_choice)
    say('You win!')
  else
    print_winning_message(computer_choice)
    say('You lose!')
  end
end

def response
  input = ''
  loop do
    input << gets.chomp
    if input.downcase != 'y' && input.downcase != 'n'
      say('Invalid choice. Play again? [Y/N]')
      input.clear
    end
    break if input.downcase == 'y' || input.downcase == 'n'
  end
  input.downcase
end

loop do
say('Choose one: [R/P/S]', "Let's Play Rock Paper Scissors!")
player_choice = user_turn
computer_choice = computer_turn
say("You chose #{player_choice}.", 'Results!')
say("The computer chose #{computer_choice}.")
print_results(player_choice, computer_choice)
say('[Y/N]', 'Play again?')
break unless response.downcase == 'y'
end
say('Thanks for playing!')
