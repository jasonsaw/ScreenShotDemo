//
//  MYPalette.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/19/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYPalette.h"
#import "MYStroke.h"

@implementation MYPalette
@synthesize isEarse;
@synthesize currentColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        stroks = [[NSMutableArray alloc] init];
        redoStrokes = [[NSMutableArray alloc] init];
        self.currentColor = [UIColor redColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
	for (MYStroke *stroke in stroks) {
		[stroke strokeWithContext:context];
	}
}

- (void)clearStroks {
	[stroks removeAllObjects];
    [redoStrokes removeAllObjects];
	[self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	currentPath = CGPathCreateMutable();
	MYStroke *stroke = [[MYStroke alloc] init];
	stroke.path = currentPath;
	stroke.blendMode = isEarse ? kCGBlendModeDestinationIn : kCGBlendModeNormal;
	stroke.strokeWidth = isEarse ? 10.0 : 5.0;
	stroke.strokeColor = isEarse ? [[UIColor clearColor] CGColor] : [currentColor CGColor];
	[stroks addObject:stroke];
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGPathMoveToPoint(currentPath, NULL, point.x, point.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGPathAddLineToPoint(currentPath, NULL, point.x, point.y);
	[self setNeedsDisplay];
}

- (void)undo
{
    if (stroks.count>0) {
        [redoStrokes addObject:[stroks lastObject]];
        [stroks removeLastObject];
        [self setNeedsDisplay];
    }
}

- (void)redo
{
    if (redoStrokes.count>0) {
        [stroks addObject:[redoStrokes lastObject]];
        [redoStrokes removeLastObject];
        [self setNeedsDisplay];
    }
}


@end
