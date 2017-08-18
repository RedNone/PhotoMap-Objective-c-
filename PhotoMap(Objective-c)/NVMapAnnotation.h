//
//  NVMapAnnotation.h
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 17.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MKAnnotation.h"

@interface NVMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic,assign) NSInteger photoId;
@property (nonatomic,strong) NSString *photoPath;
@property (nonatomic,strong) NSString *type;
@end
