#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface UIImage (NVConvertImageExtension)
- (UIImage *)scaledToSize:(CGSize)newSize;
- (NSString *)encodeToBase64String;
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
@end
