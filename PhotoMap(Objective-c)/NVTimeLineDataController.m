
#import "NVTimeLineDataController.h"
#import "NVPhotoModel.h"
#import "NVTimeLineDataModel.h"
#import "NSString+NVConvertStringExtension.h"
#import "NVConst.h"

@interface NVTimeLineDataController()
@property(nonatomic,strong) NSMutableArray *oldArray;
@property(nonatomic,strong) NSMutableArray *arrayOfObjectsForTableView;
@end
@implementation NVTimeLineDataController

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        self.oldArray = (NSMutableArray*)[array mutableCopy];
        [self sortArrayForDate];
        [self convertDataForTableViewWithArray:self.oldArray];
     }
    return self;
}

- (void)sortArrayForDate{
    [self.oldArray sortUsingComparator:^NSComparisonResult(NVPhotoModel *obj1,NVPhotoModel *obj2) {
        double obj1Date = [self getTimeWith:obj1.date];
        double obj2Date = [self getTimeWith:obj2.date];
        
        return obj1Date > obj2Date ? 0 : 1;
    }];
    
}

- (double)getTimeWith:(NSString *)dateString{
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"MMMM dd'th',yyyy - hh:mm a"];
    
    NSDate *date = [dateFormat dateFromString:dateString];
    
    return [date timeIntervalSince1970];
}

- (void)findMathesInArrayWithString:(NSString *)someString{
    NSMutableArray *newArray =( NSMutableArray*)[self.oldArray mutableCopy];
    for(int i = 0; i < newArray.count; i++){
        NVPhotoModel *model = [newArray objectAtIndex:i];
        if ([model.text rangeOfString:someString].location == NSNotFound) {
            [newArray removeObjectAtIndex:i];
            i--;
        }
    }
    [self convertDataForTableViewWithArray:newArray];
}

- (void)getFullArray{
    [self convertDataForTableViewWithArray:self.oldArray];
}

- (void)convertDataForTableViewWithArray:(NSArray *)oldArray{
    
    self.arrayOfObjectsForTableView = [NSMutableArray new];
    self.arrayForTableView = [NSMutableArray new];
    
    for(NVPhotoModel *oldModel in oldArray){
        [self.arrayOfObjectsForTableView addObject:[self convertObject:oldModel]];
    }
    
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    
    bool settingsStatusNature = [userSettings boolForKey:TypeOfPhotoNature];
    bool settingsStatusFriends = [userSettings boolForKey:TypeOfPhotoFriends];
    bool settingsStatusDefault = [userSettings boolForKey:TypeOfPhotoDefault];
    
    for(int i = 0; i < self.arrayOfObjectsForTableView.count; i++){
        NVTimeLineDataModel *model = [self.arrayOfObjectsForTableView objectAtIndex:i];
        NSString *typeOfPhoto = model.model.type;
        if([typeOfPhoto isEqualToString:[TypeOfPhotoNature uppercaseString]]){
            if(!settingsStatusNature){
                [self.arrayOfObjectsForTableView removeObjectAtIndex:i];
                i--;
            }
        }
        if([typeOfPhoto isEqualToString:[TypeOfPhotoFriends uppercaseString]]){
            if(!settingsStatusFriends){
                [self.arrayOfObjectsForTableView removeObjectAtIndex:i];
                i--;
            }
        }
        if([typeOfPhoto isEqualToString:[TypeOfPhotoDefault uppercaseString]]){
            if(!settingsStatusDefault){
                [self.arrayOfObjectsForTableView removeObjectAtIndex:i];
                i--;
            }
        }
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for(int i = 0; i < [self.arrayOfObjectsForTableView count]; i++){
        NVTimeLineDataModel *model = [self.arrayOfObjectsForTableView objectAtIndex:i];
        model.titleOfSection = [model.model.date convertTimeFormatWithOldFormat:@"MM-dd-yyyy"
                                                               andWithNewFormat:@"MMMM yyyy"];
        [array addObject:model];
        
        if((i+1) == [self.arrayOfObjectsForTableView count]){
            [self.arrayForTableView addObject:array];
            break;
        }
        NSString *firstObjectDate = [model.model.date convertTimeFormatWithOldFormat:@"MM-dd-yyyy"
                                                                    andWithNewFormat:@"MM"];
        NVTimeLineDataModel *secondModel = [self.arrayOfObjectsForTableView objectAtIndex:i+1];
        
        NSString *secondObjectDate = [secondModel.model.date convertTimeFormatWithOldFormat:@"MM-dd-yyyy"
                                                                           andWithNewFormat:@"MM"];
        if(![firstObjectDate isEqualToString:secondObjectDate]){
            [self.arrayForTableView addObject:array];
            array = [NSMutableArray new];
        }
        
    }
}

- (NVTimeLineDataModel *)convertObject:(NVPhotoModel *)oldModel{
    NVTimeLineDataModel *dataModel = [NVTimeLineDataModel new];
    dataModel.model.photoId = oldModel.photoId;
    dataModel.model.date = [oldModel.date convertTimeFormatWithOldFormat:@"MMMM dd'th',yyyy - hh:mm a"
                                                        andWithNewFormat:@"MM-dd-yyyy"];
    dataModel.model.coordinates = oldModel.coordinates;
    
    dataModel.model.photoPath = oldModel.photoPath;
    dataModel.model.type = [oldModel.type uppercaseString];
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#([A-Za-z0-9_-]+)" options:0 error:&error];
    NSMutableString *string = [NSMutableString stringWithString:oldModel.text];
    [regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [oldModel.text length]) withTemplate:@""];
    
    dataModel.model.text = string;
    
    return dataModel;
}

@end
