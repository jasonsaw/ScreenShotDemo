//
//  MYDrawCell.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/26/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYDrawCell.h"

@implementation MYDrawCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect drawRect = CGRectMake(self.currentSize/2, self.currentSize/2, rect.size.width-self.currentSize, rect.size.height-self.currentSize);
    UIBezierPath *path ;
    switch (self.drawShapeType) {
        case Ellipse:
            //
            path = [UIBezierPath bezierPathWithOvalInRect:drawRect];
            break;
        case CircularRectAngle:
            //
            path = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:10];
            break;
        case RectAngle:
            //
            path = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:.5];
            break;
        default:
            break;
    }
    path.lineWidth = self.currentSize;
    [self.currentColor set];
    [path stroke];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesEnded:touches withEvent:event];
}
@end
