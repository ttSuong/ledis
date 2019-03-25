require 'json'
module Ledis
  class CLI

    def initialize
      @result = {}
      @data_backup = []
    end

    def start(input_value)
      #----------Project just stop when shutdown server---------#
      is_success = true
      message = 'SUCCESS'
      data = []
      input_value = input_value.split()
      arr_value = []

      input_value.length.times do |idx|
        arr_value << input_value[idx] if idx > 1
      end

      if @result.key?(input_value[1]) && @result[input_value[1]].is_expired
        @result.delete(input_value[1])
      end

      case input_value[0].upcase
        # snapshot
      when 'SAVE'
        @data_backup << @result
        @data_backup
        @result.each do |key, value|
          data << {'key': key, 'value': value}
        end

      when 'RESTORE'
        @result = @data_backup.last
        data = @result
        # summary input
      when 'KEYS'
        @result.each do |key, value|
          if @result[key].is_expired
            @result.delete(key)
          end
        end
        data = {'key': @result.keys}

      when 'DEL'
        if @result.key?(input_value[1])
          @result.delete(input_value[1])
          @result.each do |key, value|
            data << {'key': key, 'value': value}
          end
        else
          is_success = false
          message = 'ERROR: Key not found'
        end

      when 'FLUSHDB'
        @result = {}
      when 'EXPIRE'
        expired_time = Time.now + input_value[2].to_i
        if @result.key?(input_value[1])
          @result[input_value[1]].set_timeout(expired_time)
          data = {'time_expire': @result[input_value[1]].get_timeout}
        else
          is_success = false
          message = 'ERROR: Key not found'
        end

      when 'TTL'
        if @result.key?(input_value[1])
          data =  @result[input_value[1]].get_timeout
        else
          is_success = false
          message = 'ERROR: Key not found'
        end

        # string input
      when 'SET'
        if @result.key?(input_value[1])
          is_success = false
          message = 'ERROR: Invalid key'
        else
          @result[input_value[1]] = MyString.new(input_value[2])
          data = {'key' =>  input_value[1], 'value' => @result[input_value[1]].string}
        end


      when 'GET'
        if @result[input_value[1]].nil?
          is_success = false
          message = 'ERROR: Key not found'
        else
          is_success = @result[input_value[1]].is_a?(MyString)
          is_success ? data = @result[input_value[1]].get : message = "ERROR: Wrong key for this type"
        end

        #   list input
      when 'RPUSH'
        if @result.key?(input_value[1])
          is_success = false
          message = 'ERROR: Invalid key'
        else
          @result[input_value[1]] = MyList.new(arr_value)
          data = @result[input_value[1]].get_length
        end

      when 'LLEN'
        if @result[input_value[1]].nil?
          is_success = false
          message = 'ERROR: Key not found'
        else
          is_success = @result[input_value[1]].is_a?(MyList)
          is_success ? data = @result[input_value[1]].get_length :  message = 'ERROR: wrong data type'
        end
      when 'LPOP'
        if  @result[input_value[1]].nil?
          is_success = false
          message = 'ERROR: Key not found'
        else
          if @result[input_value[1]].is_a?(MyList)
            data = @result[input_value[1]].first_value
            @result[input_value[1]].remove_value(0)
          else
            message = 'ERROR: Wrong data type'
            is_success = false
          end

        end


      when 'RPOP'
        if  @result[input_value[1]].nil?
          is_success = false
          message = 'ERROR: Key not found'
        else
          if @result[input_value[1]].is_a?(MyList)
            data = @result[input_value[1]].last_value
            @result[input_value[1]].remove_value(@result[input_value[1]].get_length - 1)
          else
            message = 'ERROR: Wrong data type'
            is_success = false
          end

        end

      when 'LRANGE'
        if @result[input_value[1]].nil?
          is_success = false
          message = 'ERROR: Key not found'
        else
          if @result[input_value[1]].is_a?(MyList)
            start = 0
            stop = @result[input_value[1]].get_length
            if input_value[2] && input_value[3]
              start = input_value[2].to_i
              stop = input_value[3].to_i
            end
            data = @result[input_value[1]].get_range(start, stop)
            is_success = true
          else
            message = 'ERROR: Wrong data type'
            is_success = false
          end

        end

        # set input
      when 'SADD'
        if @result.key?(input_value[1])
          message = 'ERROR: Invalid key'
          is_success = false
        else
          @result[input_value[1]] = MySet.new(arr_value)
          data = @result[input_value[1]].card
        end

      when 'SCARD'
        if @result[input_value[1]].nil?
          message = 'ERROR: Key not found'
          is_success = false
        else
          if @result[input_value[1]].is_a?(MySet)
            data = @result[input_value[1]].card
          else
            message = 'ERROR: Wrong data type'
            is_success = false
          end
        end

      when 'SMEMBERS'
        if @result[input_value[1]].nil?
          message = 'ERROR: Key not found'
          is_success = false
        else
          if @result[input_value[1]].is_a?(MySet)
            data = @result[input_value[1]].member.to_a
          else
            message = 'ERROR: Wrong data type'
            is_success = false
          end
        end

      when 'SREM'
        if !@result.key?(input_value[1])
          is_success = false
          message = 'ERROR: Invalid key'
        else
          if @result[input_value[1]].is_a?(MySet)
            @result[input_value[1]].remove_member(arr_value)
            data =  @result[input_value[1]]
          else
            message = 'ERROR: Wrong data type'
            is_success = false
          end

        end


      when 'SINTER'
        if @result[input_value[1]].is_a?(MySet)
          result_inter  = @result[input_value[1]]
        else
          message = 'ERROR: Wrong data type'
          is_success = false
        end

        input_value.length.times do |idx|
          if idx > 1
            if  !@result.key?(input_value[idx])
              result_inter = []
              is_success = false
              message = "ERROR: Key #{input_value[idx]} not found "
            else
              if @result[input_value[idx]].is_a?(MySet)
                result_inter = result_inter.inter(@result[input_value[idx]])
              else
                message = 'ERROR: Wrong data type'
                is_success = false
              end
            end
            break if !is_success
          end

        end
        data = result_inter.member.to_a.sort
      end
      # end cases

      return_data = {
          :data => data,
          :status => is_success,
          :message => message
      }
      return return_data.to_json
    end
  end
end