module Redis
  class CLI
    def start
      puts 'Redis app'
      puts '-----* MENU *-----'
      puts '1. String'
      puts '2. List'
      puts '3. Set'
      puts '------* END *------'


      printf 'localhost>'
      menu_type = gets.chomp
      #----------Project just stop when shutdown server---------#

        case menu_type.to_i
        when 1
          execute_string
        when 2
          execute_list
        when 3
          execute_set
        end

    end


    def execute_string
      string = {}
      while true
        printf 'localhost>'
        data = gets.chomp
        data = data.split()
        #------------- cases for input string -----------#
        case data[0].upcase
        when 'SET'
          string[data[1]] = String.new(data[2])
          puts 'OK'
        when 'GET'
          puts string[data[1]].get
        end
        # end cases
      end
      # end while
    end

    def execute_list
      list = {}
      while true
        printf 'localhost>'
        data = gets.chomp
        data = data.split()
        arr_value = []
        data.length.times do |idx|
          arr_value << data[idx] if idx > 1
        end

        case data[0].upcase
        when 'RPUSH'
          list[data[1]] = List.new(arr_value)
          puts list[data[1]].get_length
        when 'LLEN'
          puts list[data[1]].get_length
        when 'LPOP'
          puts list[data[1]].first_value
          list[data[1]].remove_value(0)
          puts 'removed succeed'
        when 'RPOP'
          puts list[data[1]].last_value
          list[data[1]].remove_value(list[data[1]].get_length - 1)
          puts 'removed succeed'
        when 'LRANGE'
          start = data[2].to_i
          stop = data[3].to_i
          puts list[data[1]].get_range(start, stop).join(' ')
        end
      end

    end

    def execute_set
      set = {}
      while true
        printf 'localhost>'
        data = gets.chomp
        data = data.split()
        arr_value = []
        data.length.times do |idx|
          arr_value << data[idx] if idx > 1
        end
        #------------- cases for input string -----------#
        case data[0].upcase
        when 'SADD'
          set[data[1]] = Set.new(arr_value)
          puts set[data[1]].card
        when 'SCARD'
          puts set[data[1]].nil? ? 'ERROR: Key not found'  : set[data[1]].card
        when 'SMEMBERS'
          puts set[data[1]].nil? ? 'ERROR: Key not found'  : set[data[1]].member.join(' ')
        when 'SREM'
          set[data[1]].remove_member(arr_value)
          puts set[data[1]].nil? ? 'ERROR: Key not found'  : 'removed succeed'
        when 'SINTER'
          inter = []
          data.length.times do |idx|
            inter &= set[data[idx]] & set[data[idx + 1]] if idx > 0 && idx < data.length - 1  && !set[data[idx]].nil? && !set[data[idx + 1]].nil?
          end
          puts inter.join(' ')
        end
        # end cases
      end
      # end while
    end

  end

end