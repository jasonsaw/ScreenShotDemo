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
    
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
    
    UILabel *fontText = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 40)];
    fontText.text = @"我要自定义字体woyaoceshiti1234567890";
    fontText.font = [UIFont fontWithName:@"Heiti SC" size:16];
    fontText.backgroundColor = [UIColor clearColor];
    fontText.textColor = [UIColor blackColor];
    [self.view addSubview:fontText];
    
    UILabel *fontText2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 40)];
    fontText2.text = @"我要自定义字体woyaoceshiti1234567890";
    fontText2.font = [UIFont fontWithName:@"Heiti TC" size:16];
    fontText2.backgroundColor = [UIColor clearColor];
    fontText2.textColor = [UIColor blackColor];
    [self.view addSubview:fontText2];
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

- (void)complateEdite:(UIView*)screenView shotRect:(CGRect)rect
{
    [MYScreenPlot screenShotWithViewToPhotosAlbum:screenView withRect:rect];
    [editBaseView removeFromSuperview];
    
}

- (void)shareScreen:(UIView*)screenView
{
    NSLog(@"shareScreen");
}
@end
