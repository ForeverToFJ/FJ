//
//  DemoViewController.m
//  demo
//
//  Created by  高帆 on 2017/6/23.
//  Copyright © 2017年 GF. All rights reserved.
//

#import "DemoViewController.h"
#import "UIView+FJExtension.h"

#define FJScreenW [UIScreen mainScreen].bounds.size.width
#define FJScreenH [UIScreen mainScreen].bounds.size.height

CGFloat const FJTitlesViewH = 35;
CGFloat const FJTitlesViewY = 64;

@interface DemoViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
/**
 *  <#注释#>
 */
@property (nonatomic, strong) NSArray *list;
/**
 *  标签栏底部指示器
 */
@property (nonatomic, weak) UIView *indicatorView;
/**
 *  当前选中的按钮
 */
@property (nonatomic, weak) UIButton *selectedButton;
/**
 *  标签栏
 */
@property (nonatomic, weak) UIView *titlesView;
/**
 *  内容
 */
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation DemoViewController

#pragma mark - 懒加载
- (NSArray *)list {
    if (!_list) {
        _list = [NSArray array];
    }
    return _list;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  创建标题栏
 */
- (void)setupTitleView {
    
    // 标签栏
    UIView *titlesView = [[UIView alloc] init];
    //    titlesView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    //    titlesView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titlesView.fj_width= FJScreenW;
    titlesView.fj_height = FJTitlesViewH;
    titlesView.fj_y = FJTitlesViewY;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.fj_height = 2;
    indicatorView.fj_y = titlesView.fj_height - indicatorView.fj_height;
    // tag
    indicatorView.tag = -1;
    self.indicatorView = indicatorView;
    
    // 内部子标签
    CGFloat height = titlesView.fj_height;
    CGFloat width = titlesView.fj_width / self.titles.count;
    for (NSInteger i = 0; i < self.titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.fj_height = height;
        button.fj_width = width;
        button.fj_x = i * width;
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        
        button.tag = i;
        
        // 强制布局
        //        [button layoutIfNeeded];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认选中第一个
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.fj_width = button.titleLabel.fj_width;
            //            self.indicatorView.width = [titles[i] sizeWithAttributes:@{NSFontAttributeName : button.titleLabel.font}].width;
            self.indicatorView.fj_centerX = button.fj_centerX;
        }
    }
    [titlesView addSubview:indicatorView];
}

/**
 *  创建底部的scrollView
 */
- (void)setupContentView {
    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    //    contentView.backgroundColor = [UIColor redColor];
    contentView.frame = CGRectMake(0, 99, FJScreenW, FJScreenH - 99 - 50);
    // 成为代理
    contentView.delegate = self;
    // 分页
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.fj_width * self.titles.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器
    [self scrollViewDidEndScrollingAnimation:contentView];
}

/**
 *  初始化子控制器
 */
- (void)VC1:(UIViewController *)vc1 VC1Title:(NSString *)title1 VC2:(UIViewController *)vc2 VC2Title:(NSString *)title2 {
    vc1.title = title1;
    [self addChildViewController:vc1];
    vc2.title = title2;
    [self addChildViewController:vc2];
    
    // 创建标题栏
    [self setupTitleView];
    
    // 创建底部的scrollView
    [self setupContentView];
}

- (void)titleClick:(UIButton *)button {
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 标签栏底部指示器
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorView.fj_width = button.titleLabel.fj_width;
        self.indicatorView.fj_centerX = button.fj_centerX;
    }];
    
    // 切换子控制器
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.fj_width;
    [self.contentView setContentOffset:offset animated:YES];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.fj_width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    
    vc.view.fj_x = scrollView.contentOffset.x;
    // 默认会把y设为20
    vc.view.fj_y = 0;
    // 设置高度
    vc.view.fj_height = scrollView.fj_height;
    
    // 添加到scrollView
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.fj_width;
    [self titleClick:self.titlesView.subviews[index]];
}

@end
