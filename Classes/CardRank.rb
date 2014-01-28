
## 
# CardRank class
#
# CardRank is an abstraction of the different ranks on a playing card
#
# A CardRank has multiple read-only attributes (assigned at instantiation)
# - name    (the string representation of A,J,Q,K, 2-10)
# - value   (their corresponding value in Blackjack)
# - type    (the card type: face, ace, or number)
#
# The read-only properties that can be checked
#   - valid (if the rank has valid assignments)
#
# Instantiation:
#   rank = CardRank.new(String name, Int value, String type)
#
# NOTE: the type is generally passed in from the module CardType
##

class CardRank

    attr_reader :name
    attr_reader :value
    attr_reader :type
    attr_reader :valid

    def initialize (name, value, type)

        if (!name.kind_of? String) or (!value.kind_of? Integer) or (!type.kind_of? String)
            @name = nil
            @value = nil
            @type = nil
            @valid = false
            return
        else
            @name = name
            @value = value
            @type = type
            @valid = true
        end
    end

end

