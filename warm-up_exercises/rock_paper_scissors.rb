# I wrote my rock-paper-scissors code this way for fun. I know it's not as
# tight as it could be, but I wanted to isolate all of the logic into methods,
# and provide validation on user inputs, just to get used to doing it in ruby. :3

# Stretch goals: Add in scorekeeping functionality, match results, & make the
# computer ask for 3 games of 5, 5 of 7, etc. if it's losing. I also  want to
# be able to ask the computer if it will go 3 of 5, 5 of 7, etc., with the
# computer randomly accepting or denying the request.

CHOICES = ['Rock', 'Paper', 'Scissors']

# Outputs a message, with an option, fancy-formatted title.
def say(msg, title = nil)
  unless title == nil
    puts title.center(62, '~')
  end
  puts  "=> #{msg}".ljust(62)
end

# Validates that user input 'r', 'p', or 's', and returns a capitalized
# string that equates to the users choice (i.e. 'r' => 'Rock').
def user_turn
  input = ''
  x = 1
  while input.downcase != 'r' && input.downcase != 'p' && input.downcase != 's'
    if x != 1
      say("Invalid choice. Rock, Paper, or Scissors? [R/P/S]")
    end
      input = gets.chomp
      x += 1
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

# Returns a random choice, 'Rock', 'Paper', or 'Scissors'.
def computer_turn
  CHOICES.sample
end

# Called inside print_results, this method prints an exciting sentence about the
# results, simulating the action of the real game! lol
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

# Validates and returns a user's response (Y/N) when asked to play again.
def again_response
  input = ''
  x = 1
  while input.downcase != 'y' && input.downcase != 'n'
    if x != 1
      say('Invalid choice. Play again? [Y/N]')
    end
    input = gets.chomp
    x += 1
  end
  input.downcase
end

loop do
system 'clear'
say('Choose one: [R/P/S]', "Let's Play Rock Paper Scissors!")
player_choice = user_turn
computer_choice = computer_turn
say("You chose #{player_choice}.", 'Results!')
say("The computer chose #{computer_choice}.")
print_results(player_choice, computer_choice)
say('Choose: [Y/N]', 'Play again?')
break unless again_response.downcase == 'y'
end
say('Thanks for playing!')
