//
//  MYScreenPlot.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/25/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYScreenPlot.h"

@interface MYScreenPlot()
{
    
}

@end

@implementation MYScreenPlot

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithView:(UIView *)editView
{
    self = [super init];
    if (self) {
        // Initialization code
        
    }
    return self;
}

+ (UIImage *)screenShotWithView:(UIView *)currentView
{
    UIGraphicsBeginImageContext(currentView.frame.size); //currentView 当前的view
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
}

+ (void)screenShotWithViewToPhotosAlbum:(UIView *)currentView withRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(currentView.frame.size); //currentView 当前的view
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *resultImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(viewImage.CGImage,rect)];
    UIGraphicsEndImageContext();
    
    //viewImage就是获取的截图，如果要将图片存入相册，只需在后面调用
    UIImageWriteToSavedPhotosAlbum(resultImg,nil,nil,nil);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
