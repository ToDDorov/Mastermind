class BoardRow
  def initialize
    @code_pegs = []
    @key_pegs = []
  end

  def fill_pegs(code_pegs, key_pegs)
    @code_pegs = code_pegs.clone
    @key_pegs = key_pegs.clone
  end

  def display_row(number_of_row)
    if !@code_pegs.empty? && !@key_pegs.empty?
      code = "#{@code_pegs[0]} | #{@code_pegs[1]} | #{@code_pegs[2]} | #{@code_pegs[3]}"
      keys = "#{@key_pegs[0]} | #{@key_pegs[1]} | #{@key_pegs[2]} | #{@key_pegs[3]}"

      puts "#{number_of_row} #{code}   |||   #{keys}"
    else
      puts number_of_row.to_s
    end
  end
end

class Board
  KEG_GUESS = {
    color: 'WHITE',
    position: 'RED',
    empty: 'NONE'
  }

  NUMBER_OF_ROUNDS = 12
  COLORS = %w[RED WHITE GREEN BLACK BLUE YELLOW]

  def initialize
    @rows = []

    NUMBER_OF_ROUNDS.times do
      @rows.push(BoardRow.new)
    end

    @player_code = []
    @correct_code = false
    @clue_array = []
    @current_round = 0
  end

  def start_game
    generate_code

    display_board_and_info until @correct_code || @current_round == NUMBER_OF_ROUNDS

    if @correct_code
      puts "\nCongratulations! You won the game! The master code was #{@mastermind_code}"
    else
      puts "\nOops! You lost the game! The master code was #{@mastermind_code}"
    end
  end

  private

  def generate_code
    @mastermind_code = []
    4.times do
      @mastermind_code << COLORS.sample(1)[0]
    end
  end

  def display_board_and_info
    display_rows

    get_user_answer

    while @player_code.length == 4
      # puts "Mastermind code: #{@mastermind_code}"
      # puts "Used code: #{@player_code}"

      key_pegs = Array.new(4, KEG_GUESS[:empty])

      player_code_copy = @player_code.clone
      mastermind_code_copy = @mastermind_code.clone

      i = player_code_copy.length - 1

      while i > -1

        j = mastermind_code_copy.length - 1

        while j > -1
          guess = player_code_copy[i]
          code = mastermind_code_copy[j]

          if code == guess && i == j

            player_code_copy.delete_at(i)
            mastermind_code_copy.delete_at(i)

            key_pegs[i] = KEG_GUESS[:position]
          end

          j -= 1
        end

        i -= 1
      end

      player_code_copy.each_with_index do |guess, _guess_index|
        mastermind_code_copy.each_with_index do |code, _code_index|
          if code == guess
            key_pegs[key_pegs.find_index(KEG_GUESS[:empty])] = KEG_GUESS[:color]
            break
          end
        end
      end

      if key_pegs.all? { |key_peg| key_peg == KEG_GUESS[:position] }
        @correct_code = true
        break
      end

      @rows[@current_round].fill_pegs(@player_code, key_pegs)

      @player_code.clear

      @current_round += 1

      display_rows

      get_user_answer
    end
  end

  def display_rows
    puts '_______________________MASTERMIND BOARD_______________________'
    puts '_______________PLAYER CODE____________________KEY PEGS______'
    puts '____________________________________________________________'
    @rows.each_with_index do |row, index|
      row.display_row(index + 1)
    end
  end

  def get_user_answer
    puts "Enter your code using the colors \n'White', 'Black', 'Red', 'Yellow', 'Green' and 'Blue': "

    user_input_code = gets.chomp.upcase.split

    if user_input_code.length != 4
      p 'You code is different length from 4.'
      return false
    end

    user_input_code.each do |code|
      clear_code = code.gsub(/[^0-9A-Za-z]/, '')

      unless COLORS.include?(clear_code)
        p 'You code contains a color which is not from the available.'
        return false
      end

      @player_code.push(clear_code)
    end

    true
  end
end

mastermind = Board.new
mastermind.start_game
