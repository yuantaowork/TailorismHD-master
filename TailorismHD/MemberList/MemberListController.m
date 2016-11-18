//
//  MemberListController.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "MemberListController.h"
#import "MemberDetailsController.h"
#import "MemberInfoController.h"
#import "pinyin.h"
#import "MJRefresh.h"
#import "PersonalController.h"
@interface MemberListController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *meberListTabel;
@property (strong, nonatomic) NSArray * listDataArry;
@property (strong, nonatomic) NSMutableArray * titleArry;
@property (strong, nonatomic) NSDictionary * datadic;
@property (strong, nonatomic) NSMutableArray * seatitleArry;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;


@end

NSString *const kCellIdentifier = @"MeberListcellID";

@implementation MemberListController

- (void)forceUpVersion {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate forceUpVersion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceUpVersion) name:UIApplicationWillEnterForegroundNotification object:nil];

    
    //获取通知中心
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(getReloadData) name:@"MeberList" object:nil];
    
    self.navigationItem.rightBarButtonItem = _rightBarButton;
    
    _meberListTabel.delegate = self;
    _meberListTabel.dataSource = self;
    _seatitleArry = [[NSMutableArray alloc]init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    self.tableView.tableHeaderView =self.searchController.searchBar;
    self.searchController.searchBar.placeholder = @"请输入客户名或手机号";
    NSLog(@"%@", self.view.backgroundColor);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    AppDelegate * appdelegate = (AppDelegate * )[[UIApplication sharedApplication]delegate];
    [appdelegate getHttpMeberList];
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[self.tableView.mj_header.lastUpdatedTime timeIntervalSince1970]];
        NSLog(@"%@", timeSp);
        
        
         [self getHttpMeberList:[NSString stringWithFormat:@"%lld",[timeSp longLongValue]-100000]];
        
        
    }];


    self.splitViewController.maximumPrimaryColumnWidth = 350;
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.5;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([super class])];
    }
    return self;
}



-(void)getHttpMeberList:(NSString *)lastTime
{
    NSDictionary * dic = nil;
    if (![lastTime isEqualToString:@"0"]) {
        
        //        dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"pageSize":@"500",@"last_time":lastTime};
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Roles"]isEqualToString:@"Yes"])
        {
            dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"pageSize":@"100",@"last_time":lastTime};
            
        }else
        {
            dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"pageSize":@"100",@"last_time":lastTime,@"uid":[[NSUserDefaults standardUserDefaults] valueForKey:@"adminID"]};
        }
        
    }else
    {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"%@---",dic);
    
    [manager POST:MerberList parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        NSLog(@"%@______",uploadProgress);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            if ([[responseObject objectForKey:@"data"]count]==0) {
                
                [self.tableView.mj_header endRefreshing];
                return ;
            }
            
            NSMutableArray * dataarry = [[NSMutableArray alloc]init];
            for (int i =0; i<[[[responseObject objectForKey:@"data"]objectForKey:@"data"]count]; i++)
            {
                
                
                NSDictionary * dic = [[[responseObject objectForKey:@"data"]objectForKey:@"data"]objectAtIndex:i];
                
                if (![[dic objectForKey:@"phone_number"]isEqual:[NSNull null]])
                {
                    if (![[dic objectForKey:@"name"]isEqual:[NSNull null]]&&[[dic objectForKey:@"name"]length]!=0)
                    {
                        
                        [dataarry addObject:@{@"name":[dic objectForKey:@"name"],@"phone_number":[dic objectForKey:@"phone_number"],@"consignee_address":[dic objectForKey:@"consignee_address"]}];
                    }else
                    {
                        [dataarry addObject:@{@"name":@"暂无姓名",@"phone_number":[dic objectForKey:@"phone_number"],@"consignee_address":[dic objectForKey:@"consignee_address"]}];
                    }
                    
                }
                
            }
            
            NSDictionary* memberImgdic =[[responseObject objectForKey:@"data"]objectForKey:@"memberImg"];
            NSMutableArray * muatarry = [[NSMutableArray alloc]init];
            
            for (int i =0; i<[[memberImgdic allKeys]count]; i++) {
                
                for (int j=0; j< [[memberImgdic valueForKey:[[memberImgdic allKeys] objectAtIndex:i]]count]; j++) {
                    
                    
                    
                    [muatarry addObject: [[memberImgdic valueForKey:[[memberImgdic allKeys] objectAtIndex:i]]objectAtIndex:j]];
                    
                }
                
                
            }
            
            NSLog(@"图片名称-----%@",muatarry);
            
            
            
            
            
            if ([LYFmdbTool insertMember2:[[responseObject objectForKey:@"data"]objectForKey:@"data"]]) {
                
                
                if ([LYFmdbTool insertMemberName:dataarry])
                {
                    if (muatarry.count !=0)
                    {
                        if ([LYFmdbTool insertImageName2 :muatarry del:NO])
                        {
                            
                            
                        }
                        
                    }
                    
                }
                
                
                
            }else
            {
                
            }
            
            
            
            
            NSLog(@"%@--姓名数据",dataarry);
            [SVProgressHUD showSuccessWithStatus:@"全部数据更新成功"];
            [self.tableView.mj_header endRefreshing];
            
            
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
    
    
    
    [self getReloadData];
}





- (IBAction)rightBarButton:(id)sender {
    

    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您要添加的客户是否为线上已预约或已注册用户?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"不是" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
            MemberInfoController * view = [[MemberInfoController alloc]init];
            view.pushID = @"3";
        //    [self.navigationController pushViewController:view animated:YES];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:view];
            [self presentViewController:nc animated:YES completion:nil];
            [view.tabBarController.tabBar setHidden:YES];
        
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
            [self linshiOrder];
        
        
    }]];
    [self presentViewController:alert animated:true completion:nil];

    
}

-(void)getHttplinshiMeberList:(NSString *)phoneNum
{
    
    [SVProgressHUD show];
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"phone_number":phoneNum};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST: MerberList parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            if ([[[responseObject objectForKey:@"data"]valueForKey:@"data"]isKindOfClass:[NSArray class]]) {
                
                
                if ([[[responseObject objectForKey:@"data"]valueForKey:@"data"]count]>0) {
                    
                    
                    NSArray * arry =[[responseObject objectForKey:@"data"]valueForKey:@"data"];
                    
                    if ([[[arry objectAtIndex:0]valueForKey:@"dressing_name"]isKindOfClass:[NSNull class]]||[[[arry objectAtIndex:0]valueForKey:@"dressing_name"] length]==0) {
                        
                        [SVProgressHUD dismiss];
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"已查询到客户信息,是否继续操作?" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            
                            MemberDetailsController * view  = [[MemberDetailsController alloc]init];
                            view.listDataArry =arry;
                            view.phoneNum = [[arry objectAtIndex:0]valueForKey:@"phone_number"];
                            view.pushID = @"1";

                            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:view];
                            [self presentViewController:nc animated:YES completion:nil];
                            [view.tabBarController.tabBar setHidden:YES];
                            
                            
                        }]];
                        [self presentViewController:alert animated:true completion:nil];
                        
                        
                        
                        
                    }else{
                        
                        if ([[[[[responseObject objectForKey:@"data"]valueForKey:@"data"] objectAtIndex:0]valueForKey:@"dressing_name"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"adminname"]]) {
                            
                            [SVProgressHUD showInfoWithStatus:@"该客户为您的本地客户,请在客户列表中查询"];
                            
                        }else {
                            
                            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"该客户已归属着装顾问%@!",[[[[responseObject objectForKey:@"data"]valueForKey:@"data"] objectAtIndex:0]valueForKey:@"dressing_name"]]];
                        }
                        
                    }
                    
                    
                }else {
                    
                    [SVProgressHUD showInfoWithStatus:@"未查询到该客户信息"];
                }
                
                
            }else {
                
                [SVProgressHUD showInfoWithStatus:@"未查询到该客户信息"];
            }
            
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        
    }];
}



-(void)linshiOrder {
    
    // 准备初始化配置参数
    NSString *title = @"未归属着装顾问客户查询";
    NSString *message = @"请输入您要查询的手机号";
    NSString *okButtonTitle = @"确定";
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建文本框
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入手机号";
        textField.secureTextEntry = NO;
    }];
    
    
    UIAlertAction *cancelokAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 读取文本框的值显示出来
        
        
    }];
    
    // 创建操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 读取文本框的值显示出来
        
        UITextField *phoneNum = alertDialog.textFields.firstObject;
        [self getHttplinshiMeberList:phoneNum.text];
    }];
    
    
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:cancelokAction];
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];
    
}



-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
//    [self.tabBarController.tabBar setHidden:NO];
    self.searchController.active = NO;
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]==YES){
        
        [self getReloadData];
        
    }else
    {
        
        
        
        [UIView animateWithDuration:0.0 delay:2.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            
            [SVProgressHUD showInfoWithStatus:@"由于您第一次启动,系统需要进行配置,请稍后..."];
            
        } completion:^(BOOL finished) {
            
            
            PersonalController * Controller = [[PersonalController alloc]init];
            [Controller getHttpMeberList:@"0"success:^(BOOL Success) {
                
                
            }];
            
        }];
        
    }
}


-(void)getReloadData
{
    _listDataArry = [NSArray arrayWithArray:[LYFmdbTool queryData:@"t_member_name"]];
    
    if (_listDataArry ==nil)
    {
        return;
    }
    
    _datadic = [_listDataArry sortedArrayUsingFirstLetterByKeypath:@"name"];
    
    _titleArry =[[NSMutableArray alloc]initWithArray:[[_datadic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    if(_titleArry.count!=0){
        if ([[_titleArry objectAtIndex:0]isEqualToString:@"#"])
        {
            [_titleArry removeObjectAtIndex:0];
            [_titleArry addObject:@"#"];
            
        }
    }
    
    [self.tableView reloadData];
    
 
    
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForSearchText:searchController.searchBar.text
                               scope:nil];
    
    if (self.searchController.active)
    {
//        [self.tabBarController.tabBar setHidden:YES];
    }else
    {
//        [self.tabBarController.tabBar setHidden:YES];
//        self.tabBarController.tabBar.hidden = YES;
    }
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (self.searchController.active)
    {
        return 0;
    }else
    {
        if (section==0) {
            
            return 36;
            
        }else
        {
            return 36;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view=[[UILabel alloc] initWithFrame:CGRectMake(40, -10, CGRectGetWidth(tableView.frame), 30)];
    view.backgroundColor = [UIColor clearColor];
    view.text = [_titleArry objectAtIndex:section];
    view.textColor = [UIColor colorWithHex:@"6d87c3"];
    view.font =[UIFont systemFontOfSize:17.f];
    return view ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    if (self.searchController.active)
    {
        return 1;
    }else
    {
        return _titleArry.count;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return _seatitleArry.count;
    }else
    {
        return [[_datadic valueForKey:[_titleArry objectAtIndex:section]]count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"MemberListCell" forIndexPath:indexPath];
    UILabel * namelabel = (UILabel *)[cell viewWithTag:2120];
    UILabel * tellabel = (UILabel *)[cell viewWithTag:2121];
    UILabel * addresslabel = (UILabel *)[cell viewWithTag:2122];
    
    if (self.searchController.active)
    {
        namelabel.text = [self Nallstring:[_seatitleArry[indexPath.row]valueForKey:@"name"]];
        tellabel.text =[self Nallstring:[_seatitleArry[indexPath.row]valueForKey:@"phone_number"]];
        addresslabel.text =[self Nallstring:[_seatitleArry[indexPath.row]valueForKey:@"consignee_address"]];
        
    }else
    {
        namelabel.text = [self Nallstring:[[[_datadic valueForKey:[_titleArry objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]valueForKey:@"name"]];
        tellabel.text =[self Nallstring:[[[_datadic valueForKey:[_titleArry objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]valueForKey:@"phone_number"]];
        addresslabel.text =[self Nallstring:[[[_datadic valueForKey:[_titleArry objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]valueForKey:@"consignee_address"]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

    
    MemberDetailsController * meberDetails = [[MemberDetailsController alloc]init];
    if (self.searchController.active)
    {
        meberDetails.phoneNum = [self Nallstring:[_seatitleArry[indexPath.row]valueForKey:@"phone_number"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MemberDetails" object:[self Nallstring:[_seatitleArry[indexPath.row]valueForKey:@"phone_number"]]];
        
    }else
    {
        meberDetails.phoneNum = [self Nallstring:[[[_datadic valueForKey:[_titleArry objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]valueForKey:@"phone_number"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MemberDetails" object:[self Nallstring:[[[_datadic valueForKey:[_titleArry objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]valueForKey:@"phone_number"]]];
    }
    
    self.searchController.active = NO;

    
}



-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        return _titleArry;
    }else
    {
        return nil;
    }
    
}



-(NSString *)Nallstring:(id)str {
    
    if ([str isEqual:[NSNull null]])
    {
        return @"";
    }else
    {
        return str;
    }
}


#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < _listDataArry.count; i++) {
        NSString *storeString = [_listDataArry[i]valueForKey:@"name"];
        NSString *telstr=[_listDataArry[i]valueForKey:@"phone_number"];
        NSString *address=[_listDataArry[i]valueForKey:@"consignee_address"];
        
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange storeRange1 = NSMakeRange(0, telstr.length);
        
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        NSRange foundRange1 = [telstr rangeOfString:searchText options:searchOptions range:storeRange1];
        
        if (foundRange.length) {
            NSDictionary *dic=@{@"name":storeString,@"phone_number":telstr,@"consignee_address":address};
            
            [tempResults addObject:dic];
        }
        
        if (foundRange1.length)
        {
            NSDictionary *dic=@{@"name":storeString,@"phone_number":telstr,@"consignee_address":address};
            [tempResults addObject:dic];
        }
        
        
    }
    
    [_seatitleArry removeAllObjects];
    [_seatitleArry addObjectsFromArray:tempResults];
    [self.tableView reloadData];
    
}

@end
