//
//  NVSingletonFireBaseManager.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 09.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "NVSingletonFireBaseManager.h"

@implementation NVSingletonFireBaseManager

+ (id)sharedManager {
    static NVSingletonFireBaseManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}
    
@end


