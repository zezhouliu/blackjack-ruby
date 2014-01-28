require "BlackJackCard"

## 
# CardDeck class
#
# CardDeck represents a single deck of cards using an array of cards
# - You can use multiple decks of cards for Blackjack as necessary,
#   but for this implementation, we stick with just one.
# 
# Instantiation:
#   cd = CardDeck.new
#
##

class CardDeck < Array

    def initialize
        
        # get ranks and suits to generate deck
        ranks = CardRanks.instance
        ranks.assign_card_ranks
        suits = CardSuits.instance
        suits.assign_card_suits

        for suit in suits
            for rank in ranks
                self.push(BlackJackCard.new(rank, suit))
            end
        end

    end

    # check whether the deck is valid
    def is_valid
        for card in self
            if !card.is_valid
                return false
            end
        end
    end

    # print deck
    def print_deck
        #for card in self
        for index in 0..self.size - 1
            card = self[index]
            puts card.name
        end
    end

    # Draws the top card from the deck
    # This is represented by the first element of the array
    def draw
        # if there are no more cards in the deck,
        # we readd all of the cards and shuffle
        if self.size == 0
            for suit in suits
                for rank in ranks
                    self.push(BlackJackCard.new(rank, suit))
                end
            end
            self.shuffle
        end
        return self.shift
    end
        
end

