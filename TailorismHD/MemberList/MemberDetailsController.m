//
//  MemberDetailsController.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "MemberDetailsController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MemberType.h"
#import "LYUIImageView.h"
#import "PaddingDataController.h"
#import "OrderHomeController.h"
#import "MemberInfoController.h"
//#import "OrderViewController.h"

@interface MemberDetailsController ()<MWPhotoBrowserDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightButton;

@property (strong ,nonatomic)NSArray * imageNameArry;
@property (strong ,nonatomic)NSMutableDictionary * imageDic;
@property (nonatomic, strong) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet UIButton *memberUpdata;
@property (weak, nonatomic) IBOutlet UIView *hidenView;


@end

@implementation MemberDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(selectHidenView:) name:@"MemberDetails" object:nil];
   
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = nil;
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberListNameCell" bundle:nil] forCellReuseIdentifier:@"MemberListNameCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell2" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell3" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell3"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell4" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell4"];
    
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if ([_pushID isEqualToString:@"1"]) {
        
        _hidenView.hidden = YES;
        self.navigationItem.rightBarButtonItem = _rightButton;
    }

}


-(void)selectHidenView:(NSNotification*)str {
    
    NSLog(@"%@--",[str object]);
    _phoneNum =[str object];
    [self getReloadData];
    self.navigationItem.rightBarButtonItem = _rightButton;
    _hidenView.hidden = YES;
    [self setTabBarHidden:YES];
    
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)rightButton:(id)sender {
    
    if ([_pushID isEqualToString:@"1"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    _hidenView.hidden = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.tabBar.hidden = NO;
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-49);
}

- (void)setTabBarHidden:(BOOL)hidden
{
    
    if (self.tabBarController.tabBar.hidden != YES) {
        
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)+49);
        
        self.tabBarController.tabBar.hidden = hidden;
        
    }

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getReloadData];
  
    
    self.splitViewController.maximumPrimaryColumnWidth = 350;
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.5;
    
}


- (IBAction)paddingData:(UIButton *)sender {
    
        self.splitViewController.maximumPrimaryColumnWidth = 0;
        self.splitViewController.preferredPrimaryColumnWidthFraction = 0.5;
    
//    PaddingDataController * paddingView = [[PaddingDataController alloc]init];
//    [self.navigationController pushViewController:paddingView animated:YES];
    MemberInfoController * memberInfo = [[MemberInfoController alloc]init];
    memberInfo.memberDataDic =[_listDataArry objectAtIndex:0];
    memberInfo.pushID = @"1";
    memberInfo.imagedic = _imageDic;
    memberInfo.title = @"客户信息";
    [self.navigationController pushViewController:memberInfo animated:YES];
    
}


-(void)getReloadData
{
      _imageDic = [[NSMutableDictionary alloc]init];
    
    if (![_pushID isEqualToString:@"1"]) {
        
        
        
        _listDataArry = [NSArray arrayWithArray:[LYFmdbTool queryData2:[NSString stringWithFormat:@"t_member WHERE phone_number = '%@'",_phoneNum]]];
        
        if (_listDataArry.count ==0) {
            
            return;
        }
        
        NSString *str = [[_listDataArry objectAtIndex:0]valueForKey:@"id"];
        
        _imageNameArry = [NSArray arrayWithArray:[LYFmdbTool queryData2:[NSString stringWithFormat:@"ImageName WHERE m_id = '%@'",str]]];
        
        NSLog(@"%@",_imageNameArry);
        
        self.tableView.delegate= self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
        
        
    }else {
        
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"LinShi"]isEqualToString:@"Yes"]) {
            
//            _listDataArry = [NSArray arrayWithArray:[LYFmdbTool queryData2:[NSString stringWithFormat:@"t_member WHERE phone_number = '%@'",_phoneNum]]];
//            
//            NSString *str = [[_listDataArry objectAtIndex:0]valueForKey:@"id"];
//            
//            _imageNameArry = [NSArray arrayWithArray:[LYFmdbTool queryData2:[NSString stringWithFormat:@"ImageName WHERE m_id = '%@'",str]]];
//            
//            NSLog(@"%@",_imageNameArry);
            
            self.tableView.delegate= self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LinShi"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        
        
    }
    NSLog(@"%@",_listDataArry);
    
}


