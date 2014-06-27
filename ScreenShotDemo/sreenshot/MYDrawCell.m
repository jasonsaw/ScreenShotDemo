//
//  MYDrawCell.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/26/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYDrawCell.h"

#define DeleteButtonWidth 20
@implementation MYDrawCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self layoutDeleteButton];
    }
    return self;
}

- (void)layoutDeleteButton
{
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect xPositive = CGRectMake(self.frame.origin.x-DeleteButtonWidth/2, self.frame.origin.y-DeleteButtonWidth/2, DeleteButtonWidth, DeleteButtonWidth);
    self.deleteButton.frame = xPositive;
    self.deleteButton.backgroundColor = [UIColor clearColor];
    self.deleteButton.userInteractionEnabled = YES;
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteCellView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
}

- (void)deleteCellView:(id)sender
{
    if (self.celldelegate && [self.celldelegate respondsToSelector:@selector(removeCellView:)]) {
        [self.celldelegate removeCellView:self.deleteButton.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect xPositive = CGRectMake(rect.origin.x, rect.size.height/2-DeleteButtonWidth/2, DeleteButtonWidth, DeleteButtonWidth);
    NSLog(@"origin.x = [%f]",self.frame.origin.x);
    if (self.frame.origin.x<0) {
        xPositive = CGRectMake(rect.origin.x + rect.size.width - DeleteButtonWidth, rect.size.height/2-DeleteButtonWidth/2, DeleteButtonWidth, DeleteButtonWidth);
    }
    self.deleteButton.frame = xPositive;
    self.deleteButton.tag = self.tag;
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
    NSLog(@"touchesBegan");
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved");
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    [self.nextResponder touchesEnded:touches withEvent:event];
}

//- (UIView *)pointInSide:(CGPoint)point withEvent:(UIEvent *)event
//{
//    
//}
@end
