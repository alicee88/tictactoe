class Game
    @board = Array.new(9)
    @first_player = nil
    @second_player = nil

    def self.setup_board()
        @board = @board.map.with_index {|square, index| square = index + 1}
    end

    def self.print_board()
        i = 0
        line = ""
        @board.each do |square|
            line += square.to_s
            if(i == 2)
                puts line
                line = ""
                i = 0
            else
                i += 1
            end
        end
    end

    def self.is_matching_trio(first, second, third)
        return (first.to_s == second.to_s && second.to_s == third.to_s)
    end

    def self.check_for_win()
        #Check horizontals
        if(is_matching_trio(@board[0], @board[1], @board[2]))
            return @board[0] unless !@board[0]
        elsif(is_matching_trio(@board[3], @board[4], @board[5]))
            return @board[3] unless !@board[3]
        elsif(is_matching_trio(@board[6], @board[7], @board[8]))
            return @board[6] unless !@board[6]
        
        #Check verticals
        elsif(is_matching_trio(@board[0], @board[3], @board[6]))
            return @board[0] unless !@board[0]
        elsif(is_matching_trio(@board[1], @board[4], @board[7]))
            return @board[1] unless !@board[1]
        elsif(is_matching_trio(@board[2], @board[5], @board[8]))
             return @board[2] unless !@board[2]

        #Check diagonals
        elsif(is_matching_trio(@board[0], @board[4], @board[8]))
            return @board[0] unless !@board[0]
        elsif(is_matching_trio(@board[2], @board[4], @board[6]))
            return @board[2] unless !@board[2]
        else
            return false
        end
    end

    def self.get_board()
        return @board
    end

    def self.decide_first_player()
        puts "We'll toss a coin to see who goes first. Heads or tails? (Type 'H' or 'T')"
        done_cointoss = false
        prng = Random.new
        toss = prng.rand(2) # 0 = heads, 1 = tails
        while(!done_cointoss) do
            toss_guess = gets.chomp
            if(toss_guess == "H" || toss_guess == "h")
                if(toss == 0)
                    puts "You guessed heads and won the toss. You go first."
                    @first_player = Human.new("O")
                    @second_player = Computer.new("X")
                else
                    puts "You guessed heads and lost the toss. I go first."
                    @first_player = Computer.new("X")
                    @second_player = Human.new("O")
                end
                done_cointoss = true
            elsif(toss_guess == "T" || toss_guess == "t")
                if(toss == 0)
                    puts "You guessed tails and lost the toss. I go first."
                    @first_player = Computer.new("X")
                    @second_player = Human.new("O")
                else
                    puts "You guessed tails and won the toss. You go first."
                    @first_player = Human.new("0")
                    @second_player = Computer.new("X")
                end
                done_cointoss = true
            end
        end
    end

    def self.run()
        
        setup_board()
        decide_first_player()
        if(!@first_player.is_computer)
            print_board()
        end
        winner = false
        while(!winner && !quit_game) do
            @first_player.choose_move(get_board)
            if(check_for_win())
                puts check_for_win + " wins!"
                winner = true
                break;
            end
            @second_player.choose_move(get_board)
            if(check_for_win())
                puts check_for_win + " wins!"
                winner = true
                break;
            end
            
        end
    end
end

class Player
    attr_accessor :symbol
    def initialize(symbol)
        @symbol = symbol
    end
end

class Computer < Player
    def choose_move(board)
        puts "Choosing my move..."
        avail_moves = board.select{|square| square != "X" && square != "O"}
        move =  avail_moves.sample
        if(move)
            board[move - 1] = symbol
            Game.print_board
        end
    end

    def is_computer()
        return true
    end
end

class Human < Player
    def choose_move(board)
        finished = false
        while(!finished) do
            puts "Choose your move (type the number of the square you want)"
            move = gets.chomp
            if(move.to_s == "q")
                finished = true
                Game.quit
                break
            end
            if(board.include?(move.to_i))
                board[move.to_i - 1] = symbol
                Game.print_board
                finished = true
            else
                finished = false
                puts "Enter a valid move or q to quit"
            end
        end
    end

    def is_computer()
        return false
    end
end

Game.run
