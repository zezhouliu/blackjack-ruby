require 'Hand'

## 
# Player class
#
# A Player represents a participant in the BlackJack game.
#
# A player has multiple read-only attributes
# - name (player name)
# - money (amount of money available)
# - hands (array of Hands that the Player controls)
# - valid (whether the player is valid)
#
# Instantiation:
#   p = Player.new(String name, Int amount)
##

class Player

    # assign read-only and accessible attributes
    attr_reader :name
    attr_reader :valid
    attr_reader :money
    attr_reader :hands

    # Error constants
    ERR_NOT_ENOUGH_MONEY = 'You do not have enough money to make that bet.'
    ERR_NO_ACTIVE_BET = 'You currently do not have an active bet on that hand'
    ERR_ACTIVE_BET = 'You currently already have an active bet on that hand'
    ERR_INVALID_BET = 'Invalid bet. Please enter an Integer bet amount'
    ERR_ALREADY_DOUBLED = 'This hand has already been doubled-down'

    # initialization method to create a Player with a particular name
    # and amount of money
    def initialize (name, amount)
       
        # safety checks
        if (!name.kind_of? String) || (!amount.kind_of? Integer)
            @valid = false
            return
        end

        @name = name
        @money = amount
        @hands = Array.new
        @valid = true
    end

    # update_money can be used if the player wants to add more money
    # after blowing it all, or can be used to update winnings
    def update_money (amount)
        if amount.kind_of? Integer
            @money += amount
            return true
        end

        return false
    end

    # start_bet creates the starting bet for a particular hand.
    # The bet must be an integer amount and the 
    # player must be able to afford the bet
    def start_bet(hand, amount)
        if hand.current_bet != 0
            puts ERR_ACTIVE_BET
        elsif (!amount.kind_of? Integer)
            puts ERR_INVALID_BET
        elsif (amount > @money)
            puts ERR_NOT_ENOUGH_MONEY
        else 
            # simultaneous assignment of bet and money
            @money, hand.current_bet = @money - amount, amount
            # puts 'You start a bet of ' + "#{amount}."
            
            return true
        end

        return false
    end

    # checks if a particular hand can be doubled down
    def can_double_down(hand)
        if (hand.is_doubled_down or hand.current_bet > @money) or hand.size != 2
            return false
        end
        
        return true
    end

    # Enables feature of doubling down, it doubles the bet on the hand but 
    # also marks that the hand is doubled-down and must stand after the next card
    # returns true if double_down occurs
    def double_down (hand)
        if hand.current_bet == 0
            puts ERR_NO_ACTIVE_BET
        elsif hand.current_bet > @money
            puts ERR_NOT_ENOUGH_MONEY
        elsif hand.is_doubled_down 
            puts ERR_ALEADY_DOUBLED
        else
            # simultaneous assignment of bet, money, and doubling down
            @money, hand.current_bet, hand.is_doubled_down = @money - hand.current_bet, 2 * hand.current_bet, true
            return true
            # puts "You double your bet.  Current bet: #{@hand.current_bet}"
        end

        return false
    end

    # checks whether the player can split any of his hands by checking each hand
    # to see if they can be split. There is no limit to the number of hands a player
    # may hold (updateable)
    def can_split_hand (hand)

        # can only split if the hand has a pair AND is affordable
        if hand.can_split and (@money > hand.current_bet)
            return true
        end

        return false

    end

    # split_hand gets the hand that can be split and then splits it
    # by creating a new hand and splitting the cards amongst the two hands
    # and adding a bet to the new hand
    def split_hand (hand)
        
        if (hand.can_split)
            card = hand.card_collection.pop
            hand.is_split = true
            hand.can_split = false
            hand.update

            new_hand = Hand.new
            hand.can_split = false
            new_hand.is_split = true
            self.start_bet(new_hand, hand.current_bet)
            new_hand.hit(card)
            @hands << new_hand

        end
    end

    def stand (hand)
        hand.stand
    end

    # deal_hand creates a new hand for the player only if
    # the player does not already have a hand
    def deal_hand
        if (@hands.size > 0)
            puts 'You already have an active hand'
        else
            @hands << Hand.new
        end
    end

    # Cleans up existing hands
    # Used for a new game
    def clear_hands
        @hands.clear
    end

    # returns the number of hands for the player
    def number_of_hands
        return @hands.size
    end

    # function to hit the hand with a particular card, makes check
    # for valid card
    def hit(hand, card)
        if (card.valid)
            hand.hit(card)
        end
    end

end
