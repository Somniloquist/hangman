#!/usr/bin/env ruby
puts "Welcome to Hangman!"

def get_random_word(word_array, min_length = 1, max_length = 12)
  word_array.select { |word| word.length >= min_length && word.length <= max_length}.sample
end

dictionary = File.read("dictionary.txt").split
secret_word = get_random_word(dictionary)

puts("Word: #{secret_word}")