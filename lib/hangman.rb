#!/usr/bin/env ruby
require "yaml"
require "fileutils"

class Game
  SAVE_FILE_DIR = "./save/"
  attr_reader :dictionary, :secret_word
  attr_accessor :guesses, :hidden_word, :used_letters
  def initialize(input = {})
    @guesses = input.fetch(:guesses, 6)
    @secret_word = input.fetch(:secret_word)
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

  def self.load_game
    save_file = File.open("save.yaml", "r")
    game_data = YAML::load(save_file)
  end

  private
  def save_game
    yaml = YAML::dump(self)
    FileUtils.mkdir(SAVE_FILE_DIR) unless File.directory?(SAVE_FILE_DIR)
    File.open("#{SAVE_FILE_DIR}/save#{save_file_count}.yaml", "w") {|save_file| save_file.puts(yaml)}
    puts("Game saved.")
  end

  def save_file_count
    Dir.glob("#{SAVE_FILE_DIR}/save*.yaml").length
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

  def game_won?
    @secret_word == @hidden_word
  end

  def show_game_state(game_over = false)
    game_over ? puts("YOU LOSE\nSecret:\t#{@secret_word.join}") : puts("Left:\t#{@guesses}")
    puts("Word:\t#{@hidden_word.join}")
    puts("Miss:\t#{@used_letters.join}")
  end

  def show_welcome_message
    puts("=== Welcome to hangaman! ===")
    puts("Type 'save' to save your save your progress.")
    puts("============================")
  end

end

def get_save_files
  Dir.glob("saves/save*.yaml")
end

def show_save_files
  save_files = get_save_files
  save_files.each_with_index do |file, i|
    puts("[#{i}] - #{file}")
  end
end

def show_menu
  puts("[1] START GAME")
  puts("[2] LOAD GAME")
end

def get_menu_input
  loop do 
    print(">> ")
    input = gets.chomp
    return input if input == "1" || input == "2"
  end
end

def get_load_save_input
  save_files = get_save_files.length
  loop do
    print(">> ")
    input = get.chomp
    return input if input.to_i <=save_files && input >= 1
  end
end

def get_secret_word(dictionary, min_length, max_length)
  dictionary.select { |word| word.length >= min_length && word.length <= max_length}.sample.downcase.split("")
end

def setup
  show_menu
  input = get_menu_input
  case input
  when "1"
    dictionary = File.read("dictionary.txt").split
    secret_word = get_secret_word(dictionary, 1, 12)
    Game.new({secret_word: secret_word})
  when "2"
    show_save_files

    # Game.load_game
  end
end

game = setup
game.play