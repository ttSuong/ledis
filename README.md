# Link Interface
https://ledisapp.herokuapp.com
# Detail 
   - It's webservice allow for user can call to process list commands 
# Usage
      POST  HTTP/1.1
      Host: ledisapp.herokuapp.com
      Cache-Control: no-cache
      Body: command
      
 
# Describe my design
* Language: Ruby
* Framework / lib : rack, rest-client

Use Ruby for project because ruby support many functions to completed project faster. 
Rack: Ruby Webserver Interface. It provides a minimal interface between webservers that support Ruby and Ruby frameworks

1. Interface
    # Detail
    - Build a server via HTTP to another call gem can use Ledis
    - Use Rack gem to build it.
    - 2 method built for this server : POST / GET
    * POST
        - user will enter input (list command request as below), server will response data with json 
        - format data 
        {
            data = [],
            status: true/false,
            message: ''
        }
        
    * GET
        - show page index
    # Usage
2. Commands
* String: 
        - SET key value
        - GET key
    * List:
        - LLEN key
        - RPUSH key value1 [value2...]
        - LPOP key
        - RPOP key
        - LRANGE key start stop
        
     * Set:
        - SADD key value1 [value2...]
        - SCARD key
        - SMEMBERS key
        - SREM key value1 [value2...]
        - SINTER [key1] [key2] [key3]
        
      * Data Expiration
        - KEYS
        - DEL key
        - FLUSHDB
        - EXPIRE key seconds
        - TTL key
      * Snapshot
        - SAVE
        - RESTORE
 
3. Web cli

    # Installation
     gem build ledis.gemspec
     gem install --local ledis-cli
     ledis-cli
     # Usage
     This web cli support call interface above. 
    
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

