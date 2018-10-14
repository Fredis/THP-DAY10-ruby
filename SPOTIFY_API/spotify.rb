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

	url = "https://accounts.spotify.com/authorize/?client_id=#{ENV['SPOTIFY_KEY']}&response_type=code&redirect_uri=https://example.com/callback&scope=playlist-modify-public playlist-modify-private user-top-read"
	 
	
	#browser = Watir::Browser.new(:firefox)
	#browser.goto url

end

#Méthode pour obtenir le token d'authorisation en apportant le code de la callback de la méthode get_user_authorization
def post_authorization_code
	authorization_code = "AQDXPwC8DUVCoA7Y7P1iQKAVGkQZnQIwZK102ox_YQ_I06aOol9-yeebDyl13TEyVd1fSKbZwyP8t768XFo6bquXYmN9i1nn8w7dTf7KePTANNlPhcU7inNHZqNjrpRchguqqHzz2IxSmVH7_s4E52AJu4mxQfAi6phiVQRkU9w-1NdX-s9sQQCSzWb48MFpqYHDRydSh7qfYfPM_fZwMIrj_RZPVCYAHxhUYknnNeRZBMNOdyX4AP42SOwy7JZTAQZo4d_t-c5ux1fGWYC5zJl5u_Q"
	puts authentication = HTTParty.post(
		"https://accounts.spotify.com/api/token", 
  	headers: {
	 		"Authorization": "Basic #{encode}"
	 	},
  	body: {
  		grant_type: "authorization_code",
  		code: "#{authorization_code}",
  		redirect_uri: "https://example.com/callback"
  	}
	)
	return authentication["access_token"]

end

#Méthode pour créer une plalist pour un utilisateur donné. A noter l'ajout de la méthode "JSON.generate" qui permet de gérer un contenu lisible en JSON.
def post_create_a_playlist

	get_the_new_token_for_user_modification = post_authorization_code

	puts create_a_playlist_with_a_post = HTTParty.post(
		"https://api.spotify.com/v1/users/FrediSpotify/playlists",
		headers: { 
 			"Authorization": "Bearer #{get_the_new_token_for_user_modification}",
		 	"Content-Type": "application/json"
		 	},
		body: JSON.generate({
			name: "Ruby Playlist",
			public: true
			})
		)
end

#Méthode pour obtenir la totalité des playlists d'un utilisateur.
def get_user_playlists
	get_token
	puts get_playlists = HTTParty.get(
		"https://api.spotify.com/v1/users/FrediSpotify/playlists",
		headers: { 
 			"Authorization": "Bearer #{@token}",
		 	"Content-Type": "application/json"
		 	}
		)
end

#Méthode pour ajouter des sons à une playlist donné.
def add_a_track_to_a_playlist
	get_the_new_token_for_user_modification =	post_authorization_code
	playlist_id = "24ihQXhkNnjB0n6yfnVut9"

	puts add_a_track = HTTParty.post(
		"https://api.spotify.com/v1/playlists/#{playlist_id}/tracks",
		headers: { 
 			"Authorization": "Bearer #{get_the_new_token_for_user_modification}",
		 	"Content-Type": "application/json"
		 	},
		query: {
			uris: "spotify:track:2lFWyfuXtCN8Sb7cHJILva,spotify:track:6aH3QgooXRmx8k8jzrSm3V"
			}
		)
end

#puts get_user_authorization
add_a_track_to_a_playlist