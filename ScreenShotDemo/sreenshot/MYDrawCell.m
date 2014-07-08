//
//  MYDrawCell.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/26/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYDrawCell.h"

#define kButtonWidth 15
#define kMarginBorderSide 0

@interface MYDrawCell()
{
    UILabel *placeHolder;
    float   cellViewOrginX;
    float   cellViewOrginY;
}

@end
@implementation MYDrawCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self layoutDeleteButton];
//        [self layoutDragButton];
    }
    return self;
}

- (void)setDrawMarkOrOther:(DrawType)drawMarkOrOther
{
    _drawMarkOrOther = drawMarkOrOther;
    if (drawMarkOrOther == DrawFont) {
        [self layoutTextFiled];
    }
}

- (void)layoutDeleteButton
{
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect xPositive = CGRectMake(self.frame.origin.x-kButtonWidth/2, self.frame.origin.y-kButtonWidth/2, kButtonWidth, kButtonWidth);
    self.deleteButton.frame = xPositive;
    self.deleteButton.tag = self.tag;
    self.deleteButton.backgroundColor = [UIColor clearColor];
    self.deleteButton.userInteractionEnabled = YES;
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"eidt_icon_off_p.png"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteCellView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
}

- (void)layoutDragButton
{
    self.dragButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dragButton setBackgroundImage:[UIImage imageNamed:@"eidt_icon_rotate_n.png"] forState:UIControlStateNormal];
    self.dragButton.tag = self.tag;
    self.dragButton.backgroundColor = [UIColor clearColor];
    self.dragButton.userInteractionEnabled = YES;
    self.dragButton.hidden = NO;
    [self addSubview:self.dragButton];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    [self.dragButton addGestureRecognizer:panGesture];
}

- (void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.superview.superview];
    NSLog(@"cgpoint = [%@],self.frame = [%@]",NSStringFromCGPoint(translation),NSStringFromCGRect(self.frame));
    self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y, self.frame.origin.x+translation.x, self.frame.origin.y+translation.y);
    [self setNeedsDisplay];
//    [self setFrame:CGRectMake(self.frame.origin.x , self.frame.origin.y, translation.x-self.frame.origin.x, translation.y-self.frame.origin.y)];
}

- (void)deleteCellView:(id)sender
{
    if (self.celldelegate && [self.celldelegate respondsToSelector:@selector(removeCellView:)]) {
        [self.celldelegate removeCellView:self.deleteButton.tag];
    }
}

- (void)layoutTextFiled
{
    CGRect textFrame = CGRectMake(kMarginBorderSide, kMarginBorderSide, self.bounds.size.width-kMarginBorderSide*2, self.bounds.size.height-kMarginBorderSide*2);
    
    self.textView = [[UITextView alloc] initWithFrame:textFrame];
    self.textView.font = self.drawTextFont;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.layer.borderWidth = 2;
    self.textView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:self.textView];
    
    
    placeHolder = [[UILabel alloc] initWithFrame:self.textView.bounds];
    placeHolder.text = @"点击输入文字";
    placeHolder.font = self.drawTextFont;
    placeHolder.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:placeHolder];
    
    [self bringSubviewToFront:self.deleteButton];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        placeHolder.hidden = YES;
    } else {
        placeHolder.hidden = NO;
    }
    CGRect orgRect=self.textView.frame;//获取原始UITextView的frame
    NSLog(@"textView.text = [%@]",textView.text);
    NSString *text = textView.text;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenWidth-2*kMarginLeft-10, 2000) lineBreakMode:UILineBreakModeClip];
    orgRect.size.height = size.height + 16;//获取自适应文本内容高度
    orgRect.size.width = size.width + 16;
    self.textView.frame=orgRect;//重设UITextView的frame
    
    NSLog(@"size = [%@]",NSStringFromCGSize(size));
    
    
    [self calculateWidthAndHeight:size];
    self.frame = CGRectMake(cellViewOrginX, self.frame.origin.y, self.textView.frame.size.width, self.textView.frame.size.height);

    
    CGRect xPositive = CGRectMake(self.bounds.origin.x + self.bounds.size.width - kButtonWidth+5, -5, kButtonWidth, kButtonWidth);
    self.deleteButton.frame = xPositive;
}

- (void)calculateWidthAndHeight:(CGSize)size
{
    cellViewOrginX = self.frame.origin.x;
    if (cellViewOrginX+self.textView.frame.size.width>kScreenWidth-kMarginLeft*2) {  //20 是textView 距离cellView的边距；30 是cellView距离屏幕边距
        cellViewOrginX = cellViewOrginX - ((cellViewOrginX+self.textView.frame.size.width) - (kScreenWidth-kMarginLeft*2));
    }
    
    if (cellViewOrginX<0) {
        cellViewOrginX=0;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    CGRect xPositive = CGRectMake(rect.origin.x, rect.size.height/2-DeletekButtonWidth/2, DeletekButtonWidth, DeletekButtonWidth);
//    NSLog(@"origin.x = [%f]",self.frame.origin.x);
//    if (self.frame.origin.x<0) {
//        xPositive = CGRectMake(rect.origin.x + rect.size.width - DeletekButtonWidth, rect.size.height/2-DeletekButtonWidth/2, DeletekButtonWidth, DeletekButtonWidth);
//    }
    CGRect deletePositive = CGRectMake(rect.origin.x + rect.size.width - kButtonWidth, 0, kButtonWidth, kButtonWidth);
    self.deleteButton.frame = deletePositive;
    self.deleteButton.tag = self.tag;
    
    CGRect dragPositive = CGRectMake(rect.origin.x + rect.size.width - kButtonWidth, rect.size.height-kButtonWidth, kButtonWidth, kButtonWidth);
    self.dragButton.frame = dragPositive;
    
    CGRect drawRect = CGRectMake(self.currentSize/2, self.currentSize/2, rect.size.width-self.currentSize, rect.size.height-self.currentSize);
    
    if (self.drawMarkOrOther == DrawMark) {
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
}

- (void)showDragButton
{
    CGRect dragPositive = CGRectMake(self.frame.origin.x + self.frame.size.width - kButtonWidth, self.frame.size.height-kButtonWidth/2, kButtonWidth, kButtonWidth);
    self.dragButton.frame = dragPositive;
    self.dragButton.hidden = NO;
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
    [self showDragButton];
    [self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self showDragButton];
    [self.nextResponder touchesEnded:touches withEvent:event];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *result = [super hitTest:point withEvent:event];
//    if ([result isKindOfClass:[UITextView class]]) {
//        return result;
//    }
//    
//    return result;
//}
@end
