require 'CardRank'
require 'singleton'

##
# CardType module for creating consistent cardtypes
##
module CardType 
    ACE_TYPE = 'Ace'
    FACE_TYPE = 'Face'
    NUMBER_TYPE = 'Number'
end

## 
# CardRanks class
#
# CardRanks is a singleton of an array of the valid CardRanks in Blackjack
# XXX hacky hard-coded ranks for now, need more elegant solution
#
# Instantiation:
#   ranks = CardRanks.instance
#
# NOTE: the type is generally passed in from the module CardType
# NOTE: You MUST call assign_card_ranks in order to fill the card
#   ranks, else they will be empty!
##
class CardRanks < Array

    # CardRanks should be used as a singleton since
    # its not necessary to possess multiple CardRanks arrays
    include Singleton

    FACE_CARDS = ['J', 'Q', 'K']

    # XXX MUST CALL! Call this after instantiation to assign the ranks
    def assign_card_ranks

        if (!@assigned)
            # XXX Ace value variable, but let the Hand class handle Ace value
            self << CardRank.new('A', 1, CardType::ACE_TYPE)

            # Face cards should have value 10 and type FACE_TYPE
            for face_card in FACE_CARDS
                self << CardRank.new(face_card, 10, CardType::FACE_TYPE)
            end

            # Add the regular numbers
            for index in 2..10
                self << CardRank.new(index.to_s, index, CardType::NUMBER_TYPE)
            end

            @assigned = true
        end

    end

end
