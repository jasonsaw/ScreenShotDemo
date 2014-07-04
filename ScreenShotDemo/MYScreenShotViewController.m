//
//  MYScreenShotViewController.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/25/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYScreenShotViewController.h"
#import "MYScreenPlot.h"
#import "MYEditBaseView.h"

#define kMarginTop 50
#define kMarginButtom 90
#define kMarginLeft 30
@interface MYScreenShotViewController ()<EditeViewDelegate>
{
    MYEditBaseView *editBaseView;
}

@end

@implementation MYScreenShotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"截屏标注";
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screenshottest.png"]];
    backImageView.frame = self.view.bounds;
    [self.view addSubview:backImageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(screenShot:)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)screenShot:(id)sender
{
    UIImage *screenimage;
#ifdef __IPHONE_7_0
    UIView *screenView = self.view;//[self.view snapshotViewAfterScreenUpdates:NO];
    UIGraphicsBeginImageContextWithOptions(screenView.bounds.size, NO, 0.0);
    // Render our snapshot into the image context
    [screenView drawViewHierarchyInRect:screenView.bounds afterScreenUpdates:NO];
//    [self.view snapshotViewAfterScreenUpdates:NO];
    // Grab the image from the context
    UIImage *complexViewImage = UIGraphicsGetImageFromCurrentImageContext();
    screenimage = complexViewImage;
//    screenimage = [self getImageFromView:screenView];
#else
    extern CGImageRef UIGetScreenImage();
    screenimage = [UIImage imageWithCGImage:UIGetScreenImage()];
#endif
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    keyWindow.windowLevel = UIWindowLevelNormal;
    
    editBaseView = [[MYEditBaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    editBaseView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
    editBaseView.alpha = 1;
    editBaseView.delegate = self;
    editBaseView.editeImage = screenimage;
    [keyWindow addSubview:editBaseView];
}


- (void)cancelEdit
{
    [editBaseView removeFromSuperview];
}

- (void)complateEdite:(UIView*)screenView
{
    [MYScreenPlot screenShotWithViewToPhotosAlbum:screenView];
    [editBaseView removeFromSuperview];
    
}

- (void)shareScreen:(UIView*)screenView
{
    NSLog(@"shareScreen");
}
@end
