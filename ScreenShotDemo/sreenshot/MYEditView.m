//
//  MYEditView.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/26/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYEditView.h"

@interface MYEditView()
{
    MYDrawCell *textCellView;
}

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

- (void)setDrawType:(DrawType)drawType
{
    _drawType = drawType;
    if (_drawType == DrawFont) {
        if (!textCellView) {
            textCellView = [[MYDrawCell alloc] initWithFrame:CGRectMake(100, 200, 100, 35)];
            textCellView.backgroundColor = [UIColor clearColor];
            textCellView.drawTextFont = self.drawTextFont;
            textCellView.drawMarkOrOther = DrawFont;
            textCellView.tag = [self fetchMaxTag];
            textCellView.celldelegate = self;
            
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
            [textCellView addGestureRecognizer:panGesture];
            [self addSubview:textCellView];
            [self.arrayCellView addObject:textCellView];
        }
    }
}

-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
    CGPoint curPoint = [gestureRecognizer locationInView:self];
    [textCellView setCenter:curPoint];
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
                shapeCellView.drawMarkOrOther = DrawMark;
                shapeCellView.celldelegate = self;
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
            if (textCellView) {
                [self bringSubviewToFront:textCellView];
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan editView");
    [self endEditing:YES];

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
    
    [dictStroke setObject:[NSNumber numberWithFloat:point.x] forKey:@"xMin"];
    [dictStroke setObject:[NSNumber numberWithFloat:point.x] forKey:@"xMax"];
    [dictStroke setObject:[NSNumber numberWithFloat:point.y] forKey:@"yMin"];
    [dictStroke setObject:[NSNumber numberWithFloat:point.y] forKey:@"yMax"];
    
    [self.arrayStrokes addObject:dictStroke];//添加的是一个字典：点数组，颜色，粗细
}

// Add each point to points array
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self];
    NSMutableArray *arrayPointsInStroke = [[self.arrayStrokes lastObject] objectForKey:@"points"];
    [arrayPointsInStroke addObject:NSStringFromCGPoint(point)];
    
    float xMin = point.x>[[[self.arrayStrokes lastObject] objectForKey:@"xMin"] floatValue]?[[[self.arrayStrokes lastObject] objectForKey:@"xMin"] floatValue]:point.x;
    float xMax = point.x>[[[self.arrayStrokes lastObject] objectForKey:@"xMax"] floatValue]?point.x:[[[self.arrayStrokes lastObject] objectForKey:@"xMax"] floatValue];
    float yMin = point.y>[[[self.arrayStrokes lastObject] objectForKey:@"yMin"] floatValue]?[[[self.arrayStrokes lastObject] objectForKey:@"yMin"] floatValue]:point.y;
    float yMax = point.y>[[[self.arrayStrokes lastObject] objectForKey:@"yMax"] floatValue]?point.y:[[[self.arrayStrokes lastObject] objectForKey:@"yMax"] floatValue];
    
    [[self.arrayStrokes lastObject] setObject:[NSNumber numberWithFloat:xMin] forKey:@"xMin"];
    [[self.arrayStrokes lastObject] setObject:[NSNumber numberWithFloat:xMax] forKey:@"xMax"];
    [[self.arrayStrokes lastObject] setObject:[NSNumber numberWithFloat:yMin] forKey:@"yMin"];
    [[self.arrayStrokes lastObject] setObject:[NSNumber numberWithFloat:yMax] forKey:@"yMax"];
    
    CGRect rectToRedraw = CGRectMake(\
                                     ((prevPoint.x>point.x)?point.x:prevPoint.x)-self.currentSize,\
                                     ((prevPoint.y>point.y)?point.y:prevPoint.y)-self.currentSize,\
                                     fabs(point.x-prevPoint.x)+2*self.currentSize,\
                                     fabs(point.y-prevPoint.y)+2*self.currentSize\
                                     );
    [self setNeedsDisplayInRect:rectToRedraw];
    NSLog(@"touchesMoved editView");
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded editView");
    if ([self isOnlyOnePoint]) {
        [self.arrayStrokes removeLastObject];
    } else if ([self isDrawEreaLessThanDeleteButton]) {
        [self removeLastCellView];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled editView");
    if ([self isOnlyOnePoint]) {
        [self.arrayStrokes removeLastObject];
    } else if ([self isDrawEreaLessThanDeleteButton]) {
        [self removeLastCellView];
    }
}

- (BOOL)isOnlyOnePoint
{
    if (self.arrayStrokes.count>0) {
        NSMutableArray *arrayPointsInStroke = [[self.arrayStrokes lastObject] objectForKey:@"points"];
        if (arrayPointsInStroke.count==1) {//触碰了屏幕，点击了一下，此时应该不去绘图。
            return TRUE;
        }
    }
    return false;
}

//若绘图区域比删除按钮都还小，移除此绘图。
- (BOOL)isDrawEreaLessThanDeleteButton
{
    if (self.arrayStrokes.count>0) {
        float xMin = [[[self.arrayStrokes lastObject] objectForKey:@"xMin"] floatValue];
        float xMax = [[[self.arrayStrokes lastObject] objectForKey:@"xMax"] floatValue];
        float yMin = [[[self.arrayStrokes lastObject] objectForKey:@"yMin"] floatValue];
        float yMax = [[[self.arrayStrokes lastObject] objectForKey:@"yMax"] floatValue];
        
        float width = xMax - xMin;
        float heigh = yMax - yMin;
        
        if (width<20&&heigh<20) {
            return TRUE;
        }
    }
    return false;
}

- (void)removeCellView:(NSInteger)tag
{
    [self deleteCellViewFromArrayWithTag:tag];
}

- (void)deleteCellViewFromArrayWithTag:(NSInteger)tag
{
    for (int i=0;i<self.arrayCellView.count;i++) {
        MYDrawCell *cellView = [self.arrayCellView objectAtIndex:i];
        if (tag == cellView.tag) {
            [cellView removeFromSuperview];
            [self.arrayCellView removeObject:cellView];
            [self removeStrokeObjWithTag:tag];
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
        for (int i=0;i<self.arrayCellView.count;i++) {
            UIView *cell = [self.arrayCellView objectAtIndex:i];
            maxTag = maxTag>cell.tag?maxTag:cell.tag;
        }
        NSLog(@"maxTag = [%d]",maxTag);
        return maxTag;
    }
    return 1;
}

- (NSInteger)removeStrokeObjWithTag:(NSInteger)tag
{
    NSInteger index = 0;
    NSInteger count = self.arrayStrokes.count;
    for (int i = 0 ;i < count ; i++) {
        NSMutableDictionary *dic = [self.arrayStrokes objectAtIndex:i];
        if (tag == [[dic objectForKey:@"viewtag"] integerValue]) {
            [self.arrayStrokes removeObjectAtIndex:i];
            index = i;
            break;
        }
    }
    return index;
}

- (void)removeLastCellView
{
    if (self.arrayCellView) {
        MYDrawCell *lastCellView = [self.arrayCellView lastObject];
        [lastCellView removeFromSuperview];
        [self.arrayCellView removeLastObject];
        [self.arrayStrokes removeLastObject];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if ([result isKindOfClass:[UITextView class]]) {
        return result;
    }
    
    for (int i = 0 ; i<self.arrayCellView.count; i++) {
        MYDrawCell *cellview = [self.arrayCellView objectAtIndex:i];
        CGPoint buttonPoint = [cellview.deleteButton convertPoint:point fromView:self];
        if ([cellview.deleteButton pointInside:buttonPoint withEvent:event]) {
            return cellview.deleteButton;
        }
    }
    return result;
}
@end
