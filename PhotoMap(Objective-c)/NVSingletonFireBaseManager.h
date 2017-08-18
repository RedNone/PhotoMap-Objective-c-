//
//  NVSingletonFireBaseManager.h
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 09.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVPhotoModel.h"

@interface NVSingletonFireBaseManager : NSObject

@property(strong, nonatomic) NSMutableArray *userData;

+ (NVSingletonFireBaseManager *)sharedManager;
-(void)uploadData:(NVPhotoModel *)model;
-(void)downloadData;
-(void)updateDataWithModel:(NVPhotoModel *) model;

@end
