# class to control turns in the game of tic-tac-toe

require_relative 'ttt_board'


class Game
    PLAYER_X = 'X'
    PLAYER_O = 'O'

    def initialize(first_player)
        # intiializes the game and sets the first player (X or O)
        first_player.upcase!
        if valid_player?(first_player)
            @cur_player = first_player
        else
            abort("#{first_player} is not a valid player designation (use 'X' or 'O')")
        end
        @board = Board.new # initialize a new, empty board
        @moves_made = 0 # keep count of moves, just for show
    end


    def valid_player?(a_player)
        # returns true if the player designation is valid (must be 'X', 'x', 'O' or 'o')
        a_player.upcase!
        return (a_player == PLAYER_X) || (a_player == PLAYER_O)
    end


    def show_help
        # show syntax help
        puts "Enter board positions as A1 to C3, where letters are columns and numbers are rows:"
        puts "A1 is the top left, B2 is center, C3 is bottom right."
        puts "Remaining moves are: #{@board.get_empty_slots.join(', ')}"
        puts "(To quit the game, enter q or press Ctrl+C)"
        puts ""
    end


    def valid_input?(user_move)
        # test if input string represents a valid board position, such as 'A1'
        # (does not check if the position on board is empty!)
        result = ""
        if user_move.length < 2
            result = "Input too short (must have 2 characters, e.g. 'A1')"
        elsif user_move.length > 2
            result = "Input is too long (must have 2 characters, e.g. 'A1')"
        # is the first character one of a, b or c?
        elsif not 'ABC'.include? user_move[0]
            result = "Invalid column (must be A, B or C)"
        # is the second character a digit between 1 and 3?
        elsif not '123'.include? user_move[1]
            result = "Invalid row (must be 1, 2 or 3)"
        end

        # if we have an error message, print it
        if result != ""
            puts "Sorry! " + result
        end
        # move is valid is no error message
        return result == ""
    end


    def next_turn
        # swap current player
        if @cur_player == PLAYER_X
            @cur_player = PLAYER_O
        elsif @cur_player == PLAYER_O
            @cur_player = PLAYER_X
        else
            abort("Internal error: invalid current player designation #{@cur_player}")
        end
    end


    def get_user_move
        # prompt user for valid board location
        # return user move as row:col, A1, B2 etc
        user_move = ""
        loop do
            @board.draw(show_labels=true)
            puts "\nEnter move (? for help, q to quit)"
            print "#{@cur_player} plays:  "
            user_move = gets.chomp.upcase
            if user_move == '?'
                show_help
            elsif user_move == 'Q'
                abort("Quitting the game.")
            elsif valid_input?(user_move)
                break
            end
        end
        return user_move
    end


    def show_game_over(winner)
        # display game result
        @board.draw(show_labels=false)
        puts "\nGame Over"
        if winner == nil
            puts "IT'S A DRAW."
        else
            puts "#{winner} WINS in #{@moves_made} moves!"
        end
    end


    def play
        # controls the game until a player wins, there is a draw or the players quit
        loop do
            user_move = get_user_move
            if @board.make_move(user_move, @cur_player)
                @moves_made += 1

                # was this a winning move? Or is it a draw?
                if @board.have_winner?
                    show_game_over(@cur_player)
                    break
                elsif not @board.has_valid_moves?
                    show_game_over(nil)
                    break
                end

                # TODO:
                # If there is only 1 valid move left, we should play it automatically
                # instead of requiring the next player to do so.

                # still in the game, so let next player make a move
                next_turn
            end
        end
    end
end

