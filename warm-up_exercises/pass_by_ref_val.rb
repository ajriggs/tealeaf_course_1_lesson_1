def take_array(array)
  array += ['string']
end
array = [1, 2, 3]
puts "The take_array method returns #{take_array(array)}..."
puts "but our original array remains unchanged: #{array}!"
puts
def mutate_array(array)
  array << 'string'
end
puts "The mutate_array method also returns #{mutate_array(array)}..."
puts "but it modifies our original array too: #{array}!"
puts
