a = 'hi there'
b = a
a.gsub!(' ', '_')
puts b => # => 'hi_there', b/c we mutated the caller w/ gsub!, and b
# points to the same place space in memory as a.

a = 'hi there'
b = a
a = [1, 2, 3]
puts b # => 'hi there', b/c a is now referencing a new space in memory,
# but b still points to the old space (same object ID as old a).
