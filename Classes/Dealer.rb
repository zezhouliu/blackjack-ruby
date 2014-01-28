## 
# Dealer class
#
# A Dealer represents the dealer in the BlackJack game. Functionality of
# a dealer was significantly different enough from a Player that they are
# two independent classes
#
# A Dealer has multiple read-only attributes
# - name (Constant name)
# - net_value (Amount won/lost in current game)
# - hand (single hand that the Dealer controls)
#
# Instantiation:
#   d = Dealer.new

class Dealer

    DEALER_NAME_CONST = 'Dealer'
    
    # assign read-only and accessible attributes
    attr_reader :name
    attr_reader :net_value
    attr_reader :hand

    ERR_NOT_ENOUGH_MONEY = 'You do not have enough money to make that bet.'
    ERR_NO_ACTIVE_BET = 'You currently do not have an active bet'
    ERR_ACTIVE_BET = 'You currently already have an active bet'
    ERR_INVALID_BET = 'Invalid bet. Please enter an Integer bet amount'

    # initializes dealer with net_value of 0 and valid dealer
    def initialize
        @name = DEALER_NAME_CONST
        @net_value = 0
        @valid = true
    end
    
    # update_net_value should be called after a round is over and the 
    # dealer settles the payments for the round
    def update_net_value (amount)
        if amount.kind_of? Integer
            @net_value += amount
        end
    end
    
    # deal_hand creates a new hand for the dealer only if
    # the dealer does not already have a hand
    def deal_hand
        if (@hand)
            puts 'You already have an active hand'
        else
            @hand = Hand.new
        end
    end

    # Cleans up an existing hand
    # Used for a new game
    def clear_hand
        if (@hand)
            @hand = nil
        end
    end

    # function to hit the hand with a particular card
    def hit(card)
        @hand.hit(card)
    end
    
end
