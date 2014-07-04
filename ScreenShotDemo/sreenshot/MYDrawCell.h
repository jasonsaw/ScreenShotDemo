//
//  MYDrawCell.h
//  ScreenShotDemo
//
//  Created by mysoft on 6/26/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMarginTop 50
#define kMarginButtom 90
#define kMarginLeft 30

typedef enum {
    Ellipse = 0,
    CircularRectAngle,
    RectAngle,
}DrawShape;

typedef enum {
    DrawMark = 0,
    DrawFont,
}DrawType;

@protocol removeCellViewDelete <NSObject>

- (void)removeCellView:(NSInteger)tag;

@end

@interface MYDrawCell : UIView<UITextViewDelegate>

@property (nonatomic,strong) UIButton                 *deleteButton;
@property (nonatomic,strong) UIButton              *dragButton;
@property (nonatomic,strong) UITextView               *textView;
@property (nonatomic,strong) UIFont                   *drawTextFont;
@property (nonatomic,assign) id<removeCellViewDelete> celldelegate;
@property (nonatomic,strong) UIColor                  *currentColor;     //保存当前画笔的颜色
@property (nonatomic,assign) float                    currentSize;       //当前画笔的大小
@property (nonatomic,assign) DrawShape                drawShapeType;     //画标注类型
@property (nonatomic,assign) DrawType                 drawMarkOrOther;   //画标注还是字体
@end
