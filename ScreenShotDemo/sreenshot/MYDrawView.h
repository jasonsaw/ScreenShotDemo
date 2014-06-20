//
//  MYDrawView.h
//  ScreenShotDemo
//
//  Created by mysoft on 6/18/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYDrawView : UIView


@property (nonatomic,strong) UIImage *pickedImage;
@property (nonatomic,strong) UIColor *currentColor;//保存当前画笔的颜色
@property (nonatomic,assign) float    currentSize;//当前画笔的大小

- (void)undo;
- (void)redo;
- (void)clearCanvas;
@end
