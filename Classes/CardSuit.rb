
## 
# CardSuit class
#
# CardSuit represents the suit of a card.  The options are (Clubs, Diamonds,
#   Hearts, and Spade)
#
# A CardSuit has a single read-only attribute (assigned at instantiation)
# - name    (the string of the suit)
#
# Instantiation:
#   cs = CardSuit.new(String name)
#
##

class CardSuit
  
    # setup read-only attributes
    attr_reader :name
    
    # Constant array for card suit names
    SUITS_CONST = ["Clubs", "Diamonds", "Hearts", "Spades"]

    def self.suits_const
        # getter method for suits_const
        return SUITS_CONST
    end

    def initialize (name)
        if SUITS_CONST.include?(name)
            @name = name
        else
            @name = nil
        end
    end

    def is_valid
        if SUITS_CONST.include?(name)
            return true
        else
            return false
        end
    end

end
