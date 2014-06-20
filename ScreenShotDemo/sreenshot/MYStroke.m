//
//  MYStroke.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/19/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYStroke.h"

@implementation MYStroke
@synthesize path;
@synthesize blendMode;
@synthesize strokeWidth;
@synthesize strokeColor;

- (void)setPath:(CGMutablePathRef)aPath {
	if (path != aPath) {
		path = aPath;
	}
}

- (void)setStrokeColor:(CGColorRef)aColor {
	if (strokeColor != aColor) {
		strokeColor = aColor;
	}
}

- (void)strokeWithContext:(CGContextRef)context {
	CGContextSetStrokeColorWithColor(context, strokeColor);
	CGContextSetLineWidth(context, strokeWidth);
	CGContextSetBlendMode(context, blendMode);
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineJoin(context,kCGLineJoinRound);
	CGContextBeginPath(context);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
}

@end
