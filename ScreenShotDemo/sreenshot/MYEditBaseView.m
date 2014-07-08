//
//  MYEditBaseView.m
//  ScreenShotDemo
//
//  Created by mysoft on 7/1/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYEditBaseView.h"
#import "MYEditView.h"

#define DragButtomShowWidth 4
#define DragButtomWidth 20
#define ShadowBackGroundColor [UIColor colorWithWhite:0 alpha:0.7f]

@interface MYEditBaseView()
{
    NSInteger functionButtonTag;
    UIView *chooseBar;
    NSArray *colorArray;
    NSArray *fontArray;
    MYEditView *editView;
    UIView *topShadow;
    UIView *leftShadow;
    UIView *rightShadow;
    UIView *bottomShadow;
    
    UIButton *dragButtom1;
    UIButton *dragButtom2;
    UIButton *dragButtom3;
    UIButton *dragButtom4;
    
    CGPoint prevPoint;
}

@end

@implementation MYEditBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        functionButtonTag = 0;
        [self createView];
    }
    return self;
}

- (void)setEditeImage:(UIImage*)image
{
    _editeImage = image;
    if (_editeImage) {
        UIImageView *editImageView = [[UIImageView alloc] initWithFrame:editView.bounds];
        editImageView.image = self.editeImage;
        [editView addSubview:editImageView];
    }
}

- (void)addPanGestureRecognizer:(UIButton*)button
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    [button addGestureRecognizer:panGesture];
}

