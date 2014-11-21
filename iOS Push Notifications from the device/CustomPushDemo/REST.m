//
//  REST.m
//  Realtime Secure Chat
//
//  Created by Joao Caixinha on 26/05/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

#import "REST.h"


#define TIMEOUT 10

@implementation REST


- (id)initWithData:(NSDictionary*)dictionary forURL:(NSString*)url withMethod:(NSString*)metod andDelegate:(id)delegate{
    self = [super init];
    if (self) {
        dataDictionary = dictionary;
        restRoute = url;
        _delegate = delegate;
        // Create the request.
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT];

        if (dictionary != nil) {
            [[self class] jsonStringFromDictionary:dictionary OnCompletion:^(NSString *jsonString, NSError *error) {
                NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                //data = [GlobalData encodeDictionary:dictionary];
                [request setHTTPMethod:metod];
                [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];                
                
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:data];
            }];
        }
        
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
        }
    return self;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *response = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    @try {
        [[self class] jsonDictionaryFromString:response OnCompletion:^(NSDictionary *jsonDictionary, NSError *error) {
            
            if ([jsonDictionary objectForKey:@"errorId"]) {
                [_delegate didReciveHTTPsError:jsonDictionary];
            }else
            {
                [_delegate didReciveHTTPsData:jsonDictionary];
            }            
        }];
    }
    @catch (NSException *exception) {
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSDictionary *jsonDictionary = @{@"errorId": [NSString stringWithFormat:@"%ld", (long)error.code], @"errorMsg": [error.userInfo valueForKey:@"NSLocalizedDescription"]};
    [_delegate didReciveHTTPsError:jsonDictionary];
}

+ (void) jsonDictionaryFromString:(NSString*) text OnCompletion:(void (^)(NSDictionary* jsonDict, NSError* error)) callback {
    
    NSError *error = nil;
    NSData *jsonData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if(error){
        if (callback) {
            callback(nil,error);
        }
    }
    else {
        if (callback) {
            callback(json,nil);
        }
    }
}

+ (void) jsonStringFromDictionary:(NSDictionary*) dict OnCompletion:(void (^)(NSString* jsonString, NSError* error)) callback {
    
    NSError *error;
    NSString *jString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!jsonData) {
        if (callback) {
            callback(nil, error);
        }
        
    } else {
        jString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (callback) {
            callback(jString, nil);
        }
    }
}


@end
