require "./ortc.rb"

ortc_client = ORTC::OrtcClient.new

ortc_url = 'http://ortc-developers.realtime.co/server/2.1'
ortc_app_key = 'YOUR_APPLICATION_KEY'
ortc_auth_token = 'YourAuthenticationToken' #needed only when using authentication
ortc_private_key = 'YOUR_APPLICATION_PRIVATE_KEY' #needed only for 'saving authentication and enable/disable presence

ortc_client.cluster_url = ortc_url

ortc_client.on_connected  do |sender|
	p [:Connected]
end

ortc_client.on_disconnected  do |sender|
	p [:Disconnected]
end

ortc_client.on_exception do |sender, exception|
	p [:Exception, exception]
end

ortc_client.on_subscribed do |sender, channel|
	p [:Subscribed, channel]
end

ortc_client.on_unsubscribed do |sender, channel|
	p [:Unsubscribed, channel]
end

ortc_client.on_reconnecting do |sender| 
	p [:Reconnecting]
end

ortc_client.on_reconnected do |sender| 
	p [:Reconnected]
end

command = ""
t = Thread.new {
	puts "q - quit, 1 - connect, 2 - disconnect, 3 - subscribe, 4 - unsubscribe, 5 - send, 6 - save authentication, 7 - Enable presence, 8 - Disable presence, 9 - Presence"
	begin	
		command = gets.chomp
		if(command == "1")
			ortc_client.connect ortc_app_key, ortc_auth_token
		end
		if(command == "2")
			ortc_client.disconnect		
		end
		if(command == "3")
			puts "Subscribing... Channel name:"
			channel_name = gets.chomp
			ortc_client.subscribe(channel_name, true) { |sender, channel, message| puts "Received: #{message}" }
		end
		if(command == "4")
			puts "Unsubscribing... Channel name:"
			channel_name = gets.chomp
			ortc_client.unsubscribe channel_name
		end
		if(command == "5")
			puts "Sending message... Channel name:"
			channel_name = gets.chomp
			puts "Message to send:"
			message = gets.chomp
			ortc_client.send(channel_name, message)
		end
		if command == "6"
			puts "Saving authentication..."
			permissions = Hash.new
			begin
				puts "Channel name:"
				channel_name = gets.chomp				
				puts "Permission: (r)ead, (w)rite, (p)resence"
				permission = gets.chomp
				permissions[channel_name] = permission
				puts "Do you want to add permissions for another channel? (y/n)"
				response = gets.chomp
			end until response != 'y'
			puts "Saving authentication..."
			puts ortc_client.save_authentication(ortc_url, true, ortc_auth_token, false, ortc_app_key, 1800, ortc_private_key, permissions) ? 'Success' : 'Failed'			
		end
		if command == "7"
            puts "Enabling presence..."
            puts "Channel name:"
            channel_name = gets.chomp
            ORTC.enable_presence(ortc_url, true, ortc_app_key, ortc_private_key, channel_name, true) { |error, result| 
					if error.to_s.empty?
						puts "result: #{result}"
					else
						puts "error: #{error}"
					end
			}

        end

		if command == "8"
            puts "Disabling presence..."
            puts "Channel name:"
            channel_name = gets.chomp
            ORTC.disable_presence(ortc_url, true, ortc_app_key, ortc_private_key, channel_name) { |error, result| 
					if error.to_s.empty?
						puts "result: #{result}"
					else
						puts "error: #{error}"
					end
			}

        end	
		if command == "9"
            puts "Presence..."
            puts "Channel name:"
            channel_name = gets.chomp
            ORTC.presence(ortc_url, true, ortc_app_key, ortc_auth_token, channel_name) { |error, result| 
					if error.to_s.empty?
						puts "result: #{result}"
					else
						puts "error: #{error}"
					end
			}

        end
	end until command == "q"
}
t.run

while command != "q"	
end