- (void)handelPan:(UIPanGestureRecognizer*)recognizer
{
    if ([recognizer state]== UIGestureRecognizerStateBegan)
    {
        prevPoint = [recognizer locationInView:self];
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer locationInView:self];
        float wChange = 0.0, hChange = 0.0;
        
        wChange = (point.x - prevPoint.x);
        hChange = (point.y - prevPoint.y);
        
        if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
            prevPoint = [recognizer locationInView:self];
            return;
        }
        NSLog(@"point = [%@]",NSStringFromCGPoint(point));
        UIButton *button = (UIButton*)recognizer.view;
        switch (button.tag) {
            case 1:
            {
                dragButtom1.frame = CGRectMake(dragButtom1.frame.origin.x+wChange, dragButtom1.frame.origin.y+hChange, DragButtomWidth, DragButtomWidth);
                if (dragButtom1.frame.origin.x<kMarginLeft-DragButtomShowWidth) {
                    dragButtom1.frame = CGRectMake(kMarginLeft-DragButtomShowWidth, dragButtom1.frame.origin.y+hChange, DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom1.frame.origin.y<kMarginTop-DragButtomShowWidth) {
                    dragButtom1.frame = CGRectMake(dragButtom1.frame.origin.x+wChange, kMarginTop-DragButtomShowWidth, DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom1.frame.origin.y>dragButtom4.frame.origin.y) {
                    dragButtom1.frame = CGRectMake(dragButtom1.frame.origin.x, dragButtom4.frame.origin.y, DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom1.frame.origin.x>dragButtom2.frame.origin.x) {
                    dragButtom1.frame = CGRectMake(dragButtom2.frame.origin.x, dragButtom1.frame.origin.y, DragButtomWidth, DragButtomWidth);
                }
                topShadow.frame = CGRectMake(topShadow.frame.origin.x, kMarginTop, kScreenWidth-2*kMarginLeft, dragButtom1.frame.origin.y+DragButtomShowWidth-kMarginTop);
                leftShadow.frame = CGRectMake(kMarginLeft,dragButtom1.frame.origin.y+DragButtomShowWidth, dragButtom1.frame.origin.x+DragButtomShowWidth-kMarginLeft, bottomShadow.frame.origin.y - (topShadow.frame.origin.y+topShadow.frame.size.height));
                rightShadow.frame = CGRectMake(rightShadow.frame.origin.x, dragButtom1.frame.origin.y+DragButtomShowWidth, rightShadow.frame.size.width, bottomShadow.frame.origin.y-(topShadow.frame.origin.y+topShadow.frame.size.height));
                dragButtom2.frame = CGRectMake(dragButtom2.frame.origin.x, dragButtom1.frame.origin.y, DragButtomWidth, DragButtomWidth);
                dragButtom4.frame = CGRectMake(dragButtom1.frame.origin.x, dragButtom4.frame.origin.y, DragButtomWidth, DragButtomWidth);
                
                [self bringSubviewToFront:dragButtom1];
            }
                break;
            case 2:
            {
                dragButtom2.frame = CGRectMake(dragButtom2.frame.origin.x+wChange, dragButtom2.frame.origin.y+hChange, DragButtomWidth, DragButtomWidth);
                if (dragButtom2.frame.origin.x>kScreenWidth - kMarginLeft - DragButtomWidth + DragButtomShowWidth) {
                    dragButtom2.frame = CGRectMake(kScreenWidth - kMarginLeft - DragButtomWidth + DragButtomShowWidth, dragButtom2.frame.origin.y+hChange, DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom2.frame.origin.y<kMarginTop-DragButtomShowWidth) {
                    dragButtom2.frame = CGRectMake(dragButtom2.frame.origin.x+wChange, kMarginTop-DragButtomShowWidth, DragButtomWidth, DragButtomWidth);
                }
                
                if (dragButtom2.frame.origin.x<dragButtom1.frame.origin.x+DragButtomShowWidth) {
                    dragButtom2.frame = CGRectMake(dragButtom1.frame.origin.x+DragButtomShowWidth, dragButtom2.frame.origin.y ,DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom2.frame.origin.y>dragButtom3.frame.origin.y+DragButtomShowWidth) {
                    dragButtom2.frame = CGRectMake(dragButtom2.frame.origin.x, dragButtom3.frame.origin.y+DragButtomShowWidth, DragButtomWidth, DragButtomWidth);
                }
                topShadow.frame = CGRectMake(topShadow.frame.origin.x, topShadow.frame.origin.y,kScreenWidth-2*kMarginLeft, dragButtom2.frame.origin.y+DragButtomShowWidth-kMarginTop);
                rightShadow.frame = CGRectMake(dragButtom2.frame.origin.x+DragButtomWidth-DragButtomShowWidth, dragButtom2.frame.origin.y+DragButtomShowWidth, kScreenWidth - kMarginLeft - (dragButtom2.frame.origin.x+DragButtomWidth-DragButtomShowWidth), bottomShadow.frame.origin.y-(topShadow.frame.origin.y+topShadow.frame.size.height));
                leftShadow.frame = CGRectMake(leftShadow.frame.origin.x, dragButtom2.frame.origin.y+DragButtomShowWidth, leftShadow.frame.size.width, bottomShadow.frame.origin.y - (topShadow.frame.origin.y+topShadow.frame.size.height));
                dragButtom1.frame = CGRectMake(dragButtom1.frame.origin.x, dragButtom2.frame.origin.y, DragButtomWidth, DragButtomWidth);
                [self bringSubviewToFront:dragButtom2];
                dragButtom3.frame = CGRectMake(dragButtom2.frame.origin.x, dragButtom3.frame.origin.y, DragButtomWidth, DragButtomWidth);
            }
                break;
                case 3:
            {
                dragButtom3.frame = CGRectMake(dragButtom3.frame.origin.x+wChange, dragButtom3.frame.origin.y+hChange, DragButtomWidth, DragButtomWidth);
                if (dragButtom3.frame.origin.y+DragButtomWidth-DragButtomShowWidth>kScreenHeight-kMarginButtom) {
                    dragButtom3.frame = CGRectMake(dragButtom3.frame.origin.x, kScreenHeight - kMarginButtom +DragButtomShowWidth-DragButtomWidth, DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom3.frame.origin.x>kScreenWidth-kMarginLeft-DragButtomWidth+DragButtomShowWidth) {
                    dragButtom3.frame = CGRectMake(kScreenWidth - kMarginLeft - DragButtomWidth + DragButtomShowWidth, dragButtom3.frame.origin.y, DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom3.frame.origin.y<dragButtom2.frame.origin.y) {
                    dragButtom3.frame = CGRectMake(dragButtom3.frame.origin.x, dragButtom2.frame.origin.y, DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom3.frame.origin.x<dragButtom4.frame.origin.x) {
                    dragButtom3.frame = CGRectMake(dragButtom4.frame.origin.x,dragButtom3.frame.origin.y ,DragButtomWidth, DragButtomWidth);
                }
                bottomShadow.frame = CGRectMake(bottomShadow.frame.origin.x, dragButtom3.frame.origin.y+(DragButtomWidth-DragButtomShowWidth), kScreenWidth-kMarginLeft*2,kScreenHeight -kMarginButtom - (dragButtom3.frame.origin.y+(DragButtomWidth-DragButtomShowWidth)));
                rightShadow.frame = CGRectMake(dragButtom3.frame.origin.x+DragButtomWidth-DragButtomShowWidth, rightShadow.frame.origin.y, kScreenWidth-kMarginLeft-(dragButtom3.frame.origin.x+DragButtomWidth-DragButtomShowWidth), bottomShadow.frame.origin.y-(topShadow.frame.origin.y+topShadow.frame.size.height));
                leftShadow.frame = CGRectMake(leftShadow.frame.origin.x, leftShadow.frame.origin.y, leftShadow.frame.size.width, bottomShadow.frame.origin.y-(topShadow.frame.origin.y+topShadow.frame.size.height));
                dragButtom2.frame = CGRectMake(dragButtom3.frame.origin.x, dragButtom2.frame.origin.y, DragButtomWidth, DragButtomWidth);
                dragButtom4.frame = CGRectMake(dragButtom4.frame.origin.x, dragButtom3.frame.origin.y, DragButtomWidth, DragButtomWidth);
            }
                break;
                case 4:
            {
                dragButtom4.frame = CGRectMake(dragButtom4.frame.origin.x+wChange, dragButtom4.frame.origin.y+hChange, DragButtomWidth, DragButtomWidth);
                if (dragButtom4.frame.origin.y>kScreenHeight-kMarginButtom-(DragButtomWidth - DragButtomShowWidth)) {
                    dragButtom4.frame = CGRectMake(dragButtom4.frame.origin.x, kScreenHeight-kMarginButtom-(DragButtomWidth - DragButtomShowWidth), DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom4.frame.origin.x>dragButtom3.frame.origin.x) {
                    dragButtom4.frame = CGRectMake(dragButtom3.frame.origin.x, dragButtom4.frame.origin.y, DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom4.frame.origin.x<kMarginLeft-DragButtomShowWidth) {
                    dragButtom4.frame = CGRectMake(kMarginLeft-DragButtomShowWidth, dragButtom4.frame.origin.y, DragButtomWidth, DragButtomWidth);
                }
                if (dragButtom4.frame.origin.y<dragButtom1.frame.origin.y) {
                    dragButtom4.frame = CGRectMake(dragButtom4.frame.origin.x, dragButtom1.frame.origin.y, DragButtomWidth, DragButtomWidth);
                }
                bottomShadow.frame = CGRectMake(kMarginLeft, dragButtom4.frame.origin.y+DragButtomWidth-DragButtomShowWidth, kScreenWidth-2*kMarginLeft, kScreenHeight-kMarginButtom-(dragButtom4.frame.origin.y+DragButtomWidth-DragButtomShowWidth));
                leftShadow.frame = CGRectMake(kMarginLeft,dragButtom1.frame.origin.y+DragButtomShowWidth, dragButtom4.frame.origin.x+DragButtomShowWidth-kMarginLeft, bottomShadow.frame.origin.y - (topShadow.frame.origin.y+topShadow.frame.size.height));
                rightShadow.frame = CGRectMake(rightShadow.frame.origin.x, rightShadow.frame.origin.y, rightShadow.frame.size.width,  bottomShadow.frame.origin.y-(topShadow.frame.origin.y+topShadow.frame.size.height));
                
                dragButtom1.frame = CGRectMake(dragButtom4.frame.origin.x, dragButtom1.frame.origin.y, DragButtomWidth, DragButtomWidth);
                dragButtom3.frame = CGRectMake(dragButtom3.frame.origin.x, dragButtom4.frame.origin.y, DragButtomWidth, DragButtomWidth);
            }
                break;
            default:
                break;
        }
        prevPoint = [recognizer locationInView:self];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (dragButtom1.frame.origin.x<kMarginLeft-DragButtomShowWidth || dragButtom4.frame.origin.x<kMarginLeft-DragButtomShowWidth) {
            dragButtom1.frame = CGRectMake(kMarginLeft-DragButtomShowWidth, dragButtom1.frame.origin.y, DragButtomWidth, DragButtomWidth);
            dragButtom4.frame = CGRectMake(kMarginLeft-DragButtomShowWidth, dragButtom4.frame.origin.y, DragButtomWidth, DragButtomWidth);
            leftShadow.frame = CGRectMake(kMarginLeft,dragButtom1.frame.origin.y+DragButtomShowWidth, dragButtom4.frame.origin.x+DragButtomShowWidth-kMarginLeft, bottomShadow.frame.origin.y - (topShadow.frame.origin.y+topShadow.frame.size.height));
        }
        
        if (dragButtom2.frame.origin.x>kScreenWidth-kMarginLeft-DragButtomWidth+DragButtomShowWidth || dragButtom3.frame.origin.x>kScreenWidth-kMarginLeft-DragButtomWidth+DragButtomShowWidth) {
            dragButtom2.frame = CGRectMake(kScreenWidth - kMarginLeft - DragButtomWidth + DragButtomShowWidth, dragButtom2.frame.origin.y, DragButtomWidth, DragButtomWidth);
            dragButtom3.frame = CGRectMake(kScreenWidth - kMarginLeft - DragButtomWidth + DragButtomShowWidth, dragButtom3.frame.origin.y, DragButtomWidth, DragButtomWidth);
            
            rightShadow.frame = CGRectMake(dragButtom3.frame.origin.x+DragButtomWidth-DragButtomShowWidth, rightShadow.frame.origin.y, kScreenWidth-kMarginLeft-(dragButtom3.frame.origin.x+DragButtomWidth-DragButtomShowWidth), bottomShadow.frame.origin.y-(topShadow.frame.origin.y+topShadow.frame.size.height));
        }
    }
    
}

#pragma mark initEditView

- (void)createView
{
    editView = [[MYEditView alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginTop, kScreenWidth - kMarginLeft*2, kScreenHeight - kMarginTop - kMarginButtom)];
    [self addSubview:editView];
    //缩放的四个边框
    
    topShadow = [[UIView alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginTop, kScreenWidth - kMarginLeft*2, 0)];
    rightShadow = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - kMarginLeft, kMarginTop, 0, kScreenHeight - kMarginTop - kMarginButtom)];
    bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(kMarginLeft, kScreenHeight - kMarginButtom, kScreenWidth - kMarginLeft*2, 0)];
    leftShadow = [[UIView alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginTop, 0, kScreenHeight - kMarginTop - kMarginButtom)];
    
    topShadow.backgroundColor = ShadowBackGroundColor;
    rightShadow.backgroundColor = ShadowBackGroundColor;
    bottomShadow.backgroundColor = ShadowBackGroundColor;
    leftShadow.backgroundColor = ShadowBackGroundColor;
    
    [self addSubview:topShadow];
    [self addSubview:rightShadow];
    [self addSubview:bottomShadow];
    [self addSubview:leftShadow];
    
    dragButtom1 = [UIButton buttonWithType:UIButtonTypeCustom];
    dragButtom1.tag = 1;
    dragButtom1.frame = CGRectMake(kMarginLeft-DragButtomShowWidth, kMarginTop-DragButtomShowWidth, DragButtomWidth, DragButtomWidth);
    [dragButtom1 setBackgroundImage:[UIImage imageNamed:@"eidt_icon_upleft.png"] forState:UIControlStateNormal];
    [self addPanGestureRecognizer:dragButtom1];
    
    dragButtom2 = [UIButton buttonWithType:UIButtonTypeCustom];
    dragButtom2.tag = 2;
    dragButtom2.frame = CGRectMake(kScreenWidth - kMarginLeft - DragButtomWidth + DragButtomShowWidth, kMarginTop-DragButtomShowWidth, DragButtomWidth, DragButtomWidth);
    [dragButtom2 setBackgroundImage:[UIImage imageNamed:@"eidt_icon_upright.png"] forState:UIControlStateNormal];
    [self addPanGestureRecognizer:dragButtom2];
    
    dragButtom3 = [UIButton buttonWithType:UIButtonTypeCustom];
    dragButtom3.tag = 3;
    dragButtom3.frame = CGRectMake(kScreenWidth - kMarginLeft - DragButtomWidth + DragButtomShowWidth, kScreenHeight - kMarginButtom +DragButtomShowWidth-DragButtomWidth, DragButtomWidth, DragButtomWidth);
    [dragButtom3 setBackgroundImage:[UIImage imageNamed:@"eidt_icon_rightlower.png"] forState:UIControlStateNormal];
    [self addPanGestureRecognizer:dragButtom3];
    
    dragButtom4 = [UIButton buttonWithType:UIButtonTypeCustom];
    dragButtom4.tag = 4;
    dragButtom4.frame = CGRectMake(kMarginLeft-DragButtomShowWidth, kScreenHeight - kMarginButtom +DragButtomShowWidth-DragButtomWidth, DragButtomWidth, DragButtomWidth);
    [dragButtom4 setBackgroundImage:[UIImage imageNamed:@"eidt_icon_leftlower.png"] forState:UIControlStateNormal];
    [self addPanGestureRecognizer:dragButtom4];
    
    [self addSubview:dragButtom1];
    [self addSubview:dragButtom2];
    [self addSubview:dragButtom3];
    [self addSubview:dragButtom4];
    
    //上栏
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    topBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
    //取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 5, 70, 40);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(screenShotCancel:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = [UIColor clearColor];
    [topBar addSubview:cancelButton];
    
    //完成
    UIButton *complateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    complateButton.frame = CGRectMake(kScreenWidth - 70, 5, 70, 40);
    complateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [complateButton setTitle:@"保存" forState:UIControlStateNormal];
    [complateButton addTarget:self action:@selector(screenShotComplate:) forControlEvents:UIControlEventTouchUpInside];
    complateButton.backgroundColor = [UIColor clearColor];
    [topBar addSubview:complateButton];
    
    [self addSubview:topBar];
    
    //功能工具栏
    UIView *functionBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    functionBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    
    NSArray *functionTitle = @[@"标注",@"颜色",@"文字",@"分享"];
    for (int i = 0; i<4; i++) {
        UIButton *funButton = [UIButton buttonWithType:UIButtonTypeCustom];
        funButton.frame = CGRectMake(i*(kScreenWidth/4),0, kScreenWidth/4, 44);
        funButton.tag = i+1;
        funButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [funButton setTitle:[functionTitle objectAtIndex:i] forState:UIControlStateNormal];
        [funButton addTarget:self action:@selector(actionBotton:) forControlEvents:UIControlEventTouchUpInside];
        funButton.backgroundColor = [UIColor clearColor];
        [functionBar addSubview:funButton];
    }
    [self addSubview:functionBar];
}

- (void)screenShotCancel:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelEdit)]) {
        [self.delegate cancelEdit];
    }
}

- (void)screenShotComplate:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(complateEdite:shotRect:)]) {
        CGRect rect = CGRectMake(dragButtom1.frame.origin.x+DragButtomShowWidth, dragButtom1.frame.origin.y+DragButtomShowWidth, dragButtom2.frame.origin.x-dragButtom1.frame.origin.x-2*DragButtomShowWidth, dragButtom4.frame.origin.y-dragButtom1.frame.origin.y-2*DragButtomShowWidth);
        [self.delegate complateEdite:editView shotRect:rect];
    }
}

