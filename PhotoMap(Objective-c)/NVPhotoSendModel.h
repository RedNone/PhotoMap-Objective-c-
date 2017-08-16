//
//  NVPhotoSendModel.h
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 15.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NVPhotoSendModel : NSObject

@property(assign, nonatomic) NSInteger photoId;
@property(strong, nonatomic) NSString *date;
@property(strong, nonatomic) NSString *coordinates;
@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) NSString *photo;
@property(assign, nonatomic) NSString *type;

@end
