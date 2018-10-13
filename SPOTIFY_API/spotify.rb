require 'dotenv'
require 'base64'
require 'httparty'
require 'watir'

Dotenv.load

#Méthode pour encoder les clés d'API Spotify
def encode
	chain =  ENV['SPOTIFY_KEY'] + ":" + ENV['SPOTIFY_SECRET_KEY']
	encoded = Base64.encode64(chain).delete("\n")
end

#Méthode pour obtenir un token de la part de Spotify et être autorisé à parcourir les données publics (non utilisateur)
def get_token

	@token_array = my_post_request = HTTParty.post(
		"https://accounts.spotify.com/api/token", 
  	headers: {Authorization: "Basic #{encode}"}, 
  	body: {
  		grant_type: "client_credentials"
  	}
	)

	@token = @token_array["access_token"]

end

#Méthode pour obtenir les dernières releases de la part de Spotify
def get_latest_release

	@headers = {
		"Content-Type": 'application/json',
 		"Accept": 'application/json',
 		"Authorization": "Bearer #{@token}"
	}

	my_get_request = HTTParty.get(
		"https://api.spotify.com/v1/browse/new-releases?limit=1",
	  headers: @headers
		)

end

#Méthode test pour parcourir les données des dernières releases Spotify
def list_latest_release

	array_list = get_latest_release

	array_list.each do |key, value|
		value.each do |key_info, value_info|
			puts key_info
		end
	
	end
end

#Méthode pour créer l'URL permettant à l'utilisateur d'autoriser le partage des données à mon application (authentification OAuth2)
def get_user_authorization

=begin
	my_get_authorization_request = HTTParty.get(
	"https://accounts.spotify.com/authorize/",
		query: {
			client_id: ENV['SPOTIFY_KEY'],
			response_type: "code",
			redirect_uri: "https://example.com/callback",
			scopes: "playlist-modify-public" "playlist-modify-private"
			}
		)
=end

	puts url = "https://accounts.spotify.com/authorize/?client_id=#{ENV['SPOTIFY_KEY']}&response_type=code&redirect_uri=https://google.com&scope=playlist-modify-public playlist-modify-private"
	
	#browser = Watir::Browser.new(:firefox)
	#browser.goto url

end

#Méthode pour créer une playlist Spotify à un utilisateur (s'assure au préalable de l'authentification de l'user via OAuth2)
def create_a_playlist


end

puts get_user_authorization