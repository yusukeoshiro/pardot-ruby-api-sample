class PagesController < ApplicationController

	def login

		uri = URI.parse('https://pi.pardot.com/api/login/version/3') 
		email    = URI.encode_www_form_component( ENV["PARDOT_EMAIL"] )
		password = URI.encode_www_form_component( ENV["PARDOT_PASSWORD"] )
		key      = URI.encode_www_form_component( ENV["PARDOT_KEY"] )
		param = "email=#{email}&password=#{password}&user_key=#{key}&format=json"		
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)
		p '**********'
		p response

		p response["api_key"]
	    

	    render :json => response
	end

	def prospect
		uri = URI.parse('https://pi.pardot.com/api/login/version/3') 
		email    = URI.encode_www_form_component( ENV["PARDOT_EMAIL"] )
		password = URI.encode_www_form_component( ENV["PARDOT_PASSWORD"] )
		key      = URI.encode_www_form_component( ENV["PARDOT_KEY"] )
		param = "email=#{email}&password=#{password}&user_key=#{key}&format=json"		
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)

		api_key = response["api_key"]
		p api_key
		prospect_email = URI.encode_www_form_component( params[:email] )


		uri = URI.parse("https://pi.pardot.com/api/prospect/version/3/do/read/email/#{prospect_email}") 
		param = "api_key=#{api_key}&user_key=#{key}&format=json"		
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)
	    
		@prospect = response["prospect"]

		@prospect["visitor_activities"]["visitor_activity"].sort! do |a, b|  b["created_at"] <=> a["created_at"] end
		#@prospect[]listEvents.sort! do |a, b|  a["created_at"] <=> b["created_at"] end
	    #render :json => response




	end

end
