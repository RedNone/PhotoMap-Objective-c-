//
//  NVTimeLineDataModel.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 21.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "NVTimeLineDataModel.h"

@implementation NVTimeLineDataModel
- (id)init{
    self = [super init];
    if (self) {
        self.model = [NVPhotoModel new];
    }
    return self;
}
@end
