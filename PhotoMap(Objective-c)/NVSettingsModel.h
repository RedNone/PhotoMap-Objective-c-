//
//  NVSettingsModel.h
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 15.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NVSettingsModel : NSObject

@property(assign,nonatomic) NSInteger idOfSetting;
@property(strong,nonatomic) NSString *nameOfSetting;
@property(strong,nonatomic) NSString *colorOfSetting;


@end
