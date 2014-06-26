//
//  MYScreenPlot.h
//  ScreenShotDemo
//
//  Created by mysoft on 6/25/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYScreenPlot : UIView

+ (UIImage *)screenShotWithView:(UIView *)currentView;
+ (void)screenShotWithViewToPhotosAlbum:(UIView *)currentView;
- (id)initWithView:(UIView*)editView;
@end