- (IBAction)addOrder:(UIButton *)sender {
    
    if (_listDataArry.count==0)
    {
        [SVProgressHUD showErrorWithStatus:@"该客户数据有误!"];
        
    }else{
        
        self.splitViewController.maximumPrimaryColumnWidth = 0;
        self.splitViewController.preferredPrimaryColumnWidthFraction = 0.5;

        
        MemberInfoController * memberInfo = [[MemberInfoController alloc]init];
        memberInfo.pushID = @"2";
        memberInfo.imagedic = _imageDic;
        memberInfo.memberDataDic =[_listDataArry objectAtIndex:0];
        memberInfo.title = @"客户收货信息";
        [self.navigationController pushViewController:memberInfo animated:YES];
        
    }
}



- (NSString *)handleSpaceAndEnterElementWithString:(NSString *)sourceStr

{
    
    NSString *realSre = [sourceStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *realSre1 = [realSre stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    NSString *realSre2 = [realSre1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *realSre3 = [realSre2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *realSre4 = [realSre3 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    
    NSString *realSre5 = [realSre4 stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    
    
    NSArray *array = [realSre5 componentsSeparatedByString:@","];
    
    
    
    return [array objectAtIndex:0];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        return 190;
    }else if (indexPath.section==2)
    {
        return 520;
    }else if (indexPath.section==1)
    {
        return 180;
    }else
    {
        return 340;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    UITableViewCell *cell;
    UITableViewCell * cell;
    
    switch (indexPath.section) {
        case 0:{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"MemberListNameCell" forIndexPath:indexPath];
            
            if (_listDataArry.count!=0)
            {
                
                UILabel * namelabel = (UILabel*)[cell viewWithTag:13110];
                UILabel * phonelabel = (UILabel*)[cell viewWithTag:13111];
                UILabel * addresslabel = (UILabel*)[cell viewWithTag:13112];
                UILabel * beizhu = (UILabel*)[cell viewWithTag:13113];
                
                namelabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0]valueForKey:@"name"]];
                phonelabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0]valueForKey:@"phone_number"]];
                addresslabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0]valueForKey:@"consignee_address"]];
                beizhu.text = [self Nallstring:[[_listDataArry objectAtIndex:0]valueForKey:@"note"]];
            }
            
        }
            break;
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell2" forIndexPath:indexPath];
            
            LYUITextField * shengaolabel     = (LYUITextField*)[cell viewWithTag:14110];
            LYUITextField * tizhonglabel     = (LYUITextField*)[cell viewWithTag:14111];
            LYUITextField * lingweilabel     = (LYUITextField*)[cell viewWithTag:14112];
            LYUITextField * jiankuanlabel    = (LYUITextField*)[cell viewWithTag:14113];
            LYUITextField * zuoxiuclabel     = (LYUITextField*)[cell viewWithTag:14114];
            LYUITextField * youxiuclabel     = (LYUITextField*)[cell viewWithTag:14115];
            LYUITextField * houyiclabel      = (LYUITextField*)[cell viewWithTag:14116];
            LYUITextField * qianyiclabel     = (LYUITextField*)[cell viewWithTag:14117];
            LYUITextField * qianxklabel      = (LYUITextField*)[cell viewWithTag:14118];
            LYUITextField * houbeiklabel     = (LYUITextField*)[cell viewWithTag:14119];
            LYUITextField * tixinglabel      = (LYUITextField*)[cell viewWithTag:14120];
            LYUITextField * zhanzilabel      = (LYUITextField*)[cell viewWithTag:14121];
            LYUITextField * xiongweiltlabel  = (LYUITextField*)[cell viewWithTag:14122];
            LYUITextField * xiongweicylabel  = (LYUITextField*)[cell viewWithTag:14123];
            LYUITextField * yaoweiltlabel    = (LYUITextField*)[cell viewWithTag:14124];
            LYUITextField * yaoweicylabel    = (LYUITextField*)[cell viewWithTag:14125];
            LYUITextField * xiabailtlabel    = (LYUITextField*)[cell viewWithTag:14126];
            LYUITextField * xiabaicylabel    = (LYUITextField*)[cell viewWithTag:14127];
            LYUITextField * xiufeiltlabel    = (LYUITextField*)[cell viewWithTag:14128];
            LYUITextField * xiufeicylabel    = (LYUITextField*)[cell viewWithTag:14129];
            LYUITextField * zuoxiukoultlabel = (LYUITextField*)[cell viewWithTag:14130];
            LYUITextField * zouxiukoucylabel = (LYUITextField*)[cell viewWithTag:14131];
            LYUITextField * youxiukltlabel   = (LYUITextField*)[cell viewWithTag:14132];
            LYUITextField * youxiukcylabel   = (LYUITextField*)[cell viewWithTag:14133];
            LYUITextField * jianbulabel   = (LYUITextField*)[cell viewWithTag:14134];
            LYUITextField * fubulabel   = (LYUITextField*)[cell viewWithTag:14135];
            
            shengaolabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"height"]];
            tizhonglabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"weight"]];
            lingweilabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"collar_opening"]];
            jiankuanlabel.text =[self Nallstring: [[_listDataArry objectAtIndex:0] objectForKey:@"should_width"]];
            zuoxiuclabel.text= [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"left_sleeve"]];
            youxiuclabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"right_sleeve"]];
            houyiclabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"back_length"]];
            qianyiclabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"front_length"]];
            qianxklabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"chest"]];
            houbeiklabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"back"]];
            
            xiongweiltlabel.text =[self Nallstring: [[_listDataArry objectAtIndex:0] objectForKey:@"chest_width"]];
            xiongweicylabel.text =[self Nallstring: [[_listDataArry objectAtIndex:0] objectForKey:@"processed_chest_width"]];
            yaoweiltlabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"middle_waisted"]];
            yaoweicylabel.text =[self Nallstring: [[_listDataArry objectAtIndex:0] objectForKey:@"processed_middle_waisted"]];
            xiabailtlabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"swing_around"]];
            xiabaicylabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"processed_swing_around"]];
            xiufeiltlabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"arm_width"]];
            xiufeicylabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"processed_arm_width"]];
            zuoxiukoultlabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"left_wrist_width"]];
            zouxiukoucylabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"processed_left_wrist_width"]];
            youxiukltlabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"right_wrist_width"]];
            youxiukcylabel.text = [self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"processed_right_wrist_width"]];
            
            
            jianbulabel.text = [MemberType meberType:[self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"shoulder"]] type:@"shoulder"];
            fubulabel.text = [MemberType meberType:[self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"abdomen"]] type:@"abdomen"];
            tixinglabel.text = [MemberType meberType:[self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"body_shape"]] type:@"body_shape"];
            zhanzilabel.text = [MemberType meberType:[self Nallstring:[[_listDataArry objectAtIndex:0] objectForKey:@"station_layout"]] type:@"station_layout"];
            
        }
            break;
        case 1:{
            
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell3" forIndexPath:indexPath];
            LYUIImageView *imageveiw = (LYUIImageView *)[cell viewWithTag:99910];
            [imageveiw viewinit];
            imageveiw.image = nil;
            imageveiw.iamgeShow = NO;
            [imageveiw setImage:[UIImage imageNamed:@"add5"]];
            imageveiw.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap)];
            [imageveiw addGestureRecognizer:tapGesture];
            
            LYUIImageView *imageveiw1 = (LYUIImageView *)[cell viewWithTag:99911];
            imageveiw1.userInteractionEnabled = YES;
            imageveiw1.image = nil;
            imageveiw1.iamgeShow = NO;
            [imageveiw1 setImage:[UIImage imageNamed:@"add5"]];
            UITapGestureRecognizer*tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap1)];
            [imageveiw1 addGestureRecognizer:tapGesture1];
            [imageveiw1 viewinit];
            
            LYUIImageView *imageveiw2 = (LYUIImageView *)[cell viewWithTag:99912];
            imageveiw2.userInteractionEnabled = YES;
            imageveiw2.image = nil;
            imageveiw2.iamgeShow = NO;
            [imageveiw2 setImage:[UIImage imageNamed:@"add5"]];
            UITapGestureRecognizer*tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap2)];
            [imageveiw2 addGestureRecognizer:tapGesture2];
            [imageveiw2 viewinit];
            
            for (int i = 0; i<_imageNameArry.count; i++)
            {
                
                if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
                {
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];   // 保存文件的名称
                    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
                    imageveiw.image = img;
                    
                    NSString * namestr = [NSString stringWithFormat:@"%@memberUpload/%@/%@",imageHTTPUrl,[[_listDataArry objectAtIndex:0]valueForKey:@"id"],[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                    
                    [imageveiw sd_setImageWithURL:[NSURL URLWithString:namestr]
                     
                                 placeholderImage:img options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     NSLog(@"---------------%lu--%lu",(long)receivedSize,(long)expectedSize);
                                     
                                 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                     
                                     if (img!=nil) {
                                         
                                         [_imageDic addEntriesFromDictionary:@{@"image":img}];
                                         
                                     }else {
                                         
                                         if (image!=nil)
                                         {
                                             [_imageDic addEntriesFromDictionary:@{@"image":image}];
                                         }
                                     }
                                     
                                     
                                     
                                 }];
                    
                    
                    
                    
                }
                if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"2"]) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];   // 保存文件的名称
                    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
                    imageveiw1.image = img;
                    
                    NSString * namestr = [NSString stringWithFormat:@"%@memberUpload/%@/%@",imageHTTPUrl,[[_listDataArry objectAtIndex:0]valueForKey:@"id"],[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                    
                    [imageveiw1 sd_setImageWithURL:[NSURL URLWithString:namestr]
                     
                                  placeholderImage:img options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      NSLog(@"---------------%lu--%lu",(long)receivedSize,(long)expectedSize);
                                      
                                  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      
                                      
                                      if (img!=nil) {
                                          
                                          [_imageDic addEntriesFromDictionary:@{@"image1":img}];
                                          
                                      }else {
                                          
                                          if (image!=nil)
                                          {
                                              [_imageDic addEntriesFromDictionary:@{@"image1":image}];
                                          }
                                      }
                                      
                                  }];
                    
                    
                }
                if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"3"]) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];   // 保存文件的名称
                    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
                    imageveiw2.image = img;
                    
                    
                    NSString * namestr = [NSString stringWithFormat:@"%@memberUpload/%@/%@",imageHTTPUrl,[[_listDataArry objectAtIndex:0]valueForKey:@"id"],[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                    
                    [imageveiw2 sd_setImageWithURL:[NSURL URLWithString:namestr]
                     
                                  placeholderImage:img options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      NSLog(@"---------------%lu--%lu",(long)receivedSize,(long)expectedSize);
                                      
                                  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      
                                      if (img!=nil) {
                                          
                                          [_imageDic addEntriesFromDictionary:@{@"image2":img}];
                                          
                                      }else {
                                          
                                          if (image!=nil)
                                          {
                                              [_imageDic addEntriesFromDictionary:@{@"image2":image}];
                                          }
                                      }
                                  }];
                }
                
            }
            
        }
            
            break;
        case 3:
            //            cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell4" forIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(NSString *)Nallstring:(id)str {
    
    
    if ([str isEqual:[NSNull null]]||[str isEqual:@"<null>"])
    {
        return @"";
        
    }else
    {
        
        return str;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section==2) {
        
        
        
    }
    
}

