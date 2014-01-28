require 'Card'

## 
# BlackJackCard class
#
# BlackJackCard subclasses the Card class and adds several methods that
#   are particularly useful for Black Jack.  
#
# Instantiation:
#   bjc = BlackJackCard.new(CardRank r, CardSuit s)
#
##

class BlackJackCard < Card

    # returns whether the card is an Ace so that
    # it can have either a value of 1 or 11
    # Let the Hand class handle how this will be used
    def is_ace?

        if @rank.type == CardType::ACE_TYPE
            return true
        end
        
        return false
    end

    # returns whether the card is a face card
    def is_face?

        if @rank.type == CardType::FACE_TYPE
            return true
        end

        return false
    end

end
