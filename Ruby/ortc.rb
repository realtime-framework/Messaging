require 'rubygems'
require 'faye/websocket'
require 'eventmachine'
require 'net/http'
require 'net/https'
require 'json'
require './ortc_extensibility.rb'

module ORTC	  
	
	MAX_CHANNEL_NAME_SIZE = 100
	MAX_MESSAGE_SIZE = 800
	MAX_HEARTBEAT_INTERVAL = 30
	RECONNECT_INTERVAL = 5
	MAX_CONNECTION_METADATA_SIZE = 255
	

  #Enables presence for the specified channel with first 100 unique metadata if true.
  #
  #*Note:* This method will send your Private Key over the Internet. Make sure to use secure connection.
  #- url - Server containing the presence service
  #- is_cluster - Indicates whether the url is in a cluster.
  #- application_key - Application key with access to presence service
  #- private_key - The private key provided when the ORTC service is purchased.
  #- channel - Channel to activate presence.
  #- metadata - Defines if to collect first 100 unique metadata.
  #- &block - Callback with error and result parameters.
  #
  #Usage:
  # ORTC.enable_presence(ortc_url, true, ortc_app_key, ortc_private_key, channel, true) { |error, result| 
  #     if error.to_s.empty?
  #         puts "result: #{result}"
  #     else
  #         puts "error: #{error}"
  #     end
  # }
  def self.enable_presence(url, is_cluster, application_key, private_key, channel, metadata, &block)
    if url.to_s.empty?
      block.call('URL is null or empty', nil)
    elsif application_key.to_s.empty?
      block.call('Application Key is null or empty', nil)
    elsif private_key.to_s.empty?
      block.call('Private key is null or empty', nil)
    elsif channel.to_s.empty?
      block.call('Channel is null or empty', nil)
    elsif not channel =~ /^[\w\-:\/.]+$/
      block.call('Channel has invalid characters', nil)
    else
      begin
        r_thread = Thread.new {	
          server = ''
          if is_cluster
            server = _get_cluster(url)
            begin
              block.call('Can not connect with the server', nil)
              r_thread.exit
            end if server == ''
          else 
            server = url.clone
          end
          server = server << (server.match(/\/$/) ? 'presence' : '/presence')
          server = server << "/enable/#{application_key}/#{channel}"
          body = "privatekey=#{private_key}&metadata=" << (metadata ? '1' : '0')
          uri = URI.parse(server)
          begin
            if http = Net::HTTP.new(uri.host, uri.port)
              if server.match /^https/
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE
              end
              req = Net::HTTP::Post.new(uri.request_uri)
              req.body = body
              res = http.request(req)
              if res.code == '200'
                block.call(nil, res.body)
              else
                block.call(res.body, nil)
              end
            end
          rescue => e
            block.call(e, nil)
            r_thread.exit
          end
        }
        r_thread.run
      end
    end
  end    

  #Disables presence for the specified channel.
  #
  #*Note:* This method will send your Private Key over the Internet. Make sure to use secure connection.
  #- url - Server containing the presence service
  #- is_cluster - Indicates whether the url is in a cluster.
  #- application_key - Application key with access to presence service
  #- private_key - The private key provided when the ORTC service is purchased.
  #- channel - Channel to disable presence.
  #- &block - Callback with error and result parameters.
  #
  #Usage:
  # ORTC.disable_presence(ortc_url, true, ortc_app_key, ortc_private_key, channel) { |error, result| 
  #     if error.to_s.empty?
  #         puts "result: #{result}"
  #     else
  #         puts "error: #{error}"
  #     end
  # }		
  def self.disable_presence(url, is_cluster, application_key, private_key, channel, &block)
    if url.to_s.empty?
      block.call('URL is null or empty', nil)
    elsif application_key.to_s.empty?
      block.call('Application Key is null or empty', nil)
    elsif private_key.to_s.empty?
      block.call('Private key is null or empty', nil)
    elsif channel.to_s.empty?
      block.call('Channel is null or empty', nil)
    elsif not channel =~ /^[\w\-:\/.]+$/
      block.call('Channel has invalid characters', nil)
    else
      begin
        r_thread = Thread.new {	
          server = ''
          if is_cluster
            server = _get_cluster(url)
            begin
              block.call('Can not connect with the server', nil)
              r_thread.exit
            end if server == ''
          else 
            server = url.clone
          end
          server = server << (server.match(/\/$/) ? 'presence' : '/presence')
          server = server << "/disable/#{application_key}/#{channel}"
          body = "privatekey=#{private_key}"
          uri = URI.parse(server)
          begin
            if http = Net::HTTP.new(uri.host, uri.port)
              if server.match /^https/
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE
              end
              req = Net::HTTP::Post.new(uri.request_uri)
              req.body = body
              res = http.request(req)
              if res.code == '200'
                block.call(nil, res.body)
              else
                block.call(res.body, nil)
              end
            end
          rescue => e
            block.call(e, nil)
            r_thread.exit
          end
        }
        r_thread.run
      end
    end
  end    		

  #Gets a Hash table indicating the subscriptions in the specified channel and if active the first 100 unique metadata.
  #- url - Server containing the presence service
  #- is_cluster - Indicates whether the url is in a cluster.
  #- application_key - Application key with access to presence service
  #- authentication_token - Authentication token with access to presence service
  #- channel - Channel to presence data active.
  #- &block - Callback with error and result parameters.
  #
  #Usage:
  # ORTC.presence(ortc_url, true, ortc_app_key, ortc_auth_token, channel) { |error, result| 
  #     if error.to_s.empty?
  #         puts "result: #{result}"
  #     else
  #         puts "error: #{error}"
  #     end
  # }			
  def self.presence(url, is_cluster, application_key, authentication_token, channel, &block)
    if url.to_s.empty?
      block.call('URL is null or empty', nil)
    elsif application_key.to_s.empty?
      block.call('Application Key is null or empty', nil)
    elsif authentication_token.to_s.empty?
      block.call('Authentication Token is null or empty', nil)
    elsif channel.to_s.empty?
      block.call('Channel is null or empty', nil)
    elsif not channel =~ /^[\w\-:\/.]+$/
      block.call('Channel has invalid characters', nil)
    else
      begin
        r_thread = Thread.new {	
          server = ''
          if is_cluster
            server = _get_cluster(url)
            begin
              block.call('Can not connect with the server', nil)
              r_thread.exit 
            end if server == ''
          else 
            server = url.clone
          end
          server = server << (server.match(/\/$/) ? 'presence' : '/presence')
          server = server << "/#{application_key}/#{authentication_token}/#{channel}"
          #body = "privatekey=#{private_key}"
          uri = URI.parse(server)
          begin
            if http = Net::HTTP.new(uri.host, uri.port)
              if server.match /^https/
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE
              end
              req = Net::HTTP::Get.new(uri.request_uri)							
              res = http.request(req)
              if res.code == '200'
                ret = Hash.new
                ret = JSON.parse(res.body) if not res.body == 'null'
                block.call(nil, ret)
              else
                block.call(res.body, nil)
              end
            end
          rescue => e
            block.call(e, nil)
            r_thread.exit
          end
        }
        r_thread.run
      end
    end
  end


  def self._get_cluster(url)
    begin				
      uri = URI.parse(url)
      if http = Net::HTTP.new(uri.host, uri.port)
        if url.include? 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        uri = URI.parse(url<< "?appkey=#{@app_key}")   
        http.start do |http|
          request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(request)
          response.body.scan(/"(.*?)"/).join
        end
      end
    rescue Timeout::ExitException
      return ''
    rescue Timeout::Error
      return ''
    rescue => e
      return ''
    end
  end


	#A class representing an ORTC Client
	class OrtcClient	
		#The client announcement subchannel
		attr_accessor :announcement_subchannel
		#The client connection metadata
		attr_accessor :connection_metadata
		#The cluster server URL
		attr_accessor :cluster_url
		#The server URL
		attr_accessor :url
		#The client identifier
		attr_accessor :id
		#The client session identifier
		attr_reader :session_id
		#Indicates whether the client is connected
		attr_reader:is_connected				
		
		#Creates a new instance of OrtcClient
		def initialize
			@app_key = nil
			@auth_token = nil
			@ortcserver = nil
			@url = nil
			@is_connected = false
			@is_connecting = false
			@is_disconnecting = false
			@is_reconnecting = false
			@str_set = [('a'..'z'),('0'..'9')].map{|i| i.to_a}.flatten
			@session_id = (0...16).map{@str_set[rand(@str_set.length)]}.join
			@on_connected_callback = nil
			@on_disconnected_callback =nil
			@on_reconnected_callback = nil
			@on_reconnecting_callback = nil
			@on_subscribed_callback = nil
			@on_unsubscribed_callback = nil
			@on_exception_callback = nil
			@permissions_table = Hash.new
			@client_thread = nil
			@heartbeat_thread = nil
			@reconnect_thread = nil
			@channels = Hash.new
			@messages_buffer = Hash.new
			@socket = nil
			@got_heartbeat = false
			EM.error_handler{ |e| 
				raise "Error during event loop: #{e.message}"
				EM.stop_event_loop				
			}		
			Thread.abort_on_exception=true
		end
		
		#Saves the channel and its permissions for the supplied application key and authentication token.
                #
                #*Note:* This method will send your Private Key over the Internet. Make sure to use secure connection.
		#- url - The ORTC server URL.
		#- is_cluster - Indicates whether the ORTC server is in a cluster.
		#- authentication_token - The authentication token generated by an application server (for instance: a unique session ID).
		#- is_private - Indicates whether the authentication token is private.
		#- application_key - The application key provided when the ORTC service is purchased.
		#- time_to_live - The authentication token time to live (TTL), in other words, the allowed activity time (in seconds).
		#- private_key - The private key provided when the ORTC service is purchased.
		#- channels_permissions - The hash table containing  channels and their permissions ('r' - read, 'w' - write, 'p' - presence).
		#Returns boolean- Indicates whether the authentication was successful.
		#
		#Usage:
		# permissions = Hash.new
		# permissions['blue'] = 'r'
		# permissions['yellow'] = 'wp'
		# ortc_client.save_authentication('http://ortc-developers.realtime.co/server/2.1', true,  'Your_authentication_token', false, 'Your_app_key', 1800, 'Your_private_key', permissions)
		def save_authentication(url, is_cluster, authentication_token, is_private, application_key, time_to_live, private_key, channels_permissions)
			unless channels_permissions.class == Hash
				@on_exception_callback.call(self, 'Wrong parameter: channels_permissions') if(@on_exception_callback)	
				return false
			end
			str = "AT=#{authentication_token}&AK=#{application_key}&PK=#{private_key}&TTL=#{time_to_live}&TP=#{channels_permissions.length}&PVT=#{is_private ? "1" : "0"}"
			channels_permissions.each {|channel, permission|
				return false unless is_channel_valid channel, false
				str << "&#{channel}=#{permission}"				
			}	
			if is_cluster
				auth_server = ORTC._get_cluster(url)
				begin
					@on_exception_callback.call(self, 'Can not connect with the server') if(@on_exception_callback)	
					return false 
				end if auth_server == ''
			end	
			auth_server = auth_server << (auth_server.match(/\/$/) ? 'authenticate' : '/authenticate')
			uri = URI.parse(auth_server)
			begin
				if http = Net::HTTP.new(uri.host, uri.port)
					if auth_server.match /^https/
						http.use_ssl = true
						http.verify_mode = OpenSSL::SSL::VERIFY_NONE
					end
					req = Net::HTTP::Post.new(uri.request_uri)
					req.body = str
					res = http.request(req)
				end
				rescue => e
					@on_exception_callback.call(self, e) if(@on_exception_callback)	
					return false
			end
			return res.code=='201' ? true : false
		end		
		
                #Enables presence for the specified channel with first 100 unique metadata if true.
                #
                #*Note:* This method will send your Private Key over the Internet. Make sure to use secure connection.
                #- private_key - The private key provided when the ORTC service is purchased.
                #- channel - Channel to activate presence.
                #- metadata - Defines if to collect first 100 unique metadata.
                #- &block - Callback with error and result parameters.
                #
                #Usage:
                # ortc_client.enable_presence(ortc_private_key, channel, true) { |error, result| 
                #     if error.to_s.empty?
                #         puts "result: #{result}"
                #     else
                #         puts "error: #{error}"
                #     end
                # }
                def enable_presence(private_key, channel, metadata, &block)
                  if not @is_connected
                    @on_exception_callback.call(self, 'Not connected') if(@on_exception_callback)	
                    return false
                  elsif @cluster_url.to_s == '' && @url.to_s == ''
                    @on_exception_callback.call(self, 'URL is empty') if(@on_exception_callback)	
                    return false
                  else
                    if not @url.to_s.empty?
                      ORTC.enable_presence(@url, false, @app_key, private_key, channel, metadata, &block)
                    else
                      ORTC.enable_presence(@cluster_url, true, @app_key, private_key, channel, metadata, &block)
                    end
                  end
                end


                #Disables presence for the specified channel.
                #
                #*Note:* This method will send your Private Key over the Internet. Make sure to use secure connection.
                #- private_key - The private key provided when the ORTC service is purchased.
                #- channel - Channel to disable presence.
                #- &block - Callback with error and result parameters.
                #
                #Usage:
                # ortc_client.disable_presence(ortc_private_key, channel) { |error, result| 
                #     if error.to_s.empty?
                #         puts "result: #{result}"
                #     else
                #         puts "error: #{error}"
                #     end
                # }
                def disable_presence(private_key, channel, &block)
                  if not @is_connected
                    @on_exception_callback.call(self, 'Not connected') if(@on_exception_callback)	
                    return false
                  elsif @cluster_url.to_s == '' && @url.to_s == ''
                    @on_exception_callback.call(self, 'URL is empty') if(@on_exception_callback)	
                    return false
                  else
                    if not @url.to_s.empty?
                      ORTC.disable_presence(@url, false, @app_key, private_key, channel, &block)
                    else
                      ORTC.disable_presence(@cluster_url, true, @app_key, private_key, channel, &block)
                    end
                  end
                end


                #Gets a Hash table indicating the subscriptions in the specified channel and if active the first 100 unique metadata.
                #- channel - Channel to presence data active.
                #- &block - Callback with error and result parameters.
                #
                #Usage:
                # ortc_client.presence(channel) { |error, result| 
                #     if error.to_s.empty?
                #         puts "result: #{result}"
                #     else
                #         puts "error: #{error}"
                #     end
                # }
                def presence(channel, &block)
                  if not @is_connected
                    @on_exception_callback.call(self, 'Not connected') if(@on_exception_callback)	
                    return false
                  elsif @cluster_url.to_s == '' && @url.to_s == ''
                    @on_exception_callback.call(self, 'URL is empty') if(@on_exception_callback)	
                    return false
                  else
                    if not @url.to_s.empty?
                      ORTC.presence(@url, false, @app_key, @auth_token, channel, &block)
                    else
                      ORTC.presence(@cluster_url, true, @app_key, @auth_token, channel, &block)
                    end
                  end
                end
		
		#Indicates whether the client is subscribed to the supplied channel.
		#- channel - The channel name.
		#Returns boolean - Indicates whether the client is subscribed to the supplied channel.
		#
		#Usage:
		# puts ortc_client.is_subscribed('blue')
		def is_subscribed(channel)
			return false unless is_channel_valid channel
			ch = @channels[channel]
			return false if ch == nil
			return ch.is_subscribed
		end
		
		#Sets the callback which occurs when the client connects.
		#- block - code to be interpreted when the client connects.
		#Usage:		
		# ortc_client.on_connected  do |sender|
		#  p [:Connected]
		# end
		def on_connected(&block) @on_connected_callback = block end
		
		#Sets the callback which occurs when the client disconnects.
		#- block - code to be interpreted when the client disconnects.
		#Usage:		
		# ortc_client.on_disconnected  do |sender|
		#  p [:Disconnected]
		# end
		def on_disconnected(&block) @on_disconnected_callback = block end
		
		#Sets the callback which occurs when the client reconnects.
		#- block - code to be interpreted when the client reconnects.
		#Usage:		
		# ortc_client.on_reconnected  do |sender|
		#  p [:Reconnected]
		# end
		def on_reconnected(&block) @on_reconnected_callback = block end
		
		#Sets the callback which occurs when the client attempts to reconnect.
		#- block - code to be interpreted when the client attempts to reconnect.
		#Usage:		
		# ortc_client.on_reonnecting  do |sender|
		#  p [:Reconnecting]
		# end
		def on_reconnecting(&block) @on_reconnecting_callback = block end
		
		#Sets the callback which occurs when the client subscribes to a channel.
		#- block - code to be interpreted when the client subscribes to a channel.
		#Usage:	
		# ortc_client.on_subscribed do |sender, channel|
		#  p [:Subscribed, channel]
		# end
		def on_subscribed(&block) @on_subscribed_callback = block end
		
		#Sets the callback which occurs when the client unsubscribes from a channel.
		#- block - code to be interpreted when the client unsubscribes from a channel.
		#Usage:		
		# ortc_client.on_unsubscribed do |sender, channel|
		#  p [:Unsubscribed, channel]
		# end
		def on_unsubscribed(&block) @on_unsubscribed_callback = block end
		
		#Sets the callback which occurs when there is an exception.
		#- block - code to be interpreted when there is an exception.
		#Usage:		
		# ortc_client.on_exception do |sender, exception|
		#  p [:Exception, exception]
		# end
		def on_exception(&block) @on_exception_callback = block end
		
		#Connects the client using the supplied application key and authentication token.
		#- application_key - Your ORTC application key.
		#- authentication_token - Your ORTC authentication token, this parameter is optional.
		#Usage:		
		# ortc_client.connect 'aBc123'
		# ortc_client.connect 'aBc123', 'au7h3n71ca710nT0k3n'
		def connect(application_key, authentication_token='PM.Anonymous')
			begin
				@on_exception_callback.call(self, "Metadata exceeds the limit of #{MAX_CONNECTION_METADATA_SIZE} bytes") if(@on_exception_callback)	
				return
			end if @connection_metadata.bytes.to_a.size > MAX_CONNECTION_METADATA_SIZE if @connection_metadata != nil
			begin 
				@on_exception_callback.call(self, 'Wrong Applicaition Key') if(@on_exception_callback)	
				return 
			end if (!application_key.is_a?(String) || application_key.size < 1)			
			$1 if application_key =~ /^[\w\-:\/.]+$/ or begin @on_exception_callback.call(self, "Application key: \"#{application_key}\" has invalid characters") if (@on_exception_callback)
				return end					
			$1 if authentication_token =~ /^[\w\-:\/.]+$/ or begin @on_exception_callback.call(self, "Authentication token: \"#{authentication_token}\" has invalid characters") if (@on_exception_callback)
				return end					
			begin 
				@on_exception_callback.call(self, 'Already connected') if(@on_exception_callback)	
				return 
			end if @is_connected 
			begin 
				@on_exception_callback.call(self, 'Already trying to connect') if(@on_exception_callback)	
				return 
			end if @is_connecting		
			begin
				@on_exception_callback.call(self, 'URL is empty') if(@on_exception_callback)	
				return 
			end if @cluster_url.to_s == '' && @url.to_s == ''
			
			@is_connecting = true
			@app_key = application_key
			@auth_token = authentication_token
			@client_thread = nil
			@client_thread = Thread.new {				
				if @url.to_s == ''
					$1 if @cluster_url=~ /^(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/ or begin @on_exception_callback.call(self, "Invalid cluster URL") if (@on_exception_callback)
						@client_thread.kill if @client_thread end
					@ortcserver = ORTC._get_cluster(@cluster_url)
				else
					$1 if @url=~ /^(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/ or begin @on_exception_callback.call(self, "Invalid URL") if (@on_exception_callback)
						@client_thread.kill if @client_thread end
					@ortcserver = @url.clone
				end
				begin 
					@on_exception_callback.call(self, 'There is no server available') if @on_exception_callback
					@is_connecting = false
					@client_thread.kill if @client_thread
				end if @ortcserver.to_s == ''
				@ortcserver["http"]="ws" if @ortcserver["http"]
				conn_str =  "#{@ortcserver}/broadcast/#{rand(1000)}/#{(0...8).map{@str_set[rand(@str_set.length)]}.join}/websocket"

				EM.run {					
					@socket = Faye::WebSocket::Client.new(conn_str)

					@socket.onopen = lambda do |event|
						
					end

					@socket.onmessage = lambda do |event|								
						if event.data.eql? "o"	
							EM.next_tick {
								@socket.send "validate;#{@app_key};#{@auth_token};#{@announcement_subchannel};#{@session_id};#{@connection_metadata}".to_json
							}
						elsif event.data != "h"
							parse_message event.data
						else
							@got_heartbeat = true
						end
					end
									
					@socket.onclose = lambda do |event|
						if(@is_disconnecting || @is_connecting)
							@on_disconnected_callback.call(self) if(@on_disconnected_callback && @is_disconnecting)								
							@is_disconnecting = false
							@is_connecting = false								
							unless @is_reconnecting
								@reconnect_thread.kill if @reconnect_thread
								@channels.clear
							end
							@heartbeat_thread.kill if @heartbeat_thread 
						end
						@is_connected = false
						EM.stop_event_loop
					end
				}
			}
			@client_thread.run
		end

		#Disconnects the client.
		#
		#Usage:		
		# ortc_client.disconnect
		def disconnect
			begin @on_exception_callback.call(self, 'Not connected') if(@on_exception_callback)
				return
			end unless @is_connected || @is_reconnecting
			if @is_reconnecting
				@reconnect_thread.kill if @reconnect_thread
				@heartbeat_thread.kill if @heartbeat_thread 
			end
			@is_connecting = false
			@is_reconnecting = false
			@is_disconnecting = true
			@channels.clear
			@socket.close(nil, nil ,nil)			
			@client_thread.kill if @client_thread
		end
		
		#Subscribes to the supplied channel to receive messages sent to it.
		#- channel - The channel name.
		#- subscribeOnReconnected - Indicates whether the client should subscribe to the channel when reconnected (if it was previously subscribed when connected).
		#- block - the callback called when a message arrives at the channel.
		#Usage:		
		# ortc_client.subscribe('blue', true) { |sender, channel, message| 
		#	 puts "Message received on (#{channel}): #{message}" 		
		# }
		def subscribe(channel, subscribe_on_reconnect, &block)
			return unless is_channel_valid channel
			ch = @channels[channel]
			if ch != nil
				begin 
					@on_exception_callback.call(self,  "Already subscribing to the channel #{channel}") if(@on_exception_callback)	
					return 
				end  if ch.is_subscribing
				begin 
					@on_exception_callback.call(self,  "Already subscribed to the channel #{channel}") if(@on_exception_callback)	
					return 
				end  if ch.is_subscribed
			end
			unless @permissions_table.empty?
				hash = check_permissions 'subscribe', channel 
				return if hash == nil
			end
									
			@channels[channel] = Channel.new(channel, block, true, subscribe_on_reconnect) unless ch
			EM.next_tick {
				@socket.send "subscribe;#{@app_key};#{@auth_token};#{channel};#{hash}".to_json
			}
		end
		
		#Unsubscribes from the supplied channel to stop receiving messages sent to it.
		#- channel - The channel name.
		#Usage:		
		# ortc_client.unsubscribe('blue')
		def unsubscribe(channel)
			return unless is_channel_valid channel
			ch = @channels[channel]
			if ch != nil
				begin @on_exception_callback.call(self,  "Not subscribed to the channel #{channel}") if(@on_exception_callback)	
				return end  unless ch.is_subscribed
				ch.subscribe_on_reconnected = false
				EM.next_tick {
					@socket.send "unsubscribe;#{@app_key};#{channel}".to_json
				}
			else
				@on_exception_callback.call(self,  "Not subscribed to the channel #{channel}") if(@on_exception_callback)	
			end
		end
		
		#Sends the supplied message to the supplied channel.
		#- channel - The channel name.
		#- message - The message to send.
		#Usage:		
		# ortc_client.send('blue', 'This is a message')
		def send(channel, message)
			return false unless is_channel_valid channel
			begin 
				@on_exception_callback.call(self, 'Message is null or empty') if(@on_exception_callback)	
				return 
			end if message.to_s.empty?
			unless @permissions_table.empty?
				hash = check_permissions 'send', channel 
				return false if hash == nil
			end
			message_id = (0...8).map{@str_set[rand(@str_set.length)]}.join
			parts = message.bytes.to_a.each_slice(MAX_MESSAGE_SIZE).to_a
			EM.next_tick {
				parts.each_with_index { |part, index| 
					@socket.send  "send;#{@app_key};#{@auth_token};#{channel};#{hash};#{message_id}_#{index+1}-#{parts.length}_#{part.pack('c*')}".to_json				       
				}				
			}
			return true
		end
		
		private		
		
		def reconnect
			@reconnect_thread = Thread.new{				
				until @is_connected do
					sleep RECONNECT_INTERVAL					
					connect @app_key, @auth_token unless @is_connected
				end
			}
			@reconnect_thread.run
		end
		
		def check_connection_loop
				@heartbeat_thread = Thread.new{
					loop do
						counter = 0
						while counter < MAX_HEARTBEAT_INTERVAL
							sleep 1
							if @got_heartbeat
								counter = 0
								@got_heartbeat = false
							end
							counter += 1
						end
						if @is_connected
							@is_connected = false
							@is_disconnecting = false
							@is_reconnecting = true
							EM.stop_event_loop if EM.reactor_running?
							@on_reconnecting_callback.call(self) if(@on_reconnecting_callback)
							reconnect
							@heartbeat_thread.kill if @heartbeat_thread
						end
					end
				}
				@heartbeat_thread.run
		end
		
		def check_permissions(reason, channel)
			hash = @permissions_table[channel]
			if hash == nil && !(channel=~ /^[\w\-\/]+:./).nil?
				subchannel = channel[/^[\w\-\/]+:/]+'*'
				puts "cp #{subchannel} z #{@permissions_table}"
				hash = @permissions_table[subchannel]			
			end
			if hash==nil
				@on_exception_callback.call(self, "No permission found to #{reason} to the channel #{channel}") if (@on_exception_callback)
				return
			end
			return hash
		end
		
		def is_channel_valid(channel, check_connection = true)
			if check_connection
				begin 
					@on_exception_callback.call(self, 'Not connected') if(@on_exception_callback)	
					return 
				end unless @is_connected 
			end
			$1 if channel =~ /^[\w\-:\/.]+$/ or begin @on_exception_callback.call(self, "Channel name: #{channel} has invalid characters") if (@on_exception_callback)
				return end					
			begin 
				@on_exception_callback.call(self, "Channel name size exceeds the limit of #{MAX_CHANNEL_NAME_SIZE} characters") if(@on_exception_callback)	
				return 
			end if channel.length > MAX_CHANNEL_NAME_SIZE
			return true
		end
		

		
		def parse_message(message)
			message = message.gsub("\\\"", "\"")
			unless (message =~/^a?\["\{"ch":"(.*)","m":"([\s\S]*?)"\}"\]$/).nil?
				channel = $1
				raw_message = $2				
				unless (raw_message =~/^(.[^_]*)_(.[^-]*)-(.[^_]*)_([\s\S]*?)$/).nil?
					if($2.to_i==1 && $3.to_i==1)
						m = $4.gsub("\\\\n","\n").gsub("\\\"", "\"").gsub("\\\\\\\\", "\\").gsub(/\\"/, '"')
						@channels[channel].on_received_message(self, m) if @channels[channel]
					else						
						if @messages_buffer[$1].nil?
							@messages_buffer[$1] = MultiMessage.new($3.to_i)							
						end
						@messages_buffer[$1].set_part($2.to_i-1, $4)
						if @messages_buffer[$1].is_ready
							all = @messages_buffer[$1].get_all.gsub("\\\\n","\n").gsub("\\\"", "\"").gsub("\\\\\\\\", "\\").gsub(/\\"/, '"')
							@messages_buffer[$1] = nil
							@channels[channel].on_received_message(self, all) if @channels[channel]
						end
					end
					return
				end
				@channels[channel].on_received_message(self, raw_message.gsub("\\\\n","\n").gsub("\\\"", "\"").gsub("\\\\\\\\", "\\").gsub(/\\"/, '"')) if @channels[channel]
			end
			unless (message =~ /^a\["\{"op":"([^"]+)",(.*)\}"\]$/).nil? #operation
				operation = $1
				params = $2		
				unless (params =~ /^\"up\":{1}(.*),\"set\":(.*)$/).nil? #validated
					if $1 == 'null'
						@permissions_table = Hash.new
					else
						@permissions_table = JSON.parse($1) if $1 != 'null'
					end					
					#session_expiration_time = $2
					check_connection_loop		#starts a thread to watch for connection breaks
					@is_connected = true
					@is_connecting = false
					if @is_reconnecting			
						@channels.each { |channel_name,channel| 								
							if channel == nil
								@channels.delete(channel_name)
								next
							end
							if channel.subscribe_on_reconnected
								channel.is_subscribing = true
								channel.is_subscribed = false
								unless @permissions_table.empty?									
									hash = check_permissions 'subscribe', channel.name 
									next if hash == nil
								end
								EM.next_tick {
									@socket.send "subscribe;#{@app_key};#{@auth_token};#{channel_name};#{hash}".to_json				
								}
							else
								@channels.delete(channel_name)
							end							
						}
						@on_reconnected_callback.call(self) if(@on_reconnected_callback)
					else												
						@on_connected_callback.call(self) if(@on_connected_callback)
					end
					@is_reconnecting = false					
				end
				unless (params =~ /^\"ex\":(\{.*\})$/).nil? #error
					error = JSON.parse($1)
					@on_exception_callback.call(self, error['ex']) if(@on_exception_callback)		
				end
				if operation=="ortc-subscribed"					
					channel = (JSON.parse "{#{params}}")["ch"]
					@channels[channel].is_subscribing = false
					@channels[channel].is_subscribed = true
					@on_subscribed_callback.call(self, channel) if(@on_subscribed_callback)	
				end
				if operation=="ortc-unsubscribed"
					channel = (JSON.parse "{#{params}}")["ch"]
					@channels[channel] = nil
					@on_unsubscribed_callback.call(self, channel) if(@on_unsubscribed_callback)	
				end
			end			
		end		
	end
  	
end
