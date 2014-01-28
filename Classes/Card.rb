require 'CardSuits'
require 'CardRanks'

## 
# Card class
#
# Card represents the simple card in a deck of cards.  
#
# A Card has multiple read-only attributes (assigned at instantiation)
# - rank    (an abstraction of A,J,Q,K, 2-10 and their values)
# - suit    (Clubs, Diamond, Hearts, and Spade)
# - name    (Concatenation of rank and suit: i.e. Ace of Spades)
#
# The read-only properties that can be checked
#   - valid (if the card has valid assignments)
#
# Instantiation:
#   c = Card.new(CardRank r, CardSuit s)
#
# NOTE: please use BlackJackCard for extra useful methods for
# the game of BlackJack
##

class Card
    
    attr_reader :rank
    attr_reader :suit
    attr_reader :valid
    attr_reader :name

    # initializer
    def initialize(rank, suit)
        
        # safety check for rank and suit
        if (!rank.kind_of? CardRank) || (!suit.kind_of? CardSuit)
            puts 'Error initializing class'
            @rank = nil
            @valid = false
            return
        end

        # set up the read-only Card attributes
        @rank = rank
        @suit = suit
        @valid = true

        # if card is valid, give it a name
        if @valid == true
            @name = @rank.name + ' of ' + @suit.name
        else
            puts 'Not Valid Card'
            @name = nil
        end
 
    end

    def to_s
        return @name
    end

   
end
