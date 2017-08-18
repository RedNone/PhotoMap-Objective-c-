#import "NVSingletonFireBaseManager.h"
#import "NVPhotoSendModel.h"
#import "NVConst.h"
#import "UIImage+NVConvertImageExtension.h"
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

-(void)uploadData:(NVPhotoModel *)model{
    FIRDatabaseReference *fireBaseInstance = [[FIRDatabase database] referenceWithPath:[NSString stringWithFormat:@"photos/%@",[[[FIRAuth auth] currentUser] uid]]];
    FIRDatabaseQuery *lastquery = [fireBaseInstance queryOrderedByKey];
    
    NVPhotoSendModel *newModel = [NVPhotoSendModel new];
    newModel.photoId = 0;
    newModel.date = model.date;
    newModel.coordinates = model.coordinates;
    newModel.text = model.text;
    UIImage *newImage = [model.photo scaledToSize:CGSizeMake(100, 100)];
    newModel.photo = [newImage encodeToBase64String];
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
     
-(void)downloadData {
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

#pragma mark - Convert Come Data

-(void)convertComeData:(NSMutableArray *)array{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.userData = [[NSMutableArray alloc] initWithCapacity:array.count];
        
        for(NVPhotoSendModel *model in array){
            NVPhotoModel *newModel = [NVPhotoModel new];
            newModel.photoId = model.photoId;
            newModel.date = model.date;
            newModel.coordinates = model.coordinates;
            newModel.text = model.text;
            newModel.type = model.type;
            
            UIImage *image = [UIImage decodeBase64ToImage:model.photo];
            
            NSData *imageData = UIImagePNGRepresentation(image);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",@"cached",newModel.photoId]];
            
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


