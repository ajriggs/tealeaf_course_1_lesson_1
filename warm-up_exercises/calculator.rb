def say(msg, title = nil)
  unless title == nil
    puts title.center(62, '~')
  end
  puts  "=> #{msg}".ljust(62)
end

loop do
  say('Please enter a number:','First Number')
  num1 = gets.chomp
  say("You entered #{num1}.")
  say('Enter another number:', 'Second Number')
  num2 = gets.chomp
  say("You entered #{num2}")
  say('Choose an operator, one through four:', 'Calculate!')
  say('1. Add 2. Subtract 3. Multiply 4. Divide')
  operator = gets.chomp
  case operator
  when '1'
    say("#{num1} + #{num2} = #{num1.to_f + num2.to_f}", 'calculating...')
  when '2'
    say("#{num1} - #{num2} = #{num1.to_f - num2.to_f}", 'calculating...')
  when '3'
    say("#{num1} x #{num2} = #{num1.to_f * num2.to_f}", 'calculating...')
  when '4'
    say("#{num1} ÷ #{num2} = #{num1.to_f / num2.to_f}", 'calculating...')
  else
    say("Oops! Something went wrong. Try again :)")
  end
  say('Enter "Y" or "N":', 'Would you like to calculate again?')
  again = gets.chomp
  break if again == "N" || if again == ''
  end
end
