//
//  OrtcHandler.swift
//  OrtcClientSwiftExample
//
//  Created by Joao Caixinha on 01/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class OrtcHandler: NSObject, OrtcClientDelegate {
    let APPKEY = "[YOUR_APP_KEY]"
    let TOKEN = "TOKEN"
    let METADATA = "METADATA"
    let URL = "http://ortc-developers.realtime.co/server/2.1/"
    
    var ortc: OrtcClient?
    var onMessage:AnyObject?
    
    func connect()
    {
        self.ortc = OrtcClient.ortcClientWithConfig(self) as? OrtcClient
        self.ortc!.connectionMetadata = METADATA
        self.ortc!.clusterUrl = URL
        
        self.ortc!.connect(APPKEY, authenticationToken: TOKEN)
    }
    
    
    func onConnected(ortc: OrtcClient!) {
        NSLog("CONNECTED")
        
        self.ortc!.subscribe("myChannel", subscribeOnReconnected: true, onMessage: { (ortcClient:OrtcClient!, channel:String!, message:String!) -> Void in
            NSLog("Received message: %@", message)
        })
    }
    
    func onSubscribed(ortc: OrtcClient!, channel: String!) {
        self.ortc?.send(channel, message: "Hello from swift")
    }
    
    func onUnsubscribed(ortc: OrtcClient!, channel: String!) {
        
    }

    
    func onDisconnected(ortc: OrtcClient!) {
        
    }
    
    func onException(ortc: OrtcClient!, error: NSError!) {
        NSLog("%@", error.description)
    }
    
    func onReconnected(ortc: OrtcClient!) {
        
    }
    
    func onReconnecting(ortc: OrtcClient!) {
        
    }
    
}
