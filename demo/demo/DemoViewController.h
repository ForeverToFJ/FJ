//
//  DemoViewController.h
//  demo
//
//  Created by  高帆 on 2017/6/23.
//  Copyright © 2017年 GF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoViewController : UIViewController

/**
 *  标题
 */
@property (nonatomic, strong) NSArray *titles;

/**
 *  添加子控制器
 */
- (void)VC1:(UIViewController *)vc1 VC1Title:(NSString *)title1 VC2:(UIViewController *)vc2 VC2Title:(NSString *)title2;

@end
