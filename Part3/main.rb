# frozen_string_literal: true

require_relative 'passenger_train'
require_relative 'passenger_car'
require_relative 'cargo_train'
require_relative 'cargo_car'
require_relative 'route'
require_relative 'station'

##
# This is a main program object
# He's show program interface and unlock
# Вся работа с методами в разделе private происходит через метод interface
class Main
  def initialize
    @stations = []
    @trains = []
    @routes = []
    seed
    interface
  end

  def interface
    loop do
      system('clear')
      start_commands
      case gets.chomp
      when '1'
        create_station
      when '2'
        create_train
      when '3'
        create_route
      when '4'
        control_stations
      when '5'
        control_trains
      when '6'
        control_routes
      when 'exit'
        break
      else
        puts 'Неизвестная команда'
        continue
      end
    end
  end

  private

  attr_reader :stations, :trains, :routes

  def seed
    @stations << Station.new('Khimki')
    @stations << Station.new('Yaroslavskiy vokzal')
    @trains << PassengerTrain.new('101')
    @routes << Route.new(@stations[0], @stations[1])
  end

  def start_commands
    puts 'Выберите комманду:'
    puts '1. Добавить станцию;'
    puts '2. Добавить поезд;'
    puts '3. Добавить маршрут;'
    puts '4. Управление станциями;'
    puts '5. Управление поездами;'
    puts '6. Управление маршрутами;'
    puts 'exit. Выход;'
  end

  def continue
    puts
    puts 'Нажмите Enter'
    gets.chomp
  end

  def create_station
    system('clear')
    puts 'Введите название станции:'
    name = gets.chomp
    @stations << Station.new(name)
    puts "Создана станция: #{name}"
    continue
  end

  def create_train
    system('clear')
    puts 'Введите номер поезда:'
    number = gets.chomp
    puts 'Выберите тип поезда:'
    puts '1. Грузовой;'
    puts '2. Пассажирский;'
    case gets.chomp
    when '1'
      @trains << CargoTrain.new(number)
    when '2'
      @trains << PassengerTrain.new(number)
    end
    puts "Создан поезд: №#{number} #{@trains[@trains.length - 1].class}"
    continue
  rescue Exception => e
    puts "Error: #{e.message}"
    continue
  end

  def create_route
    system('clear')
    return puts 'Недостаточно станций для создания маршрута.' if @stations.length < 2

    puts 'Выберите начальную станцию:'
    @stations.each_with_index { |station, index| puts "#{index}. #{station.name}" }
    start = gets.chomp.to_i
    puts 'Выберите конечную станцию:'
    @stations.each_with_index { |station, index| puts "#{index}. #{station.name}" }
    stop = gets.chomp.to_i
    return puts 'Станция не может быть одновременно начальной и конечной' if start == stop

    @routes << Route.new(@stations[start], @stations[stop])
    puts "Создан маршрут: #{@stations[start].name} - #{@stations[stop].name}"
    continue
  end

  def choose_train
    system('clear')
    show_trains
    puts
    puts 'Выберите поезд'
    gets.chomp.to_i
  end

  def choose_route
    system('clear')
    show_routes
    puts
    puts 'Выберите маршрут для добавления'
    gets.chomp.to_i
  end

  def choose_station
    system('clear')
    show_stations
    puts
    puts 'Выберите станцию'
    gets.chomp.to_i
  end

  def control_stations
    loop do
      station = @stations[choose_station]
      system('clear')
      puts '1. Показать все поезда на станции'
      puts 'exit. Назад в меню'
      case gets.chomp
      when '1'
        show_trains(station.trains)
        continue
      when 'exit'
        break
      else
        puts 'Неизвестная команда'
        continue
      end
    end
  end

  def control_routes
    loop do
      route = @routes[choose_route]
      system('clear')
      puts '1. Добавить станцию'
      puts '2. Удалить станцию'
      puts '3. Показать весь маршрут'
      puts 'exit. Назад в меню'
      case gets.chomp
      when '1'
        route.add_station(@stations[choose_station])
      when '2'
        puts @stations[choose_station]
        route.remove_station(@stations[choose_station])
      when '3'
        puts route.stations.map(&:name)
        continue
      when 'exit'
        break
      else
        puts 'Неизвестная команда'
        continue
      end
    end
  end

  def control_trains
    loop do
      train = @trains[choose_train]
      # system('clear')
      puts '1. Установить маршрут поезда'
      puts '2. Добавить вагон к поезду'
      puts '3. Отцепить вагон от поезда'
      puts '4. Перемемстить на станцию вперёд'
      puts '5. Перемемстить на станцию назад'
      puts '6. Текущая станция'
      puts '7. Управление вагонами'
      puts 'exit. Назад в меню'
      case gets.chomp
      when '1'
        train.route = @routes[choose_route]
      when '2'
        car = define_car(train)
        train.add_car(car)
      when '3'
        train.remove_car
      when '4'
        train.move_next
      when '5'
        train.move_prev
      when '6'
        puts train.current_station.name
        continue
      when '7'
        control_cars(train)
        continue
      when 'exit'
        break
      else
        puts 'Неизвестная команда'
        continue
      end
    end
  end

  def control_cars(train)
    loop do
      puts 'Выберите вагон'
      show_cars(train)
      car = train.cars[gets.chomp.to_i]
      if train.type == 'passenger'
        puts '1. Добавить пассажира'
        puts '2. Свободные места'
        puts '3. Занятые места'
      else train.type == 'cargo'
        puts '1. Загрузить вагон'
        puts '2. Свободное место'
        puts '3. Заполненность'
      end
      puts 'exit. Выйти из управления вагоном'
      case gets.chomp
      when '1'
        if train.type == 'passenger'
          car.new_passenger
        else train.type == 'cargo'
          puts 'Укажите объем заполнения'
          car.fill_tank(gets.chomp.to_i)
        end
      when '2'
        puts car.free_lvl
        continue
      when '3'
        puts car.filling_lvl
        continue
      when 'exit'
        break
      else
        puts 'Неизвестная команда'
        continue
      end
    end
  end

  def define_car(train)
    if train.type == 'passenger'
      puts 'Введите количество мест в вагоне'
      capacity = gets.chomp.to_i
      return PassengerCar.new(capacity)
    else train.type == 'cargo'
      puts 'Введите вместимость грузового вагона'
      capacity = gets.chomp.to_i
      return CargoCar.new(capacity)
    end
  end

  def show_cars(train)
    puts "Вагоны для поезда: #{train.number}. #{train.class}"
    train.cars.each_with_index do |car, index|
      puts "#{index}. Тип вагона: #{car.type}."
      puts "Вместимость: #{car.capacity}"
      puts "Свободные места: #{car.free_lvl}"
      puts "Занятые места: #{car.filling_lvl}"
      puts '__________________________________________'
    end
  end

  def show_trains(trains = @trains)
    trains.each_with_index { |train, index| puts "#{index}. #{train.number} #{train.class}" }
  end

  def show_stations
    @stations.each_with_index { |station, index| puts "#{index}. #{station.name}" }
  end

  def show_routes
    @routes.each_with_index { |route, index| puts "#{index}. #{route.start.name} - #{route.stop.name}" }
  end
end

Main.new
