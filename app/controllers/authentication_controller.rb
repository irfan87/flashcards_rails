class AuthenticationController < ApplicationController
	def github
		authenticator = Authenticator.new
		user_info = authenticator.github(params[:code])

		login = user_info[:login]
		name = user_info[:name]
		avatar_url = user_info[:avatar_url]

		# generate token
		token = TokiToki.encode(login)

		# create token if it does not exist
		User.where(login: login).first_or_create!(name: name, avatar_url: avatar_url)

		# after token were created, redirect to the client app
		redirect_to "#{issuer}?token=#{token}"

	rescue StandardError => error
		redirect_to "#{issuer}?error=#{error.message}"
	end

	private

	def issuer
		ENV['FLASHCARDS_CLIENT_URL']
	end
end