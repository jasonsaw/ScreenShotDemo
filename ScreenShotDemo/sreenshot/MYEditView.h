//
//  MYEditView.h
//  ScreenShotDemo
//
//  Created by mysoft on 6/26/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MYDrawCell.h"

@interface MYEditView : UIView

@property (nonatomic,strong) UIColor *currentColor;//保存当前画笔的颜色
@property (nonatomic,assign) float    currentSize;//当前画笔的大小
@property (nonatomic,assign) DrawShape drawShapeType;
@end
