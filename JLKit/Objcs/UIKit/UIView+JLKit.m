//
//  UIView+JLKit.m
//  JLKit
//
//  Created by Jangsy7883 on 2015. 10. 4..
//  Copyright © 2015년 Dalkomm. All rights reserved.
//

#import "UIView+JLKit.h"

@implementation UIView (Additions)

#pragma mark - GETTERS

- (UIViewController*)superViewController {
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (UIImage*)screenShot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size,NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img_screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img_screenShot;
}

#pragma mark - SETTERS

- (void)setTransformScale:(CGFloat)scale {
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
}

- (void)setCornerRadius:(CGFloat)parm_cornerRadius {
    self.layer.cornerRadius = parm_cornerRadius;
    
    if (parm_cornerRadius > 0) {
        self.clipsToBounds = YES;
    }
}

@end
