require "json"
require "httparty"


def build_query(query:, name:, values:)
    q = "{#{query}(#{name}) {"

    values.each do |item|
        if item == values[-1]
            q += "#{item}"
        else
            q += "#{item} "
        end
    end

    return q += "}}"
end


class User
    include HTTParty
    base_uri 'https://repl.it'

    def initialize(name)
        q = {
            query: build_query(
                query: "userByUsername",
                name: "username: \"#{name}\"",
                values: ["karma", "firstName", "lastName", "bio"]
            )
        }

        h = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            'X-Requested-With':'Repl.it',
            'Referrer': 'https://repl.it',
            'Origin': 'https://repl.it'
        }

        @options = {body: q.to_json, headers: h, format: :text}
    end

    def info
        return self.class.post("/graphql", @options)
    end

    def info_variant
        return self.class.get("/graphql", @options)
    end
end

r = User.new("IreTheKID")

puts r.info
#puts r.info_variant
