//
//  MYViewController.m
//  ScreenShotDemo
//
//  Created by mysoft on 6/17/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import "MYViewController.h"
#import "MYScreenshot.h"
#import "MYDrawView.h"
#import "MYPalette.h"

#define BUTTONTITLEFONTSIZE 12
#define BUTTONWIDTH         40
#define BUTTONHEIGH         35

@interface MYViewController ()

@property (nonatomic, strong) MYPalette             *paletteView;
@property (nonatomic, strong) IBOutlet UIImageView  *viewBackImage;
@property (nonatomic, strong) IBOutlet UIView       *toolView;
@property (nonatomic, strong) IBOutlet UIScrollView *toolScrollView;
@property (nonatomic, strong) NSArray  *colorArray;
@end

@implementation MYViewController

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
    self.colorArray = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor],[UIColor grayColor],[UIColor lightGrayColor]];
    self.title = @"涂鸦";
    self.paletteView = [[MYPalette alloc] initWithFrame:self.view.bounds];
    self.paletteView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.paletteView];
    [self createDrawFunction];
    [self.view bringSubviewToFront:self.toolView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doDrawFunction:(UIButton*)button
{
    switch (button.tag) {
        case 0:
            //撤销
            [self.paletteView undo];
            break;
        case 1:
            //回撤
            [self.paletteView redo];
            break;
        case 2:
            //橡皮擦
            self.paletteView.isEarse = YES;
            break;
        case 3:
            //清空
            [self.paletteView clearStroks];
            break;
        default:
            break;
    }
    
    if (button.tag>3) {
        self.paletteView.isEarse = NO;
        self.paletteView.currentColor = [self.colorArray objectAtIndex:button.tag-4];
    }
}

- (void)createDrawFunction
{
    //撤销
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    undoButton.frame = CGRectMake(5, 4.5, BUTTONWIDTH, BUTTONHEIGH);
    [undoButton setTitle:@"撤销" forState:UIControlStateNormal];
    [undoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    undoButton.titleLabel.font = [UIFont systemFontOfSize:BUTTONTITLEFONTSIZE];
    undoButton.tag = 0;
    [undoButton addTarget:self action:@selector(doDrawFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolScrollView addSubview:undoButton];
    
    //回撤
    UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    redoButton.frame = CGRectMake(50, 4.5, BUTTONWIDTH, BUTTONHEIGH);
    [redoButton setTitle:@"回撤" forState:UIControlStateNormal];
    [redoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    redoButton.titleLabel.font = [UIFont systemFontOfSize:BUTTONTITLEFONTSIZE];
    redoButton.tag = 1;
    [redoButton addTarget:self action:@selector(doDrawFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolScrollView addSubview:redoButton];
    
    //橡皮擦
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(95, 4.5, BUTTONWIDTH, BUTTONHEIGH);
    [clearButton setTitle:@"橡皮擦" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:BUTTONTITLEFONTSIZE];
    clearButton.tag = 2;
    [clearButton addTarget:self action:@selector(doDrawFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolScrollView addSubview:clearButton];
    
    //清空
    UIButton *clearAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearAllButton.frame = CGRectMake(140, 4.5, BUTTONWIDTH, BUTTONHEIGH);
    [clearAllButton setTitle:@"清空" forState:UIControlStateNormal];
    [clearAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clearAllButton.titleLabel.font = [UIFont systemFontOfSize:BUTTONTITLEFONTSIZE];
    clearAllButton.tag = 3;
    [clearAllButton addTarget:self action:@selector(doDrawFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolScrollView addSubview:clearAllButton];
    
    //取色
    for (int i = 0; i<5; i++) {
        UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.colorArray.count>i) {
            colorButton.backgroundColor = [self.colorArray objectAtIndex:i];
        } else {
            colorButton.backgroundColor = [UIColor redColor];
        }
        colorButton.frame = CGRectMake(185+i*42, 4.5, 35, 35);
        colorButton.tag = 4+i;
        [colorButton addTarget:self action:@selector(doDrawFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolScrollView addSubview:colorButton];
        float contentWidth = colorButton.frame.origin.x+colorButton.frame.size.width;
        if (contentWidth>320) {
            self.toolScrollView.contentSize = CGSizeMake(contentWidth+2, colorButton.frame.size.height);
        }
    }
}

@end
