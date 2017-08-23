//
//  UIView+NVShadowExtension.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 18.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "UIView+NVShadowExtension.h"

@implementation UIView (NVShadowExtension)

- (void)makeShadowWithSize:(CGSize)size andWithShadowOpacity:(CGFloat)opacity{
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = size;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = shadowPath.CGPath;
}

@end
