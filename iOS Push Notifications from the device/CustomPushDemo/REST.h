//
//  REST.h
//  Realtime Secure Chat
//
//  Created by Joao Caixinha on 26/05/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RESTProtocol <NSObject>
@required
- (void)didReciveHTTPsData:(NSDictionary*)data;
- (void)didReciveHTTPsError:(NSDictionary*)data;
@end

@interface REST : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    @private
    NSURLConnection *connection;
    NSString *restRoute;
    NSDictionary *dataDictionary;
}


#pragma mark Models
@property(retain, nonatomic)id<RESTProtocol> delegate;
@property(retain, nonatomic)NSMutableData *responseData;

#pragma mark Public methods
- (id)initWithData:(NSDictionary*)dictionary forURL:(NSString*)url withMethod:(NSString*)metod andDelegate:(id)delegate;
+ (void) jsonDictionaryFromString:(NSString*) text OnCompletion:(void (^)(NSDictionary* jsonDict, NSError* error)) callback;
+ (void) jsonStringFromDictionary:(NSDictionary*) dict OnCompletion:(void (^)(NSString* jsonString, NSError* error)) callback;

@end
