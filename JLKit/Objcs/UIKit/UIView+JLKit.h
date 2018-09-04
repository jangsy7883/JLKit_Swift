//
//  UIView+JLKit.h
//  JLKit
//
//  Created by Jangsy7883 on 2015. 10. 4..
//  Copyright © 2015년 Dalkomm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIViewAutoresizingFlexibleSize UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
#define UIViewAutoresizingFlexibleAllMargin UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin

@interface UIView (Additions)

@property (nonatomic, readonly) UIViewController *superViewController;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, readonly) UIImage* screenShot;

- (void)setTransformScale:(CGFloat)scale;

@end
