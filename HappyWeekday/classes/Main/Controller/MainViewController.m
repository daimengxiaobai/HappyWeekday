//
//  MainViewController.m
//  HappyWeekday
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainModel.h"
//选择城市
#import "SelectCityViewController.h"
//搜索活动
#import "SearchViewController.h"
//推荐专题详情（点击专题cell）
#import "ThemeViewController.h"
//推荐活动详情（点击活动cell）
#import "ActivityDetailViewController.h"
//精选专题
#import "GoodActivityViewController.h"
//热门专题
#import "HotActivityViewController.h"
//演出/景点/学习/亲子 按钮
#import "ClasssifyViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface MainViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数组
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数组
@property (nonatomic, strong) NSMutableArray *themeArray;
//广告
@property (nonatomic, strong) NSMutableArray *adArray;
//轮播图
@property(nonatomic, retain) UIScrollView *carouseView;

@property(nonatomic, retain) UIPageControl *pageControl;

@property(nonatomic, strong) NSTimer *timer;
@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 210;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //left
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBtn;
   
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 18, 18);
   
    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(seachActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    [self request];
    [self configTableViewHeadView];
    [self startTimer];
}

#pragma mark ------------- UITableViewDataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }
    return self.themeArray.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.model = array[indexPath.row];
    return mainCell;
}
//分组标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

//自定义分区头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - 160 ,0, 320, 16)];
    
    if (section == 0) {
       sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];
    }else{
       sectionView.image = [UIImage imageNamed:@"home_recommd_ac"];
    }
    [view addSubview:sectionView];
    return view;
}
//点击cell 进入活动介绍或专题介绍
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityDetailViewController *activityVC = [[ActivityDetailViewController alloc] init];
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}
#pragma marks ------- Custom Method
//选择城市
- (void)selectCityAction:(UIButton *)btn{
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    [self.navigationController pushViewController:selectCityVC animated:YES];
    
}
//搜索关键字
- (void)seachActivityAction:(UIButton *)btn{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//自定义tableview头部
- (void)configTableViewHeadView{
    UIView *HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 343)];
