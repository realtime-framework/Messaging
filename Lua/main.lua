--ORTC_LIB_PATH = "./lib"

require("OrtcClient")

local ortcClient = OrtcClient:new{}

local url = "http://ortc-developers.realtime.co/server/2.1/"
local isCluster = true

local appKey = "YOUR_APPLICATION_KEY"
local authToken = "YOUR_AUTHENTICATION_TOKEN"
local channel = "MyChannel"
local message = "hello world!"
local privateKey = "YOUR_APPLICATION_PRIVATE_KEY"
local permissions = {}
local authRequired = false


local function doLog (text)
	if text ~= nil then
		print(os.date("%H:%M:%S").." - "..tostring(text))
	end
end

local function doSubscribe ()
	doLog("Subscribing to: "..channel.."...")

	local function onYellowMessage (obj, chn, msg)
		doLog("Received at "..chn..": "..msg)

		--doLog("Unsubscribing from "..channel.."...")
		--ortcClient:unsubscribe(channel)
	end

	ortcClient:subscribe(channel, true, onYellowMessage)

	-- Also subscribe to channel 'blue'
	local channel1 = "blue"
	doLog("Subscribing to "..channel1.."...")

	local function onBlueMessage (obj, chn, msg)
		doLog("Received at "..chn..": "..msg)

		--doLog("Unsubscribing from "..channel.."...")
		--ortcClient:unsubscribe(channel)
	end

	ortcClient:subscribe(channel1,true, onBlueMessage)
end

local function onConnected (obj)
	doLog("Connected to: "..obj.url)
	doLog("Session ID: "..(obj.sessionId or ""))

	doSubscribe()
end

local function onDisconnected (obj)
	doLog("Disconnected")
end

local function onSubscribed (obj, chn)
	doLog("Subscribed to: "..chn)
	doLog("Send message: "..message.." - to channel: "..chn)

	ortcClient:send(chn, message)
end

local function onUnsubscribed (obj, chn)
	doLog("Unsubscribed from: "..chn)
	doLog("Disconnecting...")

	ortcClient:disconnect()
end

local function onException (obj, err)
	doLog("Error: "..err)
end

local function onReconnecting (obj)
	doLog("Reconnecting to: "..url.."...")

	-- Stop the reconnect process
	--ortcClient:disconnect()
end

local function onReconnected (obj)
	doLog("Reconnected to: "..obj.url)
end

local function saveAuthenticationCallback (err, res)
	if err ~= nil then
		doLog("Unable to post permissions: "..err)
	else
		doLog("Permissions posted")
		doLog("Connecting to: "..url.."...")

		ortcClient:connect(appKey, authToken)
	end
end

ortcClient.id = "LuaId"
ortcClient.connectionMetadata = "UserConnectionMetadata"

if isCluster then
	ortcClient.clusterUrl = url
else
	ortcClient.url = url
end

ortcClient.onConnected = onConnected
ortcClient.onDisconnected = onDisconnected
ortcClient.onSubscribed = onSubscribed
ortcClient.onUnsubscribed = onUnsubscribed
ortcClient.onException = onException
ortcClient.onReconnecting = onReconnecting
ortcClient.onReconnected = onReconnected

permissions["MyChannel"] = "w"

if authRequired then
	ortcClient:saveAuthentication(url, isCluster, authToken, false, appKey, 1800, privateKey, permissions, saveAuthenticationCallback)
else
        doLog("Connecting to: "..url.."...")
        ortcClient:connect(appKey, authToken)
end

