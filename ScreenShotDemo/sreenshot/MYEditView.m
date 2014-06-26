//
//  MYEditView.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/26/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYEditView.h"

@interface MYEditView()

@property (nonatomic,strong) NSMutableArray *arrayStrokes;//保存画笔
@property (nonatomic,strong) NSMutableArray *arrayCellView;//保存绘图的每个子view
@end

@implementation MYEditView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrayStrokes = [[NSMutableArray alloc] init];
        self.arrayCellView = [[NSMutableArray alloc] init];
        self.currentSize = 3;
        self.currentColor = [UIColor redColor];
        self.drawShapeType = Ellipse;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    //绘制图片
    if (self.arrayStrokes)
    {
        for (NSDictionary *dictStroke in self.arrayStrokes)
        {
            NSInteger tag = [[dictStroke objectForKey:@"viewtag"] integerValue];
            MYDrawCell *shapeCellView = [self isExistViewWithTag:tag];
            if (!shapeCellView) {
                shapeCellView = [[MYDrawCell alloc] init];
                shapeCellView.tag = tag;
//                [self addDeleteButton:shapeCellView];
                [self addSubview:shapeCellView];
                [self.arrayCellView addObject:shapeCellView];
            }
            UIColor *color = [dictStroke objectForKey:@"color"];
            float size = [[dictStroke objectForKey:@"size"] floatValue];
            DrawShape shapeType = (DrawShape)[[dictStroke objectForKey:@"shapeType"] floatValue];
            shapeCellView.currentColor = color;
            shapeCellView.currentSize = size;
            shapeCellView.drawShapeType = shapeType;
            NSArray *arrayPointsInstroke = [dictStroke objectForKey:@"points"];
            CGPoint pointStart = CGPointFromString([arrayPointsInstroke objectAtIndex:0]);
            shapeCellView.frame = CGRectMake(pointStart.x, pointStart.y, 0, 0);
            
            for (int i = 0; i < (arrayPointsInstroke.count - 1); i++)
            {
                CGPoint pointNext = CGPointFromString([arrayPointsInstroke objectAtIndex:i+1]);
                shapeCellView.frame = CGRectMake(pointStart.x, pointStart.y, pointNext.x-pointStart.x, pointNext.y - pointStart.y);
                [shapeCellView setNeedsDisplay];
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
    
    NSInteger maxTag= [self fetchMaxTag] + 1;
    [dictStroke setObject:[NSNumber numberWithInteger:maxTag] forKey:@"viewtag"];
    [dictStroke setObject:arrayPointsInStroke forKey:@"points"];
    [dictStroke setObject:[NSNumber numberWithInt:self.drawShapeType] forKey:@"shapeType"];
    [dictStroke setObject:self.currentColor forKey:@"color"];
    [dictStroke setObject:[NSNumber numberWithFloat:self.currentSize] forKey:@"size"];
    
    [self.arrayStrokes addObject:dictStroke];//添加的是一个字典：点数组，颜色，粗细
}

// Add each point to points array
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"point = %@",NSStringFromCGPoint(point));
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self];
    NSMutableArray *arrayPointsInStroke = [[self.arrayStrokes lastObject] objectForKey:@"points"];
    [arrayPointsInStroke addObject:NSStringFromCGPoint(point)];
    
    
    CGRect rectToRedraw = CGRectMake(\
                                     ((prevPoint.x>point.x)?point.x:prevPoint.x)-self.currentSize,\
                                     ((prevPoint.y>point.y)?point.y:prevPoint.y)-self.currentSize,\
                                     fabs(point.x-prevPoint.x)+2*self.currentSize,\
                                     fabs(point.y-prevPoint.y)+2*self.currentSize\
                                     );
    [self setNeedsDisplayInRect:rectToRedraw];
}

- (void)addGestureWithView:(UIView*)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeToEditState:)];
    [view addGestureRecognizer:tap];
}

- (void)changeToEditState:(UITapGestureRecognizer *)sender
{
    MYDrawCell *view = (MYDrawCell*)sender.view;
}

- (void)addDeleteButton:(MYDrawCell*)cellView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    float width = 20;
    button.frame = CGRectMake(cellView.frame.origin.x+cellView.frame.size.width-width, cellView.frame.origin.y-width/2, width, width);
    button.backgroundColor = [UIColor clearColor];
    button.tag = cellView.tag;
    [button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteCellView:) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:button];
}

- (void)deleteCellView:(UIButton*)button
{
    NSInteger tag = button.tag;
    [self deleteCellViewFromArrayWithTag:tag];
}

- (void)deleteCellViewFromArrayWithTag:(NSInteger)tag
{
    for (int i=0;i<self.arrayCellView.count;i++) {
        MYDrawCell *cellView = [self.arrayCellView objectAtIndex:i];
        if (tag == cellView.tag) {
            [cellView removeFromSuperview];
            [self.arrayCellView removeObject:cellView];
            break;
        }
    }
}

- (MYDrawCell*)isExistViewWithTag:(NSInteger)tag
{
    for (MYDrawCell *cellView in self.arrayCellView) {
        if (cellView.tag == tag) {
            return cellView;
        }
    }
    return nil;
}

- (NSInteger)fetchMaxTag
{
    if (self.arrayCellView.count>0) {
        UIView *cellView = [self.arrayCellView objectAtIndex:0];
        NSInteger maxTag = cellView.tag;
        for (int i=1;i<self.arrayCellView.count;i++) {
            UIView *cell = [self.arrayCellView objectAtIndex:i];
            maxTag = maxTag>cell.tag?maxTag:cell.tag;
        }
        return maxTag;
    }
    return 1;
}

@end
