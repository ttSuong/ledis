module Redis
  class CLI
    def start
      #----------Project just stop when shutdown server---------#
      result = {}
      while true
        printf 'cli>'
        input_value = gets.chomp
        input_value = input_value.split()
        arr_value = []

        input_value.length.times do |idx|
          arr_value << input_value[idx] if idx > 1
        end

        if result.key?(input_value[1]) && result[input_value[1]].is_expired
          result.delete(input_value[1])
          puts result
        end

        case input_value[0].upcase
        # snapshot
        when 'SAVE'

        when 'RESTORE'

        # summary input
        when 'KEYS'
          puts result.keys.join(' ')

        when 'DEL'
          if result.key?(input_value[1])
            result.delete(input_value[1])
            puts "SUCCESS: deleted #{input_value[1]}"
          else
            puts 'ERROR: Key not found'
          end

        when 'FLUSHDB'
          result = {}
          puts 'SUCCESS: cleared all keys'

        when 'EXPIRE'
          expired_time = Time.now + input_value[2].to_i
          if result.key?(input_value[1])
            result[input_value[1]].set_timeout(expired_time)
            puts 'OK'
          else
            puts 'ERROR: Key not found'
          end


        when 'TTL'
          if result.key?(input_value[1])
            puts result[input_value[1]].get_timeout
          else
            puts 'ERROR: Key not found'
          end

        # string input
        when 'SET'
          if result.key?(input_value[1])
            puts 'ERROR: Invalid key'
            next
          end
          result[input_value[1]] = MyString.new(input_value[2])
          puts 'OK'

        when 'GET'
          puts result[input_value[1]].nil? ? 'ERROR: Key not found'  : result[input_value[1]].get

        #   list input
        when 'RPUSH'
          if result.key?(input_value[1])
            puts 'ERROR: Invalid key'
            next
          end
          result[input_value[1]] = MyList.new(arr_value)
          puts result[input_value[1]].get_length

        when 'LLEN'
          puts result[input_value[1]].nil? ? 'ERROR: Key not found'  : result[input_value[1]].get_length

        when 'LPOP'
          if  result[input_value[1]].nil?
            puts 'ERROR: Key not found'
            next
          end

          puts result[input_value[1]].first_value
          result[input_value[1]].remove_value(0)
          puts 'SUCCESS'

        when 'RPOP'
          if  result[input_value[1]].nil?
            puts 'ERROR: Key not found'
            next
          end

          puts result[input_value[1]].last_value
          result[input_value[1]].remove_value(result[input_value[1]].get_length - 1)
          puts 'SUCCESS'

        when 'LRANGE'
          start = input_value[2].to_i
          stop = input_value[3].to_i
          puts result[input_value[1]].get_range(start, stop).join(' ')

        # set input
        when 'SADD'
          if result.key?(input_value[1])
            puts 'ERROR: Invalid key'
            next
          end

          result[input_value[1]] = MySet.new(arr_value)
          puts result[input_value[1]].card

        when 'SCARD'
          puts result[input_value[1]].nil? ? 'ERROR: Key not found'  : result[input_value[1]].card

        when 'SMEMBERS'
          puts result[input_value[1]].nil? ? 'ERROR: Key not found'  : result[input_value[1]].member.to_a.join(' ')

        when 'SREM'
          if result.key?(input_value[1])
            puts 'ERROR: Invalid key'
            next
          end
          result[input_value[1]].remove_member(arr_value)
          puts 'SUCCESS'

        when 'SINTER'
          result_inter  = result[input_value[1]]
          input_value.length.times do |idx|

            if  result.key?(input_value[idx])
              puts "ERROR: Invalid key #{input_value[idx]}"
              result_inter = []
              break
            end

            result_inter = result_inter.inter(result[input_value[idx]]) if idx > 1
          end
          puts result_inter.member.to_a.sort.join(' ')
        end
        # end cases
      end
    end
  end
end