//
//  ViewController.m
//  demo
//
//  Created by  高帆 on 2017/6/23.
//  Copyright © 2017年 GF. All rights reserved.
//

#import "ViewController.h"
#import "AViewController.h"
#import "BViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"A界面", @"B界面"];
    [self VC1:[[AViewController alloc] init] VC1Title:self.titles[0] VC2:[[BViewController alloc] init] VC2Title:self.titles[1]];
}


@end
