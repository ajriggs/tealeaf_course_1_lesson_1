#  draw a board of squares (3x3)
#  until winner, or all squares filled
#    player picks a square, draws symbol
#    computer picks a square, draws symbol
#    check for winner
#  if there's a winner
#    call out winner
#  or if there's no winner
#    say it's a tie

# Future stretch goals: roll a die to see who goes first, or inherit
# from rock paper scissors, and play that game to determine who goes first!

def say(msg, title = nil)
  unless title == nil
    puts title.center(62, '~')
  end
  puts  "=> #{msg}".ljust(62)
end

def initialize_board
  board = {}
  (1..9).each { |position| board[position] = ' '}
  board
end

def draw_board(b)
  system 'clear'
  puts "     |     |     "
  puts "  #{b[1]}  |  #{b[2]}  |  #{b[3]}  "
  puts "_____|_____|_____"
  puts "     |     |     "
  puts "  #{b[4]}  |  #{b[5]}  |  #{b[6]}  "
  puts "_____|_____|_____"
  puts "     |     |     "
  puts "  #{b[7]}  |  #{b[8]}  |  #{b[9]}  "
  puts "     |     |     "
end

def empty_squares(board)
  empty_positions = board.select {|k, v| v == ' ' }.keys
end

def winning_lines
  winning_lines = [[1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 5, 9], [3, 5, 7]]
end

def current_lines_contents(board, winning_lines)
  current_lines = []
  winning_lines.each { |line| current_lines << {line[0] => board[line[0]], line[1] => board[line[1]], line[2] => board[line[2]]} }
  current_lines
end

def square_to_win(line, player_marker)
  if (line.values.count(player_marker) == 2)
    square_to_block = line.select{|k,v| v == ' '}.keys.first
    return square_to_block
  else
    false
  end
end

def square_to_block(line, opponent_marker)
  if (line.values.count(opponent_marker) == 2)
    square_to_block = line.select{|k,v| v == ' '}.keys.first
    return square_to_block
  else
    false
  end
end

def player_chooses_square(board)
  loop do
    chosen_square = gets.chomp
    if chosen_square == 'help'
      say('Board is numbered 1-9, with 1 on the top-left, and 9 at the bottom-right. Type "help" to repeat this.')
    elsif empty_squares(board).include?(chosen_square.to_i)
      board[chosen_square.to_i] = 'X'
      break
    else
      say("You can't do that. Please choose from one of the following locations: #{empty_squares(board)}.")
    end
  end
end

def computer_chooses_square(board, opponent_marker, player_marker)
  lines = current_lines_contents(board, winning_lines)
  chose = false
  lines.each do |position, value|
    block_position = square_to_block(position, opponent_marker)
    win_position = square_to_win(position, player_marker)
    if block_position
      board[block_position] = player_marker
      chose = true
      break
    elsif win_position
      board[win_position] = player_marker
      chose = true
      break
    end
  end
  unless chose == true
    if board[5] == ' '
      board[5] = player_marker
    else
      board[empty_squares(board).sample] = player_marker
    end
  end
end

def check_winner(board, winning_lines)
  winning_lines.each do |line|
    if board.values_at(*line).count('X') == 3
      return 'Player'
    elsif board.values_at(*line).count('O') == 3
      return 'Computer'
    end
  end
  return false
end

def game_over?(winner, board)
  if winner != 'false' || empty_squares(board).empty?
    return true
  else
    winner.clear
    return false
  end
end

def play_again?
  say("Choose [Y/N]", 'Continue Playing?')
  loop do
    input = gets.chomp
    unless input.downcase == 'y' || input.downcase == 'n'
      say("Invalid option. Play again? [Y/N]")
    end
    case input.downcase
    when 'y'
      return true
    when 'n'
      say('Thanks for playing!')
      return false
    end
  end
end

def announce_winner(winner)
  if winner == 'Player'
    say 'You won!'
  elsif winner == 'Computer'
    say 'You lost!'
  else
    say "It's a tie!"
  end
end

begin
  game_board = initialize_board
  draw_board(game_board)
  winner = ''
  loop do
    player_chooses_square(game_board)
    draw_board(game_board)
    winner << check_winner(game_board, winning_lines).to_s
    break if game_over?(winner, game_board)
    computer_chooses_square(game_board, 'X', 'O')
    draw_board(game_board)
    winner << check_winner(game_board, winning_lines).to_s
    break if game_over?(winner, game_board)
    say("Remaining spots: #{empty_squares(game_board)}", 'Pick again')
  end
  announce_winner(winner)
end until play_again? == false