-(void)imageTap
{
    [self imgashowView:0];
}

-(void)imageTap1
{
    [self imgashowView:1];
}

-(void)imageTap2
{
    [self imgashowView:2];
}

-(void)imgashowView:(int)Num
{
    
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    self.photos = photos;
    UIImageView *imageveiw = (UIImageView *)[self.view viewWithTag:99910];
    UIImageView *imageveiw1 = (UIImageView *)[self.view viewWithTag:99911];
    UIImageView *imageveiw2 = (UIImageView *)[self.view viewWithTag:99912];
    
    
    
    for (int i = 0; i<_imageNameArry.count; i++)
    {
        
        if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
        {
            
            [photos addObject:[MWPhoto photoWithImage:imageveiw.image]];
            
        }
        if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"2"]) {
            
            [photos addObject:[MWPhoto photoWithImage:imageveiw1.image]];
            
        }
        if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"3"]) {
            
            [photos addObject:[MWPhoto photoWithImage:imageveiw2.image]];
            
        }
        
    }
    
    
    if (_imageNameArry.count==0)
    {
        return;
    }
    
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows =  NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    browser.autoPlayOnAppear = YES;
    [browser setCurrentPhotoIndex:Num];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}



#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    
    [photoBrowser dismissViewControllerAnimated:YES completion:^{
        
        self.tabBarController.tabBar.hidden = YES;
        
    }];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
