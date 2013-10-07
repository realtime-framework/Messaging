var userPerms;
var appKey;
var authToken;
var ortcObj;
var controlsPrefix = "Connection1_";

window.onload = function () {
    var url = $('#' + controlsPrefix + 'txtUrl').val();

    appKey = $('#' + controlsPrefix + 'txtApplicationKey').val();
    authToken = $('#' + controlsPrefix + 'txtAuthToken').val();
        
    loadOrtcFactory(IbtRealTimeSJType, function (factory, error) {    
        if (error != null) {
            alert('Factory error: ' + error.message);
        } else {
            // Create ORTC client
            ortcObj = factory.createClient();

            ortcObj.setId('ortcDebugConsole');
            ortcObj.setConnectionTimeout(5000);

            ortcObj.onConnected = function (ortc) { onConnected(ortc); };
            ortcObj.onDisconnected = function (ortc) { onDisconnected(ortc); };
            ortcObj.onSubscribed = function (ortc, channel) { onSubscribed(ortc, channel); };
            ortcObj.onUnsubscribed = function (ortc, channel) { onUnsubscribed(ortc, channel); };
            ortcObj.onException = function (ortc, event) { onException(ortc, event); };
            ortcObj.onReconnecting = function (ortc) { onReconnecting(ortc); };
            ortcObj.onReconnected = function (ortc) { onReconnected(ortc); };
        }
    });
};

function onSubscribed(ortc, channel) {
    log('SUBSCRIBED TO: ' + channel);
};

function onUnsubscribed(ortc, channel) {
    log('UNSUBSCRIBED FROM: ' + channel);
};

function onMessage(ortc, channel, message) {
    switch (channel) {
        case 'ortcClientConnected':
            log('A CLIENT CONNECTED: ' + message);
            break;
        case 'ortcClientDisconnected':
            log('A CLIENT DISCONNECTED: ' + message);
            break;
        case 'ortcClientSubscribed':
            log('A CLIENT SUBSCRIBED: ' + message);
            break;
        case 'ortcClientUnsubscribed':
            log('A CLIENT UNSUBSCRIBED: ' + message);
            break;
        default:
            log('RECEIVED AT ' + channel + ': ' + message);
            break;
    }
};

function onException(ortc, event) {
    log('EXCEPTION: ' + event);
};

function onConnected(ortc) {
    log('CONNECTED TO: ' + ortc.getUrl());
    log('CONNECTION METADATA: ' + ortc.getConnectionMetadata());
    log('SESSION ID: ' + ortc.getSessionId());
    log('USING: ' + ortc.getProtocol());
    log('HEART BEAT DETAILS: ' + " Active - " + ortc.getHeartbeatActive() + " | Time - " + ortc.getHeartbeatTime() + " | Fails - " + ortc.getHeartbeatFails());

};

function onDisconnected(ortc) {
    log('DISCONNECTED');
};

function onReconnecting(ortc) {
    if (document.getElementById(controlsPrefix + 'chkIsCluster').checked == true) {
        log('RECONNECTING TO: ' + ortcObj.getClusterUrl() + '...');
    }
    else {
        log('RECONNECTING TO: ' + ortcObj.getUrl() + '...');
    }
};

function onReconnected(ortc) {
    log('RECONNECTED TO: ' + ortc.getUrl() + ' WITH CONNECTION METADATA: ' + ortc.getConnectionMetadata());
    log('USING: ' + ortc.getProtocol());
};

