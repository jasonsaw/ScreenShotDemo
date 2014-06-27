//
//  MYDrawCell.h
//  ScreenShotDemo
//
//  Created by mysoft on 6/26/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Ellipse = 0,
    CircularRectAngle,
    RectAngle,
}DrawShape;


@protocol removeCellViewDelete <NSObject>

- (void)removeCellView:(NSInteger)tag;

@end

@interface MYDrawCell : UIView

@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,assign) id<removeCellViewDelete> celldelegate;
@property (nonatomic,strong) UIColor *currentColor;//保存当前画笔的颜色
@property (nonatomic,assign) float    currentSize;//当前画笔的大小
@property (nonatomic,assign) DrawShape drawShapeType;
@end
