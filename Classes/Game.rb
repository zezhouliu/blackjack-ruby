require 'CardDeck'
require 'Dealer'
require 'Helper'
require 'Player'

## 
# Game class
#
# A game represents the BlackJack game itself, with a dealer, player, 
#   and card deck
#
# Most of the rules and logic for the game is handled here, includes:
# - when to deal cards
# - prompting for player decisions
# - payment and results
#
# Instantiation:
#   g = Game.new(String pname, pamount)
#
#   XXX Future implementation:
#       - Support multiple players, with each player either
#           1) controlled by user
#           2) makes decisions similar to dealer
#           3) more complicated ml or algorithm
#       - Improved game GUI
#           1) Display other info we track, like dealer's net value
#           2) Better option selection for player decisions
##

class Game
    
    def initialize (name, amount)
        @dealer = Dealer.new
        @deck = CardDeck.new
        @player = Player.new(name, amount)
    end

    def deal_cards
        for hand in @player.hands
            while hand.size < 2
                puts "Making sure every hand has at least 2 cards..."
                @player.hit(hand, @deck.draw)
            end
        end
    end

    def setup_game
        # First clean up the existing hands
        @dealer.clear_hand
        @player.clear_hands
        # Deal hands to dealer and player
        @dealer.deal_hand
        @player.deal_hand
        # Setup starting bets
        puts "You currently have $" + "#{@player.money}"
        puts "At what value would you like to place your bet?"
        starting_bet = gets.to_i
        if starting_bet == 0
            puts "You must bet at least $1!"
            return false
        end
        placed_bet = @player.start_bet(@player.hands[0], starting_bet)
        if placed_bet
            # Deal 2 cards to dealer and player
            while @dealer.hand.size < 2
                @player.hit(@player.hands[0], @deck.draw)
                @dealer.hit(@deck.draw)
            end
            return true
        end
        return false
    end

    def continue
        puts "\n"
        will_play = bool_prompt("Would you like to play another hand?")
        if will_play
            return player_has_money
        end
        return false
    end

    def player_has_money
        if @player.money > 0:
            return true
        end
        puts "You do not have anymore money to gamble! :("
        return false
    end

    def play
        # Shuffle the deck
        @deck = @deck.shuffle
        begin
            # Setup Game
            proper_setup = setup_game
            if proper_setup
                # Check if there is a blackjack
                # A player with a blackjack automatically wins
                # unless the dealer gets a blackjack as well
                # The payout then is 3:2
                player_bj = @player.hands[0].is_blackjack
                dealer_bj = @dealer.hand.is_blackjack
                puts "========"
                puts "Initial Deal:"
                puts "The dealer's face-up card is: " + "'#{@dealer.hand.cards[0]}'"
                puts "Your hand is: " + "'#{@player.hands[0].cards.join("','")}'"
                puts "========"
                if dealer_bj and player_bj
                    puts "Tie! Both you and the dealer got a blackjack!"
                    # put money back into player
                    @player.update_money(hand.current_bet)
                elsif dealer_bj
                    puts "The dealer won with a blackjack! :("
                elsif player_bj
                    puts "You won with a blackjack! Congrats! The payout is 3:2 ($" + "#{@player.hands[0].current_bet})."
                    @player.update_money(3/2 * @player.hands[0].current_bet)
                else
                    # Handle player strat
                    while has_playable_hands(@player)
                        turn
                    end
                    # Handle dealer strat
                    play_dealer
                    # Payout
                    payout
                end
            end
        end while continue
    end

    def turn
        # Let the player play each hand
        for hand in @player.hands
            # First, we make sure each hand is dealt at least 2 cards
            deal_cards
            
            if hand.can_hit
                play_hand(hand)
            end
        end
    end

    def has_playable_hands(player)
        for hand in player.hands
            if hand.can_hit
                return true
            end
        end
        return false
    end

    def display_status(hand)
        puts "\n"
        puts "The dealer's face-up card is: " + "'#{@dealer.hand.cards[0]}'"
        puts "Your current hand is: " + "'#{hand.cards.join("','")}'"
        puts "You currently have $" + "#{@player.money}."
        puts "You have bet $" + "#{hand.current_bet}" + " on this hand."
    end

    def play_dealer
        puts "Dealer's turn now..."
        puts "Dealer hits on soft 16 but stands on 17"
        puts "The dealer's cards are: " + "'#{@dealer.hand.cards.join("','")}'"
        # Our dealer stands on all 17s (even soft ones)
        while (@dealer.hand.hand_value < 17 and !@dealer.hand.is_softhand) or
            (@dealer.hand.is_softhand and @dealer.hand.hand_value < 7)
            drawn_card = @deck.draw
            @dealer.hit(drawn_card)
            puts "The dealer just drew a " + "#{drawn_card}."
            puts "The dealer's cards are: " + "'#{@dealer.hand.cards.join("','")}'"
        end
    end

    def payout
        index = 1
        for hand in @player.hands
            # if you score > dealer, you win money
            # (if you have not gone over 21)
            #  OR if the dealer has gone over 21 and you have not
            if (hand.hand_value > @dealer.hand.hand_value or @dealer.hand.hand_value > 21) and hand.hand_value <= 21
                @player.update_money(2 * hand.current_bet)
                puts "Hand #" +"#{index}: " + "you won $" + "#{hand.current_bet} with a hand value of #{hand.hand_value} vs dealer's #{@dealer.hand.hand_value}."
            else
                puts "Hand #" +"#{index}: " + "you lost $" + "#{hand.current_bet} with a hand value of #{hand.hand_value} vs dealer's #{@dealer.hand.hand_value}."
            end
        end
    end

    def play_hand (hand)
        can_play = true
        while can_play and hand.can_hit
            display_status(hand)
            # Handle hand-splitting
            # If you choose to split, then "playing this hand" is automatically over
            if @player.can_split_hand(hand)
                will_split = bool_prompt("Would you like to split your hand?")
                if will_split
                    @player.split_hand(hand)
                    return
                end
            end
            # Handle doubling-down
            # When you double down, you can only hit once afterwards
            if @player.can_double_down(hand)
                will_double_down = bool_prompt("Would you like to double down?")
                if will_double_down
                    @player.double_down(hand)
                    puts "You have bet $" + "#{hand.current_bet}" + " on this hand."
                    drawn_card = @deck.draw
                    puts "You drew a " + "#{drawn_card}"
                    @player.hit(hand, drawn_card)
                    puts "Your current hand is: " + "'#{hand.cards.join("','")}'"
                    if hand.hand_value > 21
                        puts "Oh no! You went over 21! :("
                    end
                    can_play = false
                end
            end
            # Handle hitting
            if hand.can_hit
                will_hit = bool_prompt("Would you like to hit?")
                if will_hit
                    drawn_card = @deck.draw
                    puts "You drew a " + "#{drawn_card}"
                    @player.hit(hand, drawn_card)
                    if hand.hand_value > 21
                        puts "Oh no! You went over 21! :("
                        can_play = false
                    end
                end
            end
            if hand.can_hit
                # Handle Standing
                will_stand = bool_prompt("Would you like to stand?")
                if will_stand
                    @player.stand(hand)
                    can_play = false
                end
            end
        end
    end
end