- (void)actionBotton:(UIButton*)button
{
    functionButtonTag = button.tag;
    //选择工具栏
    if (!chooseBar) {
        chooseBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44-36, kScreenWidth, 36)];
        chooseBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    }
    [chooseBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (button.tag) {
        case 1:
            //标注
        {
            NSArray *imageArray = @[[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"1.png"]];
            for (int i = 0; i<3; i++) {
                UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseButton.frame = CGRectMake(15 + i*(60+10),4, 60, 30);
                chooseButton.tag = i;
                [chooseButton setBackgroundImage:[imageArray objectAtIndex:i]  forState:UIControlStateNormal];
                chooseButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [chooseButton addTarget:self action:@selector(chooseBotton:) forControlEvents:UIControlEventTouchUpInside];
                chooseButton.backgroundColor = [UIColor clearColor];
                [chooseBar addSubview:chooseButton];
            }
            editView.drawType = DrawMark;
            editView.drawShapeType = 0;
        }
            break;
        case 2:
            //颜色
        {
            colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor greenColor]];
            for (int i = 0; i<4; i++) {
                UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseButton.frame = CGRectMake(15+i*(32+5),0, 32, 32);
                chooseButton.tag = i;
                chooseButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [chooseButton addTarget:self action:@selector(chooseBotton:) forControlEvents:UIControlEventTouchUpInside];
                chooseButton.backgroundColor = [UIColor clearColor];
                
                [chooseButton.layer setMasksToBounds:YES];
                [chooseButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
                [chooseButton.layer setBorderWidth:1.0]; //边框宽度
                UIColor *borderColor = [colorArray objectAtIndex:i];
                [chooseButton.layer setBorderColor:[borderColor CGColor]];//边框颜色
                
                [chooseBar addSubview:chooseButton];
            }
            editView.currentColor = [colorArray objectAtIndex:0];
        }
            break;
        case 3:
            //文字
        {
            fontArray = @[@"Heiti SC",@"simsun",@"YouYuan",@"STXingkai"];
            NSArray *titleArray = @[@"黑体",@"宋体",@"幼圆",@"行楷"];
            for (int i = 0; i<4; i++) {
                UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseButton.frame = CGRectMake(15 + i*(50+5),0, 50, 32);
                chooseButton.tag = i;
                [chooseButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
                chooseButton.titleLabel.font = [UIFont fontWithName:[fontArray objectAtIndex:i] size:14];
                [chooseButton addTarget:self action:@selector(chooseBotton:) forControlEvents:UIControlEventTouchUpInside];
                chooseButton.backgroundColor = [UIColor clearColor];
                [chooseBar addSubview:chooseButton];
            }
            //宋体：simsun   行楷：STXingkai  幼圆：YouYuan 黑体：Heiti SC
            editView.drawTextFont = [UIFont fontWithName:[fontArray objectAtIndex:0] size:16];
            editView.drawType = DrawFont;
        }
            break;
        case 4:
            //分享
            break;
        default:
            break;
    }
    [self addSubview:chooseBar];
}

- (void)chooseBotton:(UIButton*)button
{
    switch (functionButtonTag) {
        case 1:
            //画形状
            editView.drawShapeType = button.tag;
            break;
        case 2:
            //换颜色
            editView.currentColor = [colorArray objectAtIndex:button.tag];
            break;
        case 3:
            //字体
            editView.drawTextFont = [fontArray objectAtIndex:button.tag];
            editView.drawType = DrawFont;
            break;
        case 4:
            //分享
            break;
        default:
            break;
    }
}
@end
