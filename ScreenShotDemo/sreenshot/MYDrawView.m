//
//  MYDrawView.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/18/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYDrawView.h"

@interface MYDrawView()

@property (nonatomic,strong) NSMutableArray *arrayStrokes;//保存画笔
@property (nonatomic,strong) NSMutableArray *arrayAbandonedStrokes;//保存废弃后的画笔

@end

@implementation MYDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrayStrokes = [[NSMutableArray alloc] init];
        self.arrayAbandonedStrokes = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.iseasre = false;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //绘制图片
//    int width = self.pickedImage.size.width;
//    int height = self.pickedImage.size.height;
//    CGRect rectForImage = CGRectMake(0,0, width, height);
//    [self.pickedImage drawInRect:rectForImage];
    
    if (self.arrayStrokes)
    {
        for (NSDictionary *dictStroke in self.arrayStrokes)
        {
            NSArray *arrayPointsInstroke = [dictStroke objectForKey:@"points"];
            float size = [[dictStroke objectForKey:@"size"] floatValue];
            UIBezierPath* pathLines = [UIBezierPath bezierPath];
            CGPoint pointStart = CGPointFromString([arrayPointsInstroke objectAtIndex:0]);
            [pathLines removeAllPoints];
            [pathLines moveToPoint:pointStart];
            for (int i = 0; i < (arrayPointsInstroke.count - 1); i++)
            {
                CGPoint pointNext = CGPointFromString([arrayPointsInstroke objectAtIndex:i+1]);
                [pathLines addLineToPoint:pointNext];
            }
            pathLines.lineWidth = size;
            pathLines.lineJoinStyle = kCGLineJoinRound; //拐角的处理
            pathLines.lineCapStyle = kCGLineCapRound; //最后点的处理
            UIColor *color = [dictStroke objectForKey:@"color"];
            BOOL easre = [[dictStroke objectForKey:@"iseasre"] boolValue];
            if (easre) {
                pathLines.lineWidth = size*2;
                [pathLines strokeWithBlendMode:kCGBlendModeClear alpha:0];
            } else {
                [color set];
                [pathLines stroke];
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSMutableArray *arrayPointsInStroke = [NSMutableArray array]; //点数组，相当于一个笔画
    
    NSMutableDictionary *dictStroke = [NSMutableDictionary dictionary];
    CGPoint point = [[touches anyObject] locationInView:self];
    [arrayPointsInStroke addObject:NSStringFromCGPoint(point)];
    
    [dictStroke setObject:arrayPointsInStroke forKey:@"points"];
    [dictStroke setObject:self.currentColor forKey:@"color"];
    [dictStroke setObject:[NSNumber numberWithFloat:self.currentSize] forKey:@"size"];
    if (self.iseasre) {
        [dictStroke setObject:[NSNumber numberWithBool:YES] forKey:@"iseasre"];
    } else {
        [dictStroke setObject:[NSNumber numberWithBool:NO] forKey:@"iseasre"];
    }
    
    [self.arrayStrokes addObject:dictStroke];//添加的是一个字典：点数组，颜色，粗细
}

// Add each point to points array
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self];
    
    NSMutableArray *arrayPointsInStroke = [[self.arrayStrokes lastObject] objectForKey:@"points"];
    [arrayPointsInStroke addObject:NSStringFromCGPoint(point)];
    
//    CGRect rectToRedraw = CGRectMake(\
//                                     ((prevPoint.x>point.x)?point.x:prevPoint.x)-self.currentSize,\
//                                     ((prevPoint.y>point.y)?point.y:prevPoint.y)-self.currentSize,\
//                                     fabs(point.x-prevPoint.x)+2*self.currentSize,\
//                                     fabs(point.y-prevPoint.y)+2*self.currentSize\
//                                     );
    //Marks the specified rectangle of the receiver as needing to be redrawn.
    //在指定的rect范围进行重绘
    [self setNeedsDisplay];
//    [self setNeedsDisplayInRect:rectToRedraw];
}

//撤销
- (void)undo {
    if ([self.arrayStrokes count]>0) {
        NSMutableDictionary* dictAbandonedStroke = [self.arrayStrokes lastObject];
        [self.arrayAbandonedStrokes addObject:dictAbandonedStroke];
        [self.arrayStrokes removeLastObject];
        [self setNeedsDisplay];
    }
}
//回撤
- (void)redo {
    if ([self.arrayAbandonedStrokes count]>0) {
        NSMutableDictionary* dictReusedStroke = [self.arrayAbandonedStrokes lastObject];
        [self.arrayStrokes addObject:dictReusedStroke];
        [self.arrayAbandonedStrokes removeLastObject];
        [self setNeedsDisplay];
    }
}
//清除画布
- (void)clearCanvas {
    self.pickedImage = nil;
    [self.arrayStrokes removeAllObjects];
    [self.arrayAbandonedStrokes removeAllObjects];
    [self setNeedsDisplay];
}

@end
