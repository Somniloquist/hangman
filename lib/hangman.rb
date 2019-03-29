#!/usr/bin/env ruby
require "yaml"

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
    show_welcome_message
    while guesses >= 0 do 
      show_game_state
      guess = solicit_guess
      if guess == "save"
        save_game
      elsif @secret_word.include?(guess)
        reveal_letters(guess)
      else
        @used_letters << guess
        @guesses -= 1
      end

      if game_won?
        puts("YOU WIN")
        exit_game
      end
    end

    game_over = true
    show_game_state(game_over)
  end

  private
  def save_game
    yaml = YAML::dump(self)
    save_file = File.open("save.yaml", "w")
    save_file.puts(yaml)
    puts("Game saved.")
    save_file.close
  end

  def reveal_letters(guess)
    @secret_word.each_with_index do |secret_letter, i|
      hidden_word[i] = guess if guess == secret_letter
    end
  end

  def solicit_guess
    loop do
      print("Guess a letter: ")
      input = gets.downcase.chomp
      return input if valid_guess?(input) || input == "save"
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

  def show_game_state(game_over = false)
    game_over ? puts("YOU LOSE\nSecret:\t#{@secret_word.join}") : puts("Left:\t#{@guesses}")
    puts("Word:\t#{@hidden_word.join}")
    puts("Miss:\t#{@used_letters.join}")
  end

  def show_welcome_message
    puts("Welcome to hangaman!")
  end

end

dictionary = File.read("dictionary.txt").split
game = Game.new(dictionary, {secret_word: "robin".split("")})

game.play