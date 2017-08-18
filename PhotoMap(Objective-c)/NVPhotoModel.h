//
//  NVPhotoModel.h
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 14.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface NVPhotoModel : NSObject <NSCopying>

@property(assign, nonatomic) NSInteger photoId;
@property(strong, nonatomic) NSString *date;
@property(strong, nonatomic) NSString *coordinates;
@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) UIImage *photo;
@property(strong, nonatomic) NSString *photoPath;
@property(assign, nonatomic) NSString *type;

@end
