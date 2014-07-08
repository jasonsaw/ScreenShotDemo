//
//  MYEditBaseView.h
//  ScreenShotDemo
//
//  Created by mysoft on 7/1/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditeViewDelegate <NSObject>

- (void)cancelEdit;
- (void)complateEdite:(UIView*)screenView shotRect:(CGRect)rect;
- (void)shareScreen:(UIView*)screenView;

@end

@interface MYEditBaseView : UIView

@property (nonatomic,strong) UIImage *editeImage;//编辑的图片
@property (nonatomic,assign) id<EditeViewDelegate> delegate;
@end
