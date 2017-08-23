
#import <Foundation/Foundation.h>

@interface NVTimeLineDataController : NSObject

@property(nonatomic,strong) NSMutableArray *arrayForTableView;

- (id)initWithArray:(NSArray *)array;
- (void)findMathesInArrayWithString:(NSString *)someString;
- (void)getFullArray;

@end
