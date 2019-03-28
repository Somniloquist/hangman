#!/usr/bin/env ruby

class Game
  attr_reader :dictionary, :min_length, :max_length, :max_guesses, :secret_word
  attr_accessor :guesses, :hidden_word, :used_letters
  def initialize(dictionary, input = {})
    @dictionary = dictionary
    @min_length = input.fetch(:min_length, 1)
    @max_length = input.fetch(:max_length, 12)
    @max_guesses = input.fetch(:max_guesses, 6)
    @guesses = 0
    @secret_word = input.fetch(:secret_word, set_secret_word)
    @hidden_word = "_" * secret_word.length
    @used_letters = []
  end

  public
  def play
    max_guesses.times do 
      puts("Word:\t#{@hidden_word}")
      puts("Miss:\t#{@used_letters.join}")
      guess = solicit_guess
    end
    puts("GAME OVER")
  end

  private
  def solicit_guess
    loop do
      print("Guess a letter: ")
      letter = gets.chomp
      return letter if valid_guess?(letter)
    end
  end

  def valid_guess?(string)
    string.length == 1 && string.match(/[a-z]/) ? true : false
  end

  def set_secret_word
    @dictionary.select { |word| word.length >= @min_length && word.length <= @max_length}.sample.downcase
  end

  def game_won?
    @secret_word == @guess
  end

end

dictionary = File.read("dictionary.txt").split
game = Game.new(dictionary)
puts("Welcome to hangman!")
game.play

# puts("DEBUG - Word:\t#{game.secret_word}")
# puts("DEBUG - Guess:\t#{game.guess}")