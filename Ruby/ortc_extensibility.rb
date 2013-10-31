module ORTC	
	
	class Channel
		attr_accessor :is_subscribing, :is_subscribed, :subscribe_on_reconnected, :name
		def initialize(name, on_message, is_subscribing, subscribe_on_reconnected = true)
			@name = name
			@is_subscribing = is_subscribing || false
			@is_subscribed = false
			@subscribe_on_reconnected = subscribe_on_reconnected
			@on_message = on_message
		end

		def on_received_message(sender, message)			
			@on_message.call(sender,  @name, message) if @on_message
		end		
	end
	
	class MultiMessage
		attr_reader :total_parts, :ready_parts
		def initialize(total_parts)
			@total_parts = total_parts
			@ready_parts = 0
			@parts = Array.new total_parts
		end
		
		def set_part(part_id, part)
			@ready_parts+=1 if @parts[part_id]==nil
			@parts[part_id] = part
		end
		
		def is_ready
			return true if @ready_parts == @total_parts
		end
		
		def get_all
                  return @parts.join("")
		end
	end	
	
end
