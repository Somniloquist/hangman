#!/usr/bin/env ruby

class Game
  attr_reader :dictionary, :min_length, :max_length, :secret_word
  attr_accessor :guesses, :hidden_word, :used_letters
  def initialize(dictionary, input = {})
    @dictionary = dictionary
    @min_length = input.fetch(:min_length, 1)
    @max_length = input.fetch(:max_length, 12)
    @guesses = input.fetch(:guesses, 6)
    @secret_word = input.fetch(:secret_word, set_secret_word)
    @hidden_word = Array.new(secret_word.length) { "_" }
    @used_letters = []
  end

  public
  def play
    while guesses >= 0 do 
      puts ("Guesses:\t#{guesses}")
      puts("Word:\t\t#{@hidden_word.join}")
      puts("Miss:\t\t#{@used_letters.join}")
      guess = solicit_guess
      if @secret_word.include?(guess)
        reveal_letters(guess)
      else
        @used_letters << guess
        @guesses -= 1
      end

      break if game_won?
    end

    game_won? ? puts("YOU WIN") : puts("YOU LOSE")
  end

  private
  def reveal_letters(guess)
    @secret_word.each_with_index do |secret_letter, i|
      hidden_word[i] = guess if guess == secret_letter
    end
  end

  def solicit_guess
    loop do
      print("Guess a letter: ")
      letter = gets.downcase.chomp
      return letter if valid_guess?(letter)
    end
  end

  def valid_guess?(string)
    string.length == 1 && string.match(/[a-z]/) ? true : false
  end

  def set_secret_word
    @dictionary.select { |word| word.length >= @min_length && word.length <= @max_length}.sample.downcase.split("")
  end

  def game_won?
    @secret_word == @hidden_word
  end

end

dictionary = File.read("dictionary.txt").split
my_secret_word = "hellow".split("")
game = Game.new(dictionary)
puts("Welcome to hangman!")
game.play

# puts("DEBUG - Word:\t#{game.secret_word}")
# puts("DEBUG - Guess:\t#{game.guess}")