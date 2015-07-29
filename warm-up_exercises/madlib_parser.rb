# pseudo-code:
# read a file containing libraries of various parts of speech
# parse both files to identify libraries, and placeholders within the madlib
# replace instances of placeholders (NOUN, VERB, ADJ, etc.) with random words
# from the external file's libraries.

nouns = ['elephant', 'tire',' stake', 'fire', 'yield', 'buckyballs',
         'mammal', 'airplane', 'telephone', 'macroeconomics']
verbs = ['feel', 'touch', 'taste', 'smell', 'hear',
         'run', 'trip', 'cringe', 'squeal']
adjectives = ['cloudy', 'hungry', 'opaque', 'burly', 'gamey', 'nimble',
              'irate', 'docile', 'green', 'fine', 'rich', 'unfit']

def say(msg)
  puts("=> #{msg}.")
end

def exit_with(msg)
  say msg
  exit
end

exit_with('No filename provided.') if ARGV[0].empty?
exit_with('File not found.') if !File.exists?(ARGV[0])

contents = File.open(ARGV[0], 'r') do |file|
  file.read
end

contents.gsub!('NOUN').each { |noun| nouns.sample }
contents.gsub!('VERB').each { |verb| verbs.sample }
contents.gsub!('ADJECTIVE') { |adjective| adjectives.sample }
say contents
