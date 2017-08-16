//
//  NVSingletonFireBaseManager.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 09.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "NVSingletonFireBaseManager.h"
#import "NVPhotoSendModel.h"
#import "NVConst.h"
@import FirebaseAuth;
@import FirebaseDatabase;

@implementation NVSingletonFireBaseManager

+ (NVSingletonFireBaseManager*)sharedManager {
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

#pragma mark - FireBase Data

-(void) uploadData:(NVPhotoModel*)model{
    FIRDatabaseReference *fireBaseInstance = [[FIRDatabase database] referenceWithPath:[NSString stringWithFormat:@"photos/%@",[[[FIRAuth auth] currentUser] uid]]];
    FIRDatabaseQuery *lastquery = [fireBaseInstance queryOrderedByKey];
    
    NVPhotoSendModel *newModel = [NVPhotoSendModel new];
    newModel.photoId = 0;
    newModel.date = model.date;
    newModel.coordinates = model.coordinates;
    newModel.text = model.text;
    UIImage *newImage = [self imageWithImage:model.photo scaledToSize:CGSizeMake(100, 100)];
    newModel.photo = [self encodeToBase64String:newImage];
    newModel.type = model.type;

    
    [lastquery observeSingleEventOfType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *dictionary = [snapshot value];
        if(!dictionary){
            [[fireBaseInstance child:@"0"] setValue:@{
                                                      @"id":@(newModel.photoId),
                                                      @"date":newModel.date,
                                                      @"coordinates":newModel.coordinates,
                                                      @"text":newModel.text,
                                                      @"photo":newModel.photo,
                                                      @"type":newModel.type
                                                      }];
        } else{
            NSString *child = [NSString stringWithFormat:@"%lu",(unsigned long)snapshot.childrenCount];
            [[fireBaseInstance child:child] setValue:@{ @"id":@(snapshot.childrenCount),
                                                        @"date":newModel.date,
                                                        @"coordinates":newModel.coordinates,
                                                        @"text":newModel.text,
                                                        @"photo":newModel.photo,
                                                        @"type":newModel.type
                                                        }];
        }
    }];
}
     
-(void) downloadData {
    FIRDatabaseReference *fireBaseInstance = [[FIRDatabase database] referenceWithPath:[NSString stringWithFormat:@"photos/%@",[[[FIRAuth auth] currentUser] uid]]];
    FIRDatabaseQuery *lastquery = [fireBaseInstance queryOrderedByKey];
    
    [lastquery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot){
            
            NSMutableArray *comeData = [NSMutableArray arrayWithCapacity:snapshot.childrenCount];
        
            for(int i = 0; i < snapshot.childrenCount; i++){
                FIRDataSnapshot *childSnapshot = [snapshot childSnapshotForPath:[NSString stringWithFormat:@"%d",i]];
                NSDictionary *dictionary = [childSnapshot value];
                
                NVPhotoSendModel *model = [NVPhotoSendModel new];
                
                model.photoId = [[dictionary valueForKey:@"id"] intValue];
                model.date = [dictionary valueForKey:@"date"];
                model.coordinates = [dictionary valueForKey:@"coordinates"];
                model.text = [dictionary valueForKey:@"text"];
                model.photo = [dictionary valueForKey:@"photo"];
                model.type = [dictionary valueForKey:@"type"];
                
                [comeData addObject:model];
            }
            [self convertComeData:comeData];
        }
    }];
    
}



#pragma mark - Convert Image

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark - Convert Come Data

-(void) convertComeData:(NSMutableArray*) array{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for(NVPhotoSendModel *model in array){
            NVPhotoModel *newModel = [NVPhotoModel new];
            newModel.photoId = model.photoId;
            newModel.date = model.date;
            newModel.coordinates = model.coordinates;
            newModel.text = model.text;
            newModel.type = model.type;
            
            UIImage *image = [self decodeBase64ToImage:model.photo];
            
            NSData *imageData = UIImagePNGRepresentation(image);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
            
            if (![imageData writeToFile:imagePath atomically:NO]){
                NSLog(@"Failed to cache image data to disk");
            } else {
                NSLog(@"the cachedImagedPath is %@",imagePath); 
            }
            
            newModel.photoPath = imagePath;
            [self.userData addObject:newModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:FirebaseManagerDataComeNotification object:nil];
      });
    });
}

@end


