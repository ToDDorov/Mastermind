class BoardRow
  attr_writer :secret_code
  attr_reader :code_pegs, :key_pegs

  def initialize(secret_code)
    self.secret_code = secret_code
    code_pegs = Array.new(4)
    key_pegs = Array.new(4)
  end

  def fill_code_pegs(code_pegs)
    self.code_pegs = code_pegs

    get_key_pegs
  end

  private

  def get_key_pegs; end
end

class Board
  NUMBER_OF_ROUNDS = 12
  COLORS = %w[RED WHITE GREED BLACK BLUE YELLOW]

  def initialize
    @rows = Array.new(12)
  end

  public
 
  def start_game
    generate_code
    display_board_and_info
  end

  private

  def generate_code
    @code = []
    4.times do
      @code << COLORS.sample(1)[0]
    end
  end

  def display_board_and_info
    puts "Enter your code using the colors \n'White', 'Black', 'Red', 'Yellow', 'Green' and 'Blue': "
    puts "_________________________________________________"
    NUMBER_OF_ROUNDS.times do |i|

      if i == NUMBER_OF_ROUNDS - 1
      puts "|______|______|______|______|______|______________"
      else
      puts "|      |      |      |      |      |      "
      end
    end
  end

end

mastermind = Board.new
mastermind.start_game
