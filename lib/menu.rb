require_relative 'game'
require_relative 'scoreboard'

class Menu
  def self.start
    loop do
      system("cls") || system("clear")
      puts "========================"
      puts "     🎵 MUSIC QUIZ     "
      puts "========================"
      puts "1. Start New Game"
      puts "2. Continue Game"
      puts "3. View Scoreboard"
      puts "4. Exit"
      print "\nChoose an option: "

      choice = gets.chomp

      case choice
      when "1"
        Game.setup_new_game
      when "2"
        Game.continue_game
      when "3"
        system("cls") || system("clear")
        Scoreboard.display
        wait
      when "4"
        puts "\nGoodbye!"
        exit
      else
        puts "\nInvalid option."
        wait
      end
    end
  end

  def self.wait
    print "\nPress ENTER to continue..."
    gets
  end
end
