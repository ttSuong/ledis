# Redis
* Describe my design
* Language: Ruby
* Framework / lib : rack, rest-client

Use Ruby for project because ruby support many functions to completed project faster
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
        - show data example
    # Usage
2. Commands

 
3. Web cli

    #Installation
    $ gem build ledis-cli.gemspec
    $ gem install --local ledis-cli
    $ ledis-cli
    
    
    
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

