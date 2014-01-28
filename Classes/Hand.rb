require 'set'
require 'CardDeck'

## 
# Hand class
#
# A Hand represents a particular hand in the BlackJack game. Requirements 
# to represent the hand class meant that it should naturally track
# the array of BlackJackCards, as well as establish some of the rules
# of BlackJack, such a hand can be split, when it's a blackjack, etc.
#
# A Hand has multiple read-only attributes
# - card_collection     (the array of cards in the hand, update using the
#                       hit(card) method to add card to array)
# - can_hit             (tracks whether legal to still hit)
# - can_split           (tracks whether legal to split)
# - is_softhand         (whether the hand is "soft" containing an Ace and 
#                       having a total value of less than 12)
# - is_blackjack        (whether hand is blackjack hand)
# - hand_value          (tracks the current value of the hand)
#
# Hand also contains assignable attributes
# - is_split            (tracks if hand has been split, which prevents blackjacks)
# - current_bet         (tracks the current bet value of hand)
# - is_doubled_down     (tracks whether the hand has already been doubled down)
#
# Instantiation:
#   h = Hand.new
##

class Hand

    # define max size of a Hand
    SIZE_LIMIT = 5

    # initialization method with empty hand and several defaulted attributes
    def initialize
   
        # private
        @has_ace = false
        @has_ten = false
        @is_standing = false

        # read-only
        @card_collection = Array.new
        @can_hit = true
        @can_split = false
        @is_softhand = false
        @is_blackjack = false
        @hand_value = 0
        
        # accessible
        @current_bet = 0
        @is_split = false
        @is_doubled_down = false

    end

    # assign read-only
    attr_reader :can_hit
    attr_reader :can_split
    attr_reader :is_softhand
    attr_reader :is_blackjack
    attr_reader :hand_value
    attr_reader :card_collection

    # assignable attributes
    attr_accessor :is_split
    attr_accessor :current_bet
    attr_accessor :is_doubled_down

    def cards
        return @card_collection
    end

    def size
        return @card_collection.length
    end

    # Hit-method
    # first checks if the hand is allowed to hit, then 
    # checks if it is an Ace or Face card, and updates accordingly
    def hit(new_card)
        if (can_hit)
            @card_collection << new_card
            # if it is an ace
            if (new_card.is_ace?)
                @has_ace = true
            end
            # if it is a ten or face
            if (new_card.is_face?)
                @has_ten = true
            end
            self.update
        end
    end

    # Stand-method
    # Basically it doesn't do anything special right now (may change later)
    # but it calls the update method and sets a flag to stand
    def stand
        @is_standing = true
        self.update
    end

    # Update method for the hand, which calculates the hand_value
    # and checks multiple status attributes
    def update
        # Must firstly update the lastest hand value
        self.calculate_hand_value

        # Check statuses
        self.check_can_hit?
        self.check_can_split?
        self.check_is_softhand?
        self.check_is_blackjack?
    end

    # calculates the possible hand_values based on collection
    # checks for using both Ace = 1 and Ace = 11
    def calculate_hand_value

        # only calculate hand value when we have cards
        if @card_collection.size > 0
            
            # instantiate a small and big array, and a stack for storage
            small_arr = Array.new
            big_arr = Array.new
            stack = Array.new
            i = 0

            # push all the cards into the stack based on their rank
            first_card = @card_collection[i]
            if (first_card.is_ace?)
                stack.push({:val => 1, :index => i+1})
                stack.push({:val => 11, :index => i+1})
            else
                stack.push({:val => first_card.rank.value, :index => i+1})
            end
            # enumerate all possible combinations and put them into two arrays
            # small_arr collects all values less or equal to 21
            # big_arr collects values larger than 21
            while stack.size != 0
                status = stack.pop
                if (status[:index] == @card_collection.size)
                    if (status[:val] <= 21)
                        small_arr << status[:val]
                    else
                        big_arr << status[:val]
                    end
                else
                    i = status[:index]
                    if @card_collection[i].is_ace?
                        stack.push({:val => status[:val]+1, :index => i+1})
                        stack.push({:val => status[:val]+11, :index => i+1})
                    else
                        card_val = @card_collection[i].rank.value
                        stack.push({:val => status[:val]+card_val, :index => i+1})
                    end
                end
            end

            if (small_arr.size > 0)
                # sort in descending order
                small_arr.sort { |x,y| y <=> x}
                @hand_value = small_arr[0] 
            else
                # sort in ascending order
                big_arr.sort
                @hand_value = big_arr[0]
            end
        end
    end
   
    # checks whether the card_collection size is below the limit and the
    # hand_value is below bust in order to perform a legal hit
    def check_can_hit?
        
        if (@card_collection.size < SIZE_LIMIT and @hand_value < 21 and !@is_standing and !@is_doubled_down)
            @can_hit  = true 
        else
            @can_hit  = false
        end
    end

    # checks whether we have a valid hand for a split
    def check_can_split?
       
        # Check if the two cards in the hand are the same
        if (!@can_split and @card_collection and @card_collection.size == 2)
            
            card1 = @card_collection[0]
            card2 = @card_collection[1]

            if card1.rank.name == card2.rank.name
                @can_split = true
            end
        end
    end

    def check_is_softhand?
        @is_softhand = (@has_ace and @hand_value < 12)
    end

    def check_is_blackjack?
        @is_blackjack = ((@has_ten and @has_ace) and !is_split)
    end

end

