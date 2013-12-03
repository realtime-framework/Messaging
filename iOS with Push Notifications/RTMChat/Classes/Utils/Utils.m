//
//  Utils.m
//  OrtcClientUsage_2_0
//
//  Created by Rafael Cabral on 5/18/12.
//  Copyright (c) 2012 IBT. All rights reserved.
//

#import "Utils.h"

@implementation Utils

- (NSString*)getHour
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *dateString = [dateFormat stringFromDate:now];
    
    return dateString;
}

#pragma mark Lifecycle

+ (id)ibtRealTimeSJWithConfig
{
    return [[self class] alloc];
}

- (id)initWithConfig
{
    self = [super init];
    
    if (self) {
        // Do comething
    }
    
    return self;
}

@end
