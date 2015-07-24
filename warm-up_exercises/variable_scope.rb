# exercise 1a
x = 4

loop do
  x = 'hey there'
  break
end

puts x # => nil, x = 'hey there'

# exercise 1b
def no_mutate(arr)
  arr.uniq
end
my_arr = [1, 2, 2, 3]
no_mutate(my_arr)
puts my_arr # outputs [1, 2, 2, 3] => nil

# exercise 1c
def yes_mutate(arr)
  arr.uniq!
end
yes_mutate(my_arr)
puts my_arr # => outputs [1, 2, 3] => nil

# exercise 2a
def method(obj)
  a = 1
  obj
end
puts a # => Returns error, because a is undefined outside of method's scope.

# exercise 2b
# N0TE: The hash variable is set to { a: 27, b: 27, c: 27, etc} after running
# the code below. I wrote this as am example of how variable scope works with
# nested blocks, not to make a more reasonable hash of {a: 1, b: 2, c: 3, etc.}.
# Nesting .each iterators is a bad way to try and do that w/ this data sructure.
array1 = (:a..:z).to_a
array2 = (1..26).to_a
hash = {}
array1.each do |sym|
  x = 1
  puts "In the first iteration block, x is #{x}"
  array2.each do |num|
    x += 1
    puts "In the second interation block, x is #{x}"
    y = 2
    puts "And we have a new variable: y = #{y}"
    hash[sym] = num
  end
  puts "Now we're back in the first block, and x is still #{x}, like in block 2!"
  puts "Y is #{y}" rescue puts "But Y is now out of scope!"
  puts "Here is our hash: #{hash}"
end
puts "Here's the hash again, outside of all blocks: #{hash}"

# exercise 3
x = 'hi'
def my_method
  puts x
end

my_method
# => undefined variable error. we have not declared x inside the method,
# and no value was passed in for x as a method parameter.
