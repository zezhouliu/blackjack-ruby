require 'Game'
require 'Helper'

# Prompt for Player name and amount

def play
    puts "What is your name? "
    name = gets.chomp
    
    # default name
    if name.length < 1
        name = "Alex"
    end

    puts "How much would you like to buy in? (number in dollars)"
    amount = gets.to_i
   
    # default to 1000
    if amount == 0
        amount = 1000
    end

    game = Game.new(name, amount)
    game.play
end

def main
    begin
        play
    end while bool_prompt("Would you like to play a game of Blackjack?")
end

if __FILE__ == $0
    main
end