function Connect() {
    var url = $('#' + controlsPrefix + 'txtUrl').val();

    var heartbeatTime = $('#' + controlsPrefix + 'txtHeartbeatTime').val();
    var heartbeatFails = $('#' + controlsPrefix + 'txtHeartbeatFails').val();
    var heartbeatActive = document.getElementById(controlsPrefix + 'chkHeartbeatActive').checked;

    ortcObj.setConnectionMetadata($('#' + controlsPrefix + 'txtConnMeta').val());
    ortcObj.setAnnouncementSubChannel($('#' + controlsPrefix + 'txtAnnouncementSubChannel').val());

    if (document.getElementById(controlsPrefix + 'chkIsCluster').checked == true) {
        ortcObj.setClusterUrl(url);
    }
    else {
        ortcObj.setUrl(url);
    }

    if (document.getElementById(controlsPrefix + 'chkIsCluster').checked == true) {
        log('CONNECTING TO: ' + ortcObj.getClusterUrl() + '...');
    }
    else {
        log('CONNECTING TO: ' + ortcObj.getUrl() + '...');
    }

    appKey = $('#' + controlsPrefix + 'txtApplicationKey').val();
    authToken = $('#' + controlsPrefix + 'txtAuthToken').val();

    ortcObj.setHeartbeatTime(heartbeatTime);
    ortcObj.setHeartbeatFails(heartbeatFails);
    ortcObj.setHeartbeatActive(heartbeatActive);

    ortcObj.connect(appKey, authToken);
};

function Disconnect() {
    log('DISCONNECTING...');

    ortcObj.disconnect();
};

function Send() {
    var channel = $('#' + controlsPrefix + 'txtChannel').val();
    var message = $('#' + controlsPrefix + 'txtMessage').val();

    log('SEND: ' + message + ' TO ' + channel);

    ortcObj.send(channel, message);
};

function Presence() {
    log('Requesting presence...');

    var channel = $('#' + controlsPrefix + 'txtChannel').val();

    var presenceData = {};

    if (ortcObj.getIsConnected()) {
        presenceData = {
            channel: channel
        };
    } else {
        var appKey = $('#' + controlsPrefix + 'txtApplicationKey').val();
        var authToken = $('#' + controlsPrefix + 'txtAuthToken').val();
        var isCluster = document.getElementById(controlsPrefix + 'chkIsCluster').checked == true;
        var url = $('#' + controlsPrefix + 'txtUrl').val();

        var presenceData = {
            applicationKey: appKey,
            authenticationToken: authToken,
            isCluster: isCluster,
            url: url,
            channel: channel
        };
    }

    ortcObj.presence(presenceData,
    function (error, result) {
        if (error) {
            log('EXCEPTION on presence: ' + error);
        } else {
            if (result) {
                for (var metadata in result.metadata) {
                    log(' ' + metadata + ' : ' + result.metadata[metadata]);
                }

                log('Subscriptions on channel ' + channel + ' : ' + result.subscriptions);
            } else {
                log('Subscriptions on channel ' + channel + ' : ' + 0);
            }
        }
    });
};

function Subscribe() {
    var channel = $('#' + controlsPrefix + 'txtChannel').val();
    
    log('SUBSCRIBING TO: ' + channel + '...');

    ortcObj.subscribe(channel, true, function (ortc, channel, message) { onMessage(ortc, channel, message); });    
};

function Unsubscribe() {
    var channel = $('#' + controlsPrefix + 'txtChannel').val();

    log('UNSUBSCRIBING FROM: ' + channel + '...');

    ortcObj.unsubscribe(channel);
};

function ClearLog() {
    $('#logger').html('');
};

function IsSubscribed() {
    var channel = $('#' + controlsPrefix + 'txtChannelSubscribed').val();
    var result = ortcObj.isSubscribed(channel);

    // NOTE: result can be null
    if (result == true) {
        log('YES');
    }
    else if (result == false) {
        log('NO');
    }
};

log = function (m) {
    var loggerChildren = $('#logger').children();
    var totalLines = loggerChildren.length;

    if (totalLines > 300) {
        $("#logger").children().slice(totalLines - 1).detach();
        $("#logger").children().slice(totalLines - 2).detach();
    }


    var logText = $('#logger').html();
    var now = new Date();

    $('#logger').html('');

    $('#logger').append($('<code>').text(now.format('HH:mm:ss') + ' - ' + m));
    $('#logger').append($('<br>'));
    $('#logger').append(logText);
};
