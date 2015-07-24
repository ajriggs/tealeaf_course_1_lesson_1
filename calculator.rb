def say(msg)
  puts "=> #{msg}"
end
say("What's the first number?")
num_1 = gets.chomp
say("What's the second number?")
num_2 = gets.chomp
say("1. Add 2. Subtract 3. Multiply 4. Divide")
operator = gets.chomp
print operator
case operator
  when "1"
    result = num_1.to_f + num_2.to_f
  when "2"
    result = num_1.to_f - num_2.to_f
  when "3"
    result = num_1.to_f * num_2.to_f
  when "4"
    result = num_1.to_f / num_2.to_f
  else
    puts "oops!, try again."
end
say "Result: #{result}"
