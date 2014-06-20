//
//  MYStroke.h
//  ScreenShotDemo
//
//  Created by mysoft on 6/19/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYStroke : NSObject {
    CGMutablePathRef	path;
	CGBlendMode			blendMode;
	CGFloat		strokeWidth;
	CGColorRef	strokeColor;
}

@property (nonatomic, readwrite)CGMutablePathRef	path;
@property (nonatomic, assign)CGBlendMode			blendMode;
@property (nonatomic, assign)CGFloat		strokeWidth;
@property (nonatomic, readwrite)CGColorRef	strokeColor;

- (void)strokeWithContext:(CGContextRef)context;
@end
