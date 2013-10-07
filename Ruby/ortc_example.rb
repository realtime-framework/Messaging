require "./ortc.rb"

ortc_client = ORTC::OrtcClient.new
ortc_client.cluster_url = 'http://ortc-developers.realtime.co/server/2.1'

@mc = lambda {|sender, channel, message| puts "cb: #{message}"}

ortc_client.on_connected  do |sender|
	p [:Connected]
	ortc_client.subscribe("blue", true) {|sender, channel, message| 
		@mc.call sender, channel, message }
	#ortc_client.subscribe("blue", true) { |sender, channel, message| 
	#	puts "Message received on (#{channel}): #{message}" 
	#	ortc_client.unsubscribe(channel)
	#}
end
	
ortc_client.on_disconnected  do |sender|
	p [:Disconnected]
end

ortc_client.on_exception do |sender, exception|
	p [:Exception, exception]
end

ortc_client.on_subscribed do |sender, channel|
	p [:Subscribed, channel]
	ortc_client.send(channel, 'This is a message')
end

ortc_client.on_unsubscribed do |sender, channel|
	p [:Unsubscribed, channel]
	ortc_client.disconnect
end

ortc_client.on_reconnecting do |sender| 
	p [:Reconnecting]
end

ortc_client.on_reconnected do |sender| 
	p [:Reconnected]
end

ortc_client.connect 'YOUR_APPLICATION_KEY', 'Your_token'

loop do
  sleep 1
end
