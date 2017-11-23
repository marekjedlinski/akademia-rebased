# class to represent the tic-tac-toe board


class Board
    def initialize
        # intiailize an empty board, indexed as [column][row]
        # (note that col:row indexing makes the board harder to display than row:col,
        # becuase we have to print every third value from each  nested arrays)
        @the_board = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        #              A1   A2   A3     B1   B2   B3     C1   C2   C3
    end


    def count_valid_moves
        # count empty slots (remaining moves in the game)
        counter = 0
        @the_board.each do |the_col|
            the_col.each do |the_row|
                if the_row == nil
                    counter += 1
                end
            end
        end
        return counter
    end


    def has_valid_moves?
        # returns true if players can still make valid moves (board is not completely filled)
        return count_valid_moves > 0
    end


    def get_position(col, row)
        # for row and col index, return a readable board position such as 'A1'
        return index_to_col(col) + index_to_row(row)
    end


    def index_to_col(a_index)
        # 0 => 'A'
        # map column index to column as entered by player
        return (a_index + 'A'.ord).chr
    end


    def index_to_row(a_index)
        # 0 => '1'
        # map row index to row as entered by player
        return (a_index+1).to_s
    end


    def col_to_index(a_col)
        # 'A' => 0;  'B' => 1;  'C' => 2
        # input must be validated by caller; assuming it is 'A', 'B' or 'C'
        return a_col.upcase.ord - 'A'.ord
    end

    def row_to_index(a_row)
        # '1' => 0; '2' => 1 etc.
        # (user specifies row numbers as one-based, we need a zero-based index)
        # again, assuming input already validated.
        return a_row.to_i-1
    end


    def get_empty_slots
        # return an array listing indices of empty slots
        empty_slots = []
        @the_board.each_with_index do |the_col, col_idx|
            the_col.each_with_index do |the_value, row_idx|
                if the_value == nil
                    empty_slots.push(index_to_col(col_idx) + index_to_row(row_idx))
                end
            end
        end
        return empty_slots
    end


    def slot_empty?(col, row)
        # returns true if the slot at [row,col] is empty
        return @the_board[col][row] == nil
    end


    def make_move(position, player)
        # make a move, checking for bad arguments
        # position must be in the form of 'A1', validated by caller
        # player must be already validated as X or O
        col = col_to_index(position[0])
        row = row_to_index(position[1])
        if col < 0 or col > 2
            puts("ERROR: invalid col index #{col} (#{a_col})")
            return false
        end
        if row < 0 or row > 2
            puts("ERROR: invalid row index #{row} (#{a_row})")
            return false
        end
        player.upcase!
        if (player.length != 1) || (not 'XO'.include?(player))
            puts("ERROR: invalid player '#{player}'")
            return false
        end
        if not slot_empty?(col, row)
            puts("ERROR: board slot at #{get_position(col, row)} already used")
            return false
        end
        @the_board[col][row] = player
        return true
    end


    def draw(show_labels)
        row_label = '1'
        # draw the current board state
        if show_labels
            puts "    A   B   C"
        end
        puts "  -------------"
        the_row = 0
        while the_row < 3
            if show_labels
                print "#{row_label} |"
                row_label.next!
            else
                print "  |"
            end

            the_col = 0
            while the_col < 3
                the_mark = @the_board[the_col][the_row]
                if the_mark == nil
                    the_mark = " "
                end
                print " #{the_mark} |"
                the_col += 1
            end
            puts "\n  -------------"
            the_row += 1
        end
    end


    def mark_at(col, row)
        # return the value stored at a board position:
        # 'X', 'O' or nil if the slot is empty
        return @the_board[col][row]
    end


    def have_winner?
        # check the board and return true if a player has won

        # check each col
        mark = mark_at(0,0)
        if mark != nil && mark_at(0,1) == mark && mark_at(0,2) == mark
            return true
        end
        mark = mark_at(1,0)
        if mark != nil && mark_at(1,1) == mark && mark_at(1,2) == mark
            return true
        end
        mark = mark_at(2,0)
        if mark != nil && mark_at(2,1) == mark && mark_at(2,2) == mark
            return true
        end

        #check each row
        mark = mark_at(0,0)
        if mark != nil && mark_at(1,0) == mark && mark_at(2,0) == mark
            return true
        end
        mark = mark_at(0,1)
        if mark != nil && mark_at(1,1) == mark && mark_at(2,1) == mark
            return true
        end
        mark = mark_at(0,2)
        if mark != nil && mark_at(1,2) == mark && mark_at(2,2) == mark
            return true
        end

        # check diagonals
        mark = mark_at(0,0)
        if mark != nil && mark_at(1,1) == mark && mark_at(2,2) == mark
            return true
        end
        mark = mark_at(2,0)
        if mark != nil && mark_at(1,1) == mark && mark_at(0,2) == mark
            return true
        end

        return false
    end

end

