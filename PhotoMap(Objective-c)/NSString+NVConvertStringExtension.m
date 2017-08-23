//
//  NSString+NVConvertStringExtension.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 21.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "NSString+NVConvertStringExtension.h"

@implementation NSString (NVConvertStringExtension)

- (NSString *)convertTimeFormatWithOldFormat:(NSString *)oldFormat andWithNewFormat:(NSString *)newFormat{
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:oldFormat];
    
    NSDate *date = [dateFormat dateFromString:self];
    
    NSDateFormatter *newDateFormat = [NSDateFormatter new];
    [newDateFormat setDateFormat:newFormat];
    
    return [newDateFormat stringFromDate:date] ;
}

@end
