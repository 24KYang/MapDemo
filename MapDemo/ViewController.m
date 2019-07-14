//
//  ViewController.m
//  MapDemo
//
//  Created by 徐洋 on 2019/7/14.
//  Copyright © 2019 徐洋. All rights reserved.
//

#import "ViewController.h"
#import "LDView.h"
#import "LDTableView.h"
#import "MapDemoHeader.h"
#import "CommonUtility.h"

typedef NS_ENUM(NSUInteger, LDContentOffsetLevel) {
    LDContentOffsetLevelTop = 0,                        //置顶
    LDContentOffsetLevelMid,                             //居中
    LDContentOffsetLevelBottom,                         //置底
};

@interface ViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) LDTableView *tableView;

@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, strong) LDView *routeView;

@end

@implementation ViewController

#pragma mark ---- Init

#pragma mark ---- Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUI];
}
#pragma mark ---- Event Response
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        UITapGestureRecognizer *tapGes = object;
        if (tapGes.state == UIGestureRecognizerStateEnded) {
            if (self.tableView.contentOffset.y > 0) return;
            if (self.tableView.contentOffset.y > kOffsetThresholdLevelOne) {
                [self changeContentOffset:LDContentOffsetLevelTop];
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }else if (self.tableView.contentOffset.y > kOffsetThresholdLevelTwo) {
                [self changeContentOffset:LDContentOffsetLevelMid];
            }else {
                [self changeContentOffset:LDContentOffsetLevelBottom];
            }
        }
    }else if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY = self.tableView.contentOffset.y;
        //当偏移量大于0时 则说明到顶了 不需要改变透明度和坐标
        if (offsetY > 0) return;
        self.statusView.alpha = [CommonUtility changeAlpha:offsetY];
        CGFloat routeHeight = MAX(STATUS_HEIGHT, ABS(offsetY) + STATUS_HEIGHT);
        self.routeView.frame = CGRectMake(0, routeHeight, SCREEN_WIDTH, RouteViewHeight);
    }
}
#pragma mark ---- Delegate
#pragma mark - TableView数据源 - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-----%ld", (long)indexPath.section, (long)indexPath.row];
    return cell;
}
#pragma mark - TableView代理 - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (scrollView.contentOffset.y > 0) return;
        if (self.tableView.contentOffset.y > kOffsetThresholdLevelOne) {
            [self changeContentOffset:LDContentOffsetLevelTop];
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (self.tableView.contentOffset.y > kOffsetThresholdLevelTwo) {
            [self changeContentOffset:LDContentOffsetLevelMid];
        }else {
            [self changeContentOffset:LDContentOffsetLevelBottom];
        }
    }
}

#pragma mark ---- DataRequest

#pragma mark ---- Private Methods
/**
 改变TableView的偏移量
 */
- (void)changeContentOffset:(LDContentOffsetLevel)level {
    CGFloat offsetY;
    switch (level) {
        case LDContentOffsetLevelTop:
            offsetY = kOffsetLevelOne;
            break;
        case LDContentOffsetLevelMid:
            offsetY = kOffsetLevelTwo;
            break;
        case LDContentOffsetLevelBottom:
            offsetY = kOffsetLevelThree;
            break;
    }
    [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}
#pragma mark ---- UI
- (void)loadUI {
    self.view.backgroundColor = UIColor.greenColor;
    
    [self.view addSubview:self.tableView];
    [self changeContentOffset:LDContentOffsetLevelMid];
    
    [self.view addSubview:self.statusView];
    
    [self.view addSubview:self.routeView];
    
    [self.tableView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark ---- Getter and Setter
- (LDTableView *)tableView {
    if (!_tableView) {
        _tableView = [[LDTableView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, SCREEN_HEIGHT, SCREEN_HEIGHT - STATUS_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT - STATUS_HEIGHT - RouteViewHeight, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, RouteViewHeight);
        _tableView.tableHeaderView = view;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_HEIGHT)];
        _statusView.backgroundColor = UIColor.whiteColor;
        _statusView.alpha = 0.f;
    }
    return _statusView;
}

- (LDView *)routeView {
    if (!_routeView) {
        _routeView = [[LDView alloc] init];
        _routeView.backgroundColor = UIColor.redColor;
        _routeView.frame = CGRectMake(0, SCREEN_HEIGHT / 2.f, SCREEN_WIDTH, RouteViewHeight);
    }
    return _routeView;
}
#pragma mark ---- Ohter
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
