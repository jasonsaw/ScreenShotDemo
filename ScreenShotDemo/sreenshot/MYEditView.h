//
//  MYEditView.h
//  ScreenShotDemo
//
//  Created by mysoft on 6/26/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MYDrawCell.h"


@interface MYEditView : UIView <removeCellViewDelete>

@property (nonatomic,strong) UIFont  *drawTextFont;
@property (nonatomic,strong) UIImage *editeImage;//编辑的图片
@property (nonatomic,strong) UIColor *currentColor;//保存当前画笔的颜色
@property (nonatomic,assign) float    currentSize;//当前画笔的大小
@property (nonatomic,assign) DrawShape drawShapeType;
@property (nonatomic,assign) DrawType  drawType;
@end
