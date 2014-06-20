//
//  MYPalette.h
//  ScreenShotDemo
//
//  Created by mysoft on 6/19/14.
//  Copyright (c) 2014 mysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYPalette : UIView {
    NSMutableArray *stroks;
    NSMutableArray *redoStrokes;
	//weak
	CGMutablePathRef currentPath;
	BOOL isEarse;
}

@property(nonatomic, assign) BOOL isEarse;
@property(nonatomic, strong) UIColor *currentColor;

- (void)clearStroks;
- (void)undo;
- (void)redo;
@end
