//
//  JLKitDefine.h
//  JLKit
//
//  Created by  jangsy on 2016. 11. 27..
//  Copyright © 2016년 Dalkomm. All rights reserved.
//

//VALUE

#define IsValid(value) (value != nil && IsNSNull(value) == NO && ([value isKindOfClass:[NSString class]] && [(NSString*)value length] == 0) == NO)
#define IsNSNull(value) [value isKindOfClass:[NSNull class]]

#define ValidValue(value,default) IsValid(value) ? value : default

//CGFLOAT
#define CGFLOAT_PIXEL_SCALE (1/[UIScreen mainScreen].scale)
#define CGFLOAT_PIXEL(value) CGFLOAT_PIXEL_SCALE*value

//Math
#define ROUNDING(x, dig) (floor((x) * pow(10.0, dig) + 0.5f) / pow(10.0, dig))

