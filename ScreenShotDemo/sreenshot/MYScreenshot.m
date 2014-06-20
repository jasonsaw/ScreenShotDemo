//
//  MYScreenshot.m
//  ScreenShot
//
//  Created by mysoft on 6/17/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYScreenshot.h"

@implementation MYScreenshot

+ (UIImage *)screenShotWithView:(UIView *)currentView
{
    UIGraphicsBeginImageContext(currentView.frame.size); //currentView 当前的view
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
//    viewImage就是获取的截图，如果要将图片存入相册，只需在后面调用
//    UIImageWriteToSavedPhotosAlbum(viewImage,nil,nil,nil);
}

@end
