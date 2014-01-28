require 'CardSuit'
require 'singleton'

## 
# CardSuits class
#
# CardSuits is a singleton of an array of the valid CardSuits in Blackjack
#
# Instantiation:
#   suits = CardSuits.instance
#
# NOTE: You MUST call assign_card_suits in order to fill the card
#   ranks, else they will be empty!
##

class CardSuits < Array

    include Singleton

    def assign_card_suits
        
        if !@assigned
            suits = CardSuit.suits_const
            for index in 0..(suits.length - 1)
                self[index] = CardSuit.new(suits[index])
            end

            @assigned = true
        end
    end

end

