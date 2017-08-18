//
//  NVPhotoModel.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 14.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "NVPhotoModel.h"

@implementation NVPhotoModel

- (id)copyWithZone:(NSZone *)zone{
    NVPhotoModel *model = [NVPhotoModel new];
    model.photoId = self.photoId;
    model.text = self.text;
    model.type = self.type;
    model.date = self.date;
    model.photo = self.photo;
    model.photoPath = self.photoPath;
    model.coordinates = self.coordinates;
    return model;
}

@end
