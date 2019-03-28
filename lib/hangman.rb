#!/usr/bin/env ruby

class Game
  attr_reader :dictionary, :min_length, :max_length, :max_guesses, :secret_word
  attr_accessor :guesses
  def initialize(dictionary, input = {})
    @dictionary = dictionary
    @min_length = input.fetch(:min_length, 1)
    @max_length = input.fetch(:max_length, 12)
    @max_guesses = input.fetch(:max_guesses, 6)
    @guesses = 0
    @secret_word = input.fetch(:secret_word, set_secret_word)
  end

  private
  def set_secret_word
    @dictionary.select { |word| word.length >= @min_length && word.length <= @max_length}.sample
  end
end

dictionary = File.read("dictionary.txt").split
game = Game.new(dictionary)
puts("Word: #{game.secret_word}")