//tableView的tableHeaderView属性  ！！！！！很重要的属性
    self.tableView.tableHeaderView = HeadView;
    //轮播图
    self.carouseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 186)];
    self.carouseView.contentSize = CGSizeMake(self.adArray.count * KScreenWidth, 186);
    self.carouseView.pagingEnabled = YES;  //整屏滑动
    //不显示水平方向滚动条
    self.carouseView.showsHorizontalScrollIndicator = NO;
    self.carouseView.delegate = self;
    
    //创建小圆点
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 156, KScreenWidth, 30)];
    self.pageControl.numberOfPages = self.adArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventValueChanged];
    
    
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]] placeholderImage:nil];
        [self.carouseView addSubview:imageView];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       
        touchBtn.frame = imageView.frame;
        touchBtn.tag = 100 + i;
        [touchBtn addTarget:self action:@selector(touchAdvertisement:) forControlEvents:UIControlEventTouchUpInside];
        [self.carouseView addSubview:touchBtn];
       
        
    }
    
    [HeadView addSubview:self.carouseView];
    [HeadView addSubview:self.pageControl];
    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * KScreenWidth / 4, 186, KScreenWidth / 4, KScreenWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%d", i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [HeadView addSubview:btn];
    }

    //精选活动&专门专题
    UIButton *activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activityBtn.frame = CGRectMake(0, 191 + KScreenWidth / 4, KScreenWidth / 2, 343 - 186 - KScreenWidth / 4 - 8);
    [activityBtn setImage:[UIImage imageNamed:@"home_huodong@2x(1)"] forState:UIControlStateNormal];
    activityBtn.tag = 104;
    [activityBtn addTarget:self action:@selector(goodActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [HeadView addSubview:activityBtn];
    
    UIButton *themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    themeBtn.frame = CGRectMake(KScreenWidth / 2, 191 + KScreenWidth / 4, KScreenWidth / 2, 343 - 186 - KScreenWidth / 4 - 8);
    [themeBtn setImage:[UIImage imageNamed:@"home_zhuanti@2x(1)"] forState:UIControlStateNormal];
    themeBtn.tag = 105;
    [themeBtn addTarget:self action:@selector(hotActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [HeadView addSubview:themeBtn];
}
//- (UIScrollView *)carouseView{
//    if (_carouseView == nil) {
//        
//    }
//    return _carouseView;
//}
//- (UIPageControl *)pageControl{
//    if (_pageControl == nil) {
//        
//    }
//    return _pageControl;
//}

//网络请求
- (void)request{
    NSString *urlString = KMainDataList;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
        [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld", downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
        NSDictionary *resultDic = responseObject;
        
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
       
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            self.listArray = [NSMutableArray new];
            self.activityArray = [NSMutableArray new];
            for (NSDictionary *dic in acDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dic];
                
                [self.activityArray addObject:model];
            }
            
            [self.listArray addObject:self.activityArray];
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            self.themeArray = [NSMutableArray new];
            for (NSDictionary *dic in rcDataArray) {
                
                MainModel *model = [[MainModel alloc] initWithDictionary:dic];
                [self.themeArray addObject:model];
                
            }
           
            [self.listArray addObject:self.themeArray];
            //刷新tableView数据
            [self.tableView reloadData];
            //广告
            self.adArray = [NSMutableArray new];
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dic in adDataArray) {
                NSDictionary *dict = @{@"url" : dic[@"url"], @"type" : dic[@"type"]};
                [self.adArray addObject:dict];
            }
            //拿到数据之后重新刷新headView
            [self configTableViewHeadView];
           
            //以请求回来的城市作为导航栏按钮标题
             NSString *cityName = dic[@"cityname"];
            self.navigationItem.leftBarButtonItem.title = cityName;
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
}
-(void)mainActivityButtonAction:(UIButton *)btn{
    if (btn.tag > 0) {
        ClasssifyViewController *classifyVC = [[ClasssifyViewController alloc] init];
        
        [self.navigationController pushViewController:classifyVC animated:YES];
    }
    
    
   }

-(void)goodActivityButtonAction:(UIButton *)btn{
    GoodActivityViewController *goodActivityVC = [[GoodActivityViewController alloc] init];
    [self.navigationController pushViewController:goodActivityVC animated:YES];
}
-(void)hotActivityButtonAction:(UIButton *)btn{
    HotActivityViewController *hotActivityVC = [[HotActivityViewController alloc] init];
    [self.navigationController pushViewController:hotActivityVC animated:YES];
}
- (void)touchAdvertisement:(UIButton *)btn{
    //从数组中的字典里面取出type类型
    NSString *type = self.adArray[btn.tag - 100][@"type"];
    if ([type integerValue ] == 1){
    ActivityDetailViewController *activityVC = [[ActivityDetailViewController alloc] init];
        //活动ID

    [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        HotActivityViewController *hotVC = [[HotActivityViewController alloc] init];
        [self.navigationController pushViewController:hotVC animated:nil];
    }
}
#pragma marks -------- startTimer
- (void)startTimer{
    //防止定时器重复创建
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(rollAnimation) userInfo:nil repeats:YES];
}
- (void)pageSelectAction:(UIPageControl *)pageControl{
    NSInteger pageNumber = self.pageControl.currentPage;
    CGFloat pageWidth = self.carouseView.frame.size.width;
    self.carouseView.contentOffset = CGPointMake(pageNumber * pageWidth, 0);
    
}
//每两秒执行一次，图片自动轮播

- (void)rollAnimation{
    NSInteger page = (self.pageControl.currentPage + 1) % self.adArray.count;
    self.pageControl.currentPage = page;
    //计算出scrollView应该滚动的x轴坐标
    CGFloat offsetx = page * KScreenWidth;
    [self.carouseView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
