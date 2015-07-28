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
  if title
    puts title.center(62, '~')
  end
  puts  "=> #{msg}".ljust(62)
end

def initialize_board
  board = {}
  (1..9).each { |position| board[position] = ' '}
  board
end

def draw_board(board)
  system 'clear'
  puts "     |     |     "
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
  puts "_____|_____|_____"
  puts "     |     |     "
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}  "
  puts "_____|_____|_____"
  puts "     |     |     "
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
  puts "     |     |     "
end

def empty_squares(board)
  board.select {|_position, value| value == ' ' }.keys
end

def winning_lines
  [[1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 2, 3],
  [4, 5, 6], [7, 8, 9], [1, 5, 9], [3, 5, 7]]
end

def current_lines_contents(board, winning_lines)
  current_lines = []
  winning_lines.each do |line|
    current_lines << {line[0] => board[line[0]], line[1] => board[line[1]], line[2] => board[line[2]]}
  end
  current_lines
end

def square_to_win(line, player_marker)
  if (line.values.count(player_marker) == 2)
    line.select{|_position, value| value == ' '}.keys.first
  else
    false
  end
end

def square_to_block(line, opponent_marker)
  if (line.values.count(opponent_marker) == 2)
    line.select{|_position, value| value == ' '}.keys.first
  else
    false
  end
end

def player_chooses_square(board)
  loop do
    chosen_square = gets.chomp
    if chosen_square == 'help'
      say('Board is numbered 1-9, with 1 on the top-left, '\
      'and 9 at the bottom-right. Type "help" to repeat this.')
    elsif empty_squares(board).include?(chosen_square.to_i)
      board[chosen_square.to_i] = 'X'
      break
    else
      system 'clear'
      draw_board(board)
      say("You can't do that. Please choose from one of the following locations: "\
      "#{empty_squares(board)}.", 'Invalid Option')
    end
  end
end

def computer_chooses_square(board, opponent_marker, player_marker)
  lines = current_lines_contents(board, winning_lines)
  chose = false
  lines.each do |position, value|
    win_position = square_to_win(position, player_marker)
    block_position = square_to_block(position, opponent_marker)
    if win_position
      board[win_position] = player_marker
      chose = true
      break
    elsif block_position
      board[block_position] = player_marker
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
  if winner || empty_squares(board).empty?
    true
  else
    false
  end
end

def play_again?(board)
  say("Choose [Y/N]", 'Continue Playing?')
  loop do
    input = gets.chomp
    unless input.downcase == 'y' || input.downcase == 'n'
      system 'clear'
      draw_board(board)
      say("Play again? [Y/N]", 'Invalid Option')
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
  say('Board is numbered 1-9, with 1 on the top-left, '\
  'and 9 at the bottom-right.', "Let's Play Tic-Tac-Toe!")
  loop do
    player_chooses_square(game_board)
    draw_board(game_board)
    winner = check_winner(game_board, winning_lines)
    break if game_over?(winner, game_board)
    computer_chooses_square(game_board, 'X', 'O')
    draw_board(game_board)
    winner = check_winner(game_board, winning_lines)
    break if game_over?(winner, game_board)
    say("Remaining spots: #{empty_squares(game_board)}", 'Pick again')
  end
  announce_winner(winner)
end while play_again?(game_board)
