require 'dotenv'
require 'base64'
require 'httparty'

Dotenv.load

def encode

	chain =  ENV['SPOTIFY_KEY'] + ":" + ENV['SPOTIFY_SECRET_KEY']
	encoded = Base64.encode64(chain).delete("\n")
end

@token_array = my_post_request = HTTParty.post(
	"https://accounts.spotify.com/api/token", 
  headers: {Authorization: "Basic #{encode}"}, 
  body: {
  		grant_type: "client_credentials"
  	}
	)

@token = @token_array["access_token"]

def get_latest_release
	
	@headers = {
		"Content-Type": 'application/json',
  	"Accept": 'application/json',
  	"Authorization": "Bearer #{@token}"
	}

	my_get_request = HTTParty.get(
		"https://api.spotify.com/v1/browse/new-releases?limit=2",
	  headers: @headers
		)

end

puts get_latest_release