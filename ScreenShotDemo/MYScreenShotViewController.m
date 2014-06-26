//
//  MYScreenShotViewController.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/25/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYScreenShotViewController.h"
#import "MYScreenPlot.h"
#import "MYEditView.h"

#define kMarginTop 50
#define kMarginButtom 90
#define kMarginLeft 30
@interface MYScreenShotViewController ()
{
    MYEditView *editPlotView;
    UIView *shadowView;
    UIView *chooseBar;
    NSInteger functionButtonTag;
    NSArray *colorArray;
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
    functionButtonTag = 0;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)screenShot:(id)sender
{
    UIImage *screenimage = [MYScreenPlot screenShotWithView:self.view];
    
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    keyWindow.windowLevel = UIWindowLevelNormal;
    
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
    shadowView.alpha = 1;
    [keyWindow addSubview:shadowView];
    
    editPlotView = [[MYEditView alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginTop, kScreenWidth - kMarginLeft*2, kScreenHeight - kMarginTop - kMarginButtom)];
    [shadowView addSubview:editPlotView];
    
    UIImageView *editImageView = [[UIImageView alloc] initWithFrame:editPlotView.bounds];
    editImageView.image = screenimage;
    [editPlotView addSubview:editImageView];
    
    
    //上栏
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    topBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
    //取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 5, 70, 40);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(screenShotCancel:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = [UIColor clearColor];
    [topBar addSubview:cancelButton];
    
    //完成
    UIButton *complateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    complateButton.frame = CGRectMake(kScreenWidth - 70, 5, 70, 40);
    complateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [complateButton setTitle:@"保存" forState:UIControlStateNormal];
    [complateButton addTarget:self action:@selector(screenShotComplate:) forControlEvents:UIControlEventTouchUpInside];
    complateButton.backgroundColor = [UIColor clearColor];
    [topBar addSubview:complateButton];
    
    [shadowView addSubview:topBar];
    
    //功能工具栏
    UIView *functionBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    functionBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];

    NSArray *functionTitle = @[@"标注",@"颜色",@"文字",@"分享"];
    for (int i = 0; i<4; i++) {
        UIButton *funButton = [UIButton buttonWithType:UIButtonTypeCustom];
        funButton.frame = CGRectMake(i*(kScreenWidth/4),0, kScreenWidth/4, 44);
        funButton.tag = i+1;
        funButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [funButton setTitle:[functionTitle objectAtIndex:i] forState:UIControlStateNormal];
        [funButton addTarget:self action:@selector(actionBotton:) forControlEvents:UIControlEventTouchUpInside];
        funButton.backgroundColor = [UIColor clearColor];
        [functionBar addSubview:funButton];
    }
    [shadowView addSubview:functionBar];
}

- (void)screenShotCancel:(id)sender
{
    [shadowView removeFromSuperview];
}

- (void)screenShotComplate:(id)sender
{
    [MYScreenPlot screenShotWithViewToPhotosAlbum:editPlotView];
    [shadowView removeFromSuperview];
}

- (void)actionBotton:(UIButton*)button
{
    functionButtonTag = button.tag;
    //选择工具栏
    if (!chooseBar) {
        chooseBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44-36, kScreenWidth, 36)];
        chooseBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    }
    [chooseBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (button.tag) {
        case 1:
            //标注
        {
            NSArray *imageArray = @[[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"1.png"]];
            for (int i = 0; i<3; i++) {
                UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseButton.frame = CGRectMake(15 + i*(60+10),4, 60, 30);
                chooseButton.tag = i;
                [chooseButton setBackgroundImage:[imageArray objectAtIndex:i]  forState:UIControlStateNormal];
                chooseButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [chooseButton addTarget:self action:@selector(chooseBotton:) forControlEvents:UIControlEventTouchUpInside];
                chooseButton.backgroundColor = [UIColor clearColor];
                [chooseBar addSubview:chooseButton];
            }
        }
            break;
        case 2:
            //颜色
        {
            colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor greenColor]];
            for (int i = 0; i<4; i++) {
                UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseButton.frame = CGRectMake(15+i*(32+5),0, 32, 32);
                chooseButton.tag = i;
                chooseButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [chooseButton addTarget:self action:@selector(chooseBotton:) forControlEvents:UIControlEventTouchUpInside];
                chooseButton.backgroundColor = [UIColor clearColor];
                
                [chooseButton.layer setMasksToBounds:YES];
                [chooseButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
                [chooseButton.layer setBorderWidth:1.0]; //边框宽度
                UIColor *borderColor = [colorArray objectAtIndex:i];
                [chooseButton.layer setBorderColor:[borderColor CGColor]];//边框颜色
                
                [chooseBar addSubview:chooseButton];
            }
        }
            break;
        case 3:
            //文字
        {
            NSArray *fontArray = @[@"标注",@"颜色",@"文字",@"分享"];
            NSArray *titleArray = @[@"黑体",@"宋体",@"幼圆",@"行楷"];
            for (int i = 0; i<4; i++) {
                UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseButton.frame = CGRectMake(15 + i*(50+5),0, 50, 32);
                chooseButton.tag = i;
                [chooseButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
                chooseButton.titleLabel.font = [UIFont fontWithName:[fontArray objectAtIndex:i] size:14];
                [chooseButton addTarget:self action:@selector(chooseBotton:) forControlEvents:UIControlEventTouchUpInside];
                chooseButton.backgroundColor = [UIColor clearColor];
                [chooseBar addSubview:chooseButton];
            }
        }
            break;
        case 4:
            //分享
            break;
        default:
            break;
    }
    [shadowView addSubview:chooseBar];
}

- (void)chooseBotton:(UIButton*)button
{
    switch (functionButtonTag) {
        case 1:
            //
            editPlotView.drawShapeType = button.tag;
            break;
        case 2:
            //
            editPlotView.currentColor = [colorArray objectAtIndex:button.tag];
            break;
        case 3:
            //
            break;
        case 4:
            //
            break;
        default:
            break;
    }
}

@end
