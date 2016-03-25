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
		session["api_key"] = api_key
		p "apikey = #{api_key}"


		prospect_email = URI.encode_www_form_component( params[:email].gsub(" ","+") )


		uri = URI.parse("https://pi.pardot.com/api/prospect/version/3/do/read/email/#{prospect_email}") 
		param = "api_key=#{api_key}&user_key=#{key}&format=json"		
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)
		p response["@attributes"]["stat"]

		if response["@attributes"]["stat"] == "fail"
			@prospect = nil
		else
			@prospect = response["prospect"]
			@prospect["visitor_activities"]["visitor_activity"].sort! do |a, b|  b["created_at"] <=> a["created_at"] end
		end
	    
		
	
	end

	def visits
		activity_id = params[:activity_id]
		uri = URI.parse("https://pi.pardot.com/api/VisitorActivity/version/3/do/read/id/#{activity_id}") 
		key      = URI.encode_www_form_component( ENV["PARDOT_KEY"] )
		api_key  = URI.encode_www_form_component( session["api_key"] )
		param = "api_key=#{api_key}&user_key=#{key}&format=json"		
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)

		visitor_id = response["visitor_activity"]["visitor_id"]
		uri = URI.parse("https://pi.pardot.com/api/visitor/version/3/do/read/id/#{visitor_id}") 
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)


		@page_views = Array.new
		response["visitor"]["visitor_activities"]["visitor_activity"].each do |a|
			if a["type"] == 20
				p "...iterating...."
				visit_id = a["visit_id"]
				uri = URI.parse("https://pi.pardot.com/api/visit/version/3/do/read/id/#{visit_id}") 
				https = Net::HTTP.new(uri.host, 443)
				https.use_ssl = true
				https.verify_mode = OpenSSL::SSL::VERIFY_PEER
				res = https.post(
				    uri.request_uri, param
				)
				response = JSON.parse(res.body)

				p "::::::::::::::::::"
				element = nil
				if response["visit"]["visitor_page_views"]["visitor_page_view"].instance_of?(Array)
					element = response["visit"]["visitor_page_views"]["visitor_page_view"]
				else
					element = [response["visit"]["visitor_page_views"]["visitor_page_view"]]
				end
				
				@page_views = @page_views + element
				p element
				p @page_views.length


			end

		end
		
		@page_views.sort! do |a, b|  b["created_at"] <=> a["created_at"] end		

		render :json => @page_views
	end

end
