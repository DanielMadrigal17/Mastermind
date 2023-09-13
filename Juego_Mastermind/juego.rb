require 'colorize'

class Mastermind
  COLORES = {
    'R' => :red,
    'V' => :green,
    'A' => :blue,
    'Y' => :yellow,
    'C' => :light_blue,
    'M' => :magenta
  }

  INTENTOS_MAX = 12
  CODIGO_SECRETO = 4

  def initialize
    @secret_code = generador_codigo_secreto
    @intentos = 0
  end

  def start
    puts '¡Bienvenido a Mastermind!'
    sleep 2
    puts 'Tienes estos colores disponibles: R (Rojo), V (Verde), A (Azul), Y (Amarillo), C (celeste), M (Morado)'
    sleep 2
    puts 'Intenta adivinar la combinación secreta de 4 colores.'
    play_game
  end

  def play_game
    until @intentos >= INTENTOS_MAX
      guess = adivinador
      @intentos += 1

      if guess == @secret_code
        puts "¡Felicidades! Has adivinado la combinación secreta en #{@intentos} intentos."
        return
      else
        resultado = provide_resultado(guess)
        puts "Intento ##{@intentos}: #{colorize_guess(guess)} - resultado: #{colorize_resultado(resultado)}"
      end
    end

    puts "Agotaste tus #{@intentos} intentos. La combinación secreta era: #{colorize_guess(@secret_code)}"
  end

  private

  def generador_codigo_secreto 
    colors_copy = COLORES.keys.dup
    @secret_code = CODIGO_SECRETO.times.map { colors_copy.delete_at(rand(colors_copy.length)) }
  end

  def get_player_code
    puts "Ingresa tu código secreto de #{CODIGO_SECRETO} colores (por ejemplo, RVAY):"
    code = gets.chomp.upcase.scan(/\w/)
    if code.length == CODIGO_SECRETO && code.all? { |color| COLORES.include?(color) }
      code
    else
      puts "Ingresa un código secreto válido de #{CODIGO_SECRETO} colores."
      get_player_code
    end
  end

  def adivinador
    puts "Intento ##{@intentos + 1}: Ingresa tu combinación (por ejemplo, acyr):"
    guess = gets.chomp.upcase.scan(/\w/)
  
    if guess.length != CODIGO_SECRETO
      puts "Debes ingresar una combinación de exactamente #{CODIGO_SECRETO} colores."
      return adivinador
    end
  
    if guess.uniq.length != CODIGO_SECRETO
      puts "Los colores no deben repetirse en la combinación."
      return adivinador
    end
  
    if guess.all? { |color| COLORES.include?(color) }
      guess
    else
      puts "Ingresa una combinación válida de colores: #{COLORES.keys.join(', ')}."
      adivinador
    end
  end

  def provide_resultado(guess)
    resultado = []
    @secret_code.each_with_index do |color, index|
      if color == guess[index]
        resultado << 'O'.colorize(:green)  
      elsif @secret_code.include?(guess[index])
        resultado << 'X'.colorize(:yellow)
      end
    end
    resultado
  end

  def colorize_guess(code)
    code.map { |color| colorize_color_letter(color) }.join(' ')
  end

  def colorize_resultado(resultado)
    resultado.join(' ')
  end

  def colorize_color_letter(letter)
    letter.colorize(COLORES[letter])
  end
end

# def choose_role
#   puts "¿Quieres ser el creador del código (ingresa 'creador') o el adivinador (ingresa 'adivinador')?"
#   role = gets.chomp.downcase
#   unless ["creador", "adivinador"].include?(role)
#     puts "Ingresa una opción válida ('creador' o 'adivinador')."
#     return choose_role
#   end
#   role
# end

# role = choose_role
game = Mastermind.new #(role)
game.start
