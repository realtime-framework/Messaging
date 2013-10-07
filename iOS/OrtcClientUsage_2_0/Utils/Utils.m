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
    NSDate* now = [NSDate date];  // now: 2011-02-28 09:57:49 +0000
    NSString* strDate = [[NSString alloc] initWithFormat:@"%@", now];
    NSArray* arr = [strDate componentsSeparatedByString:@" "];
    
    return [arr objectAtIndex:1];
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
