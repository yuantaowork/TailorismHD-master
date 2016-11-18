//
//  OrderHomeController.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/30.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "OrderHomeController.h"
#import "TabsButton.h"
#import "AlertTabelView.h"
#import "PhotoShowType.h"
#import "AdditionalInfoController.h"
#import "MemberType.h"
#import "ClothingModel.h"
@interface OrderHomeController ()<UITextFieldDelegate,AlertTabelViewDelegate,LYTextFieldDelegate,MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIView *fontView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet LYUITextField *mainTextField;
@property (weak, nonatomic) IBOutlet LYUITextField *fontTextField;
@property (weak, nonatomic) IBOutlet LYUITextField *fonColorTextfield;
@property (weak, nonatomic) IBOutlet LYUITextField *positionTextField;

@property (strong, nonatomic) NSMutableArray *orderTypeArray1;
@property (strong, nonatomic) NSMutableArray *orderTypeArray2;
@property (strong, nonatomic) NSMutableArray *orderTypeArray3;
@property (strong, nonatomic) NSMutableArray *orderTypeArray4;
@property (strong, nonatomic) NSMutableArray *orderTypeArray5;

@property (strong, nonatomic) NSMutableArray *fontTextArray1;
@property (strong, nonatomic) NSMutableArray *fontTextArray2;
@property (strong, nonatomic) NSMutableArray *fontTextArray3;
@property (strong, nonatomic) NSMutableArray *fontTextArray4;
@property (strong, nonatomic) NSMutableArray *fontTextArray5;

@property (nonatomic, strong) NSMutableArray *photos;

@property (strong, nonatomic)UIImageView * mianlimageView;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *mianLiaoPhotArray;

@property (strong, nonatomic) NSArray *textFieldtagArray;

@property NSInteger  selectedButtonTag; ///参数按钮排，选中标示
@property NSInteger  orderTabsBtnTag; ///参数按钮排，选中标示
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property  int phontCout;
@end

@implementation OrderHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(viewinit) withObject:nil afterDelay:1.0f];
    
// 读取Documents目录代码
//    NSArray *pathsDocuments=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *pathDocuments=[pathsDocuments objectAtIndex:0];
//    NSLog(@"%@",pathDocuments);
//    [self showFiles:[NSString stringWithFormat:@"%@/着装顾问/030/",pathDocuments]];
    
    
    //监听键盘，键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardwill:)
                                                name:UIKeyboardWillShowNotification object:nil];
    
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keybaordhide:)
                                                name:UIKeyboardWillHideNotification object:nil];
    
    
    
    NSMutableArray * arry = [[NSMutableArray alloc]init];
    NSArray * array = [LYFmdbTool queryData3:@"SELECT * ,substr(code,4,3) AS a FROM fabricListdb WHERE is_delete = \"0\"  ORDER BY a"];
    
    for (int i =0; i<[array count]; i++)
    {
        if ([[[array objectAtIndex:i]valueForKey:@"status"]isEqualToString:@"1"]) {
            
            [arry addObject:[[array objectAtIndex:i]valueForKey:@"code"]];
        }
        
    }
    
    _mianLiaoPhotArray = arry;
}

-(void)keyboardwill:(NSNotification *)sender{
    

    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;

    
       self.view.frame = CGRectMake(0,-100, width, height);
    [UIView commitAnimations];

}

//当键盘隐藏时候，视图回到原定
-(void)keybaordhide:(NSNotification *)sender
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//-(void)showFiles:(NSString *)path;{
//    // 1.判断文件还是目录
//    NSFileManager * fileManger = [NSFileManager defaultManager];
//    BOOL isDir = NO;
//    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
//    if (isExist) {
//        // 2. 判断是不是目录
//        if (isDir) {
//            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
//            
//            
//            NSString * subPath = nil;
//            for (NSString * str in dirArray) {
//                subPath  = [path stringByAppendingPathComponent:str];
//                BOOL issubDir = NO;
//                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
//                [self showFiles:subPath];
//            }
//            
//            
//        }else{
//            NSLog(@"%@",path);
//        }
//    }else{
//        NSLog(@"你打印的是目录或者不存在");
//    }
//}

-(void)viewinit {

    
    _titleArray = @[@"面料",@"领型",@"袖型",@"门襟",@"白领白袖",@"胸袋",
                    @"合身度",@"活插片",@"绣字",@"下摆",@"数量",@"备注",];
    
    _textFieldtagArray = @[@"620100",@"620101",@"620102",@"620103",@"620114",@"620114",
                    @"620104",@"620105",@"0",@"620113",@"609312",@"0",];
    
    _orderTypeArray1 = [[NSMutableArray alloc]init];
    _orderTypeArray2 = [[NSMutableArray alloc]init];
    _orderTypeArray3 = [[NSMutableArray alloc]init];
    _orderTypeArray4 = [[NSMutableArray alloc]init];
    _orderTypeArray5 = [[NSMutableArray alloc]init];
    
    
    _fontTextArray1 = [[NSMutableArray alloc]init];
    _fontTextArray2 = [[NSMutableArray alloc]init];
    _fontTextArray3 = [[NSMutableArray alloc]init];
    _fontTextArray4 = [[NSMutableArray alloc]init];
    _fontTextArray5 = [[NSMutableArray alloc]init];
    
    for (int i =0; i<12; i++){
        
        [_orderTypeArray1 addObject:@""];
        [_orderTypeArray2 addObject:@""];
        [_orderTypeArray3 addObject:@""];
        [_orderTypeArray4 addObject:@""];
        [_orderTypeArray5 addObject:@""];
        
    }
    
    for (int i =0; i<3; i++) {
        
        [_fontTextArray1 addObject:@""];
        [_fontTextArray2 addObject:@""];
        [_fontTextArray3 addObject:@""];
        [_fontTextArray4 addObject:@""];
        [_fontTextArray5 addObject:@""];
    }
    
    
    [self switchButton:10800];
    _orderTabsBtnTag =100010;
     TabsButton * button = (TabsButton *)[self.view viewWithTag:100010];
    button.selected = YES;
    _mainTextField.LY_delegate =self;
    _mainTextField.delegate =self;
    
    
    _fontTextField.delegate = self;
    _fontTextField.rightViewMode = UITextFieldViewModeAlways;
    _fonColorTextfield.delegate = self;
    _fonColorTextfield.rightViewMode = UITextFieldViewModeAlways;
    _positionTextField.delegate = self;
    _positionTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
 
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"OrderWindow" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([super class])];
    }
    return self;
}

/**
 *  订单选项组方法
 *
 *  @param sender 按钮
 */
- (IBAction)orderTabsBtn:(TabsButton *)sender {
    
    if (sender.tag-_orderTabsBtnTag >1) {
        
        return;
    }
    if (_orderTabsBtnTag<sender.tag) {
        
        
        if ([[[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:0]isEqualToString:@""]) {
            
            [SVProgressHUD showInfoWithStatus:@"面料为必填选项"];
            return;
        }
        if ([[[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:6]isEqualToString:@""]) {
            
            [SVProgressHUD showInfoWithStatus:@"合身度为必填选项"];
            return;
        }
        
        if ([[[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:10]isEqualToString:@""]) {
            
            [SVProgressHUD showInfoWithStatus:@"数量为必填选项"];
            return;
        }

    }
    if (_selectedButtonTag==10808) {
        
        if (![[[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:8]isEqualToString:@""]) {
            
            
            if ([_fontTextField.text isEqualToString:@""]) {
                
                [SVProgressHUD showInfoWithStatus:@"输入绣字内容后字体为必选项"];
                return;
            }
            
            if ([_fonColorTextfield.text isEqualToString:@""]) {
                
                [SVProgressHUD showInfoWithStatus:@"输入绣字内容后颜色为必选项"];
                return;
            }
            
            if ([_positionTextField.text isEqualToString:@""]) {
                
                [SVProgressHUD showInfoWithStatus:@"输入绣字内容后位置为必选项"];
                return;
            }
        }
        
    }
    
    
    for (int selectNum=100010;selectNum<100015 ; selectNum++) {
        
        TabsButton * button = (TabsButton *)[self.view viewWithTag:selectNum];

        if (selectNum==sender.tag) {
            
            sender.selected = YES;
        }else {
            button.selected = NO;
        }
        
    }
    
    for (int selectNum=10800;selectNum<10812 ; selectNum++) {
        
        TabsButton * button = (TabsButton *)[self.view viewWithTag:selectNum];
        if (selectNum==10800) {
            
            button.selected = YES;
            
        }else {
            button.selected = NO;
            
        }

        
    }
    _orderTabsBtnTag = sender.tag;
    _phontCout = 0;
    [self switchButton:10800];
    [self fillText];
    
}


/**
 *  定制选项组按钮方法
 *
 *  @param sender 按钮
 */
- (IBAction)tabsbutton:(TabsButton *)sender {
    

    
    [self switchButton:sender.tag];
    
}

/**
 *  切换选项方法
 *
 *  @param sender 按钮
 */
- (IBAction)nextBtn:(id)sender {
    
    
    
    
    if (_selectedButtonTag==10811) {
        
        [self switchButton:10800];
        return;
        
    }
    [self switchButton:_selectedButtonTag+1];
    
    
}

/**
 *  点击与切换方法调用封装
 *
 *  @param btnTag 选中按钮Tag值
 */
-(void)switchButton:(NSUInteger)btnTag {
   
 
    if (_selectedButtonTag==10808) {
        
        if (![[[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:8]isEqualToString:@""]) {

            
            if ([[[self switchFontTextArrayNum:_orderTabsBtnTag]objectAtIndex:0] isEqualToString:@""]) {
                
                [SVProgressHUD showInfoWithStatus:@"输入绣字内容后字体为必选项"];
                return;
            }
            
            if ([[[self switchFontTextArrayNum:_orderTabsBtnTag]objectAtIndex:1] isEqualToString:@""]) {
                
                [SVProgressHUD showInfoWithStatus:@"输入绣字内容后颜色为必选项"];
                return;
            }
            
            if ([[[self switchFontTextArrayNum:_orderTabsBtnTag]objectAtIndex:2] isEqualToString:@""]) {
                
                [SVProgressHUD showInfoWithStatus:@"输入绣字内容后位置为必选项"];
                return;
            }
        }
        
    }
    
    [_mainTextField resignFirstResponder];
    
    _mainTextField.tag = [[_textFieldtagArray objectAtIndex:btnTag-10800]integerValue];
    
    if (btnTag == 10808) {
        
        _fontView.hidden = NO;
        
        
    }else {
        
         _fontView.hidden = YES;
    }
    
    
    if (_selectedButtonTag==0) {
        
        _selectedButtonTag=10800;
        _orderTabsBtnTag =100010;
    }
    
    if (btnTag == 10808 || btnTag == 10811) {
        
        _mainTextField.rightViewMode = UITextBorderStyleNone;
        
    }else {
        
        _mainTextField.rightViewMode = UITextFieldViewModeAlways;
        
    }

    
    [self resetType:btnTag];


    
    //用于展示输入框内内容
    _selectedButtonTag = btnTag;
    _titleLab.text = [_titleArray objectAtIndex:btnTag-10800];
    _mainTextField.text = [[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:_selectedButtonTag-10800];
    _fontTextField.text = [[self switchFontTextArrayNum:_orderTabsBtnTag]objectAtIndex:0];
    _fonColorTextfield.text = [[self switchFontTextArrayNum:_orderTabsBtnTag]objectAtIndex:1];
    _positionTextField.text = [[self switchFontTextArrayNum:_orderTabsBtnTag]objectAtIndex:2];
    [self fillText];
    
    if ([_titleLab.text isEqualToString:@"面料"]) {
        
      
        
        if ([[[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:_selectedButtonTag-10800]isEqualToString:@""]) {
            
              [self mianliaoShowPhoto];
            
        }else {
            
            [self mianLiaoScrollViewGo:@"" type:[[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:_selectedButtonTag-10800]];
        }
        
    }else {
        
        [self photoshow:_titleLab.text];
    }
    
   [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame)*0, 0) animated:NO];
 
}

-(void)mianliaoShowPhoto {
    
    
    [SVProgressHUD show];
    for (UIImageView * imageView in [_scrollView subviews]) {
        
        
        [imageView removeFromSuperview];
      
    }
    
    
    
    NSArray *pathsDocuments=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *pathDocuments=[pathsDocuments objectAtIndex:0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString * photoStr =[NSString stringWithFormat:@"%@/着装顾问图片/%@/%@-1.jpg",pathDocuments,
                              [_mianLiaoPhotArray objectAtIndex:_phontCout],[_mianLiaoPhotArray objectAtIndex:_phontCout]];
        NSData *data = [NSData dataWithContentsOfFile:photoStr];
        UIImage *img = [UIImage imageWithData:data];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame)*0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        
           //生成缩略图
        
  
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
 
      
        [imageView setImage: [self thumbnailWithImageWithoutScale:img size:CGSizeMake(img.size.width/10, img.size.height/10)]];
            
            UITapGestureRecognizer*tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(miaolimageTap)];
            [imageView addGestureRecognizer:tapGesture2];
            [_scrollView addSubview:imageView];
            
            _mainTextField.text = [_mianLiaoPhotArray objectAtIndex:_phontCout];
            TabsButton * button = (TabsButton *)[self.view viewWithTag:_selectedButtonTag];
            button.parameterLab.text = [_mianLiaoPhotArray objectAtIndex:_phontCout];
            [self addtextFieldData];
            
            UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
           UISwipeGestureRecognizer  * rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
            
            leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
            rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
            
            [imageView addGestureRecognizer:leftSwipeGestureRecognizer];
            [imageView addGestureRecognizer:rightSwipeGestureRecognizer];
            
        });
    });
    _scrollView.contentSize = CGSizeMake (CGRectGetWidth(_scrollView.frame),0);
     [SVProgressHUD dismiss];
}

-(void)miaolimageTap {
    
    [SVProgressHUD showWithStatus:@"正在加载细节图,图片像素较大请耐心等待!"];
    
    self.photos = [[NSMutableArray alloc]init];
    NSArray *pathsDocuments=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *pathDocuments=[pathsDocuments objectAtIndex:0];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        
        NSString * photoStr =[NSString stringWithFormat:@"%@/着装顾问图片/%@/%@-1.jpg",pathDocuments,
                              [_mianLiaoPhotArray objectAtIndex:_phontCout],[_mianLiaoPhotArray objectAtIndex:_phontCout]];
        
        NSString * photoStr1 =[NSString stringWithFormat:@"%@/着装顾问图片/%@/%@-2.jpg",pathDocuments,
                               [_mianLiaoPhotArray objectAtIndex:_phontCout],[_mianLiaoPhotArray objectAtIndex:_phontCout]];
        
        NSString * photoStr2 =[NSString stringWithFormat:@"%@/着装顾问图片/%@/%@-3.jpg",pathDocuments,
                               [_mianLiaoPhotArray objectAtIndex:_phontCout],[_mianLiaoPhotArray objectAtIndex:_phontCout]];
        
        NSData *data = [NSData dataWithContentsOfFile:photoStr];
        UIImage *img = [UIImage imageWithData:data];
        
        NSData *data1 = [NSData dataWithContentsOfFile:photoStr1];
        UIImage *img1 = [UIImage imageWithData:data1];
        
        
        NSData *data2 = [NSData dataWithContentsOfFile:photoStr2];
        UIImage *img2 = [UIImage imageWithData:data2];

        [self.photos addObject:[MWPhoto photoWithImage:[self thumbnailWithImageWithoutScale:img size:CGSizeMake(img.size.width/5, img.size.height/5)]]];
        
        [self.photos addObject:[MWPhoto photoWithImage:[self thumbnailWithImageWithoutScale:img1 size:CGSizeMake(img1.size.width/5, img1.size.height/5)]]];
        
        [self.photos addObject:[MWPhoto photoWithImage:[self thumbnailWithImageWithoutScale:img2 size:CGSizeMake(img2.size.width/5, img2.size.height/5)]]];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [SVProgressHUD dismiss];
            [self imageTap];
        });
    });
    
    
 
}


-(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }
        
        else{
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}


-(void)handleSwipes:(UISwipeGestureRecognizer*)sender {
    
    if (_selectedButtonTag!=10800) {
        return;
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        
        if (_phontCout ==0) {
            _phontCout =1;
        }
        _phontCout =_phontCout-1;
        
        _mianlimageView.image = nil;
        
        
    }else {
        
        if (_phontCout ==_mianLiaoPhotArray.count-1) {
            _phontCout =-1;
        }
        _phontCout =_phontCout+1;
        _mianlimageView.image = nil;
    }
    
    [self  mianliaoShowPhoto];
}


-(void)resetType:(NSInteger)btnTag {
    
    //用于重置状态
    for (int selectNum=10800;selectNum<10812 ; selectNum++) {
        
        TabsButton * button = (TabsButton *)[self.view viewWithTag:selectNum];
        TabsButton * button1 = (TabsButton *)[self.view viewWithTag:btnTag];
        if (selectNum==btnTag) {
            
            button1.selected = YES;
            
        }else {
            button.selected = NO;
            
        }
        
        button.parameterLab.text = [[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:selectNum-10800];
        
    }
}

-(void)fillText {
    
    for (int selectNum=10800;selectNum<10812 ; selectNum++) {
        
        TabsButton * button = (TabsButton *)[self.view viewWithTag:selectNum];
        
        button.parameterLab.text = [[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:selectNum-10800];
        
    }
}
/**
 *  判断属于哪个订单的数据数组
 *
 *  @param Num 选中的Tag值
 *
 *  @return 返回选中数组
 */
-(NSMutableArray *)switchArrayNum:(NSInteger)Num {
    
    switch (Num) {
        case 100010:
            
            return _orderTypeArray1;
            
            break;
        case 100011:
            
            return _orderTypeArray2;
            
            break;
        case 100012:
            
            return _orderTypeArray3;
            
            break;
        case 100013:
            
            return _orderTypeArray4;
            
            break;
        case 100014:
            
            return _orderTypeArray5;
            
            break;
            
        default:
            return _orderTypeArray1;
            break;
    }
    
}

-(NSMutableArray *)switchFontTextArrayNum:(NSInteger)Num {
    
    switch (Num) {
        case 100010:
            
            return _fontTextArray1;
            
            break;
        case 100011:
            
            return _fontTextArray2;
            
            break;
        case 100012:
            
            return _fontTextArray3;
            
            break;
        case 100013:
            
            return _fontTextArray4;
            
            break;
        case 100014:
            
            return _fontTextArray5;
            
            break;
            
        default:
            return _fontTextArray1;
            break;
    }
    
}


///Layout 点击输入框方法代理/开始编辑状态
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.rightViewMode == UITextBorderStyleNone) {

        _mainTextField.LY_delegate =self;
        return YES;
        
    }else {
        
        [SVProgressHUD show];
        
//        [self performSelector:@selector(alertshow:) withObject:textField afterDelay:0.1f];
        
        [self textFieldright:textField];
        return NO;
        
    }
    
}

-(void)alertshow:(UITextField *)textField {
    
    [self textFieldright:textField];
    
}


-(void)textFieldright:(UITextField *)textField {
    
    
    if (textField.tag == 620107||textField.tag == 620118||textField.tag == 620119) {
        
        if ([[[self switchArrayNum:_orderTabsBtnTag]objectAtIndex:8]isEqualToString:@""]) {
            
            [SVProgressHUD showInfoWithStatus:@"请先输入绣字内容"];
            return;
            
        }
    }
    
   
    AlertTabelView * viewcontroller = [[AlertTabelView alloc]init];
    viewcontroller.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    viewcontroller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [viewcontroller setTagID:textField.tag];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            viewcontroller.view.backgroundColor = [UIColor clearColor];
            viewcontroller.delegate =self;
            [self presentViewController:viewcontroller animated:YES completion:^{
                
                viewcontroller.view.backgroundColor = [UIColor clearColor];
                 [SVProgressHUD dismiss];
                
            }];
            
            
        });
        
    });

    
  
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_mainTextField resignFirstResponder];
}

-(void)alertTabel:(UITextField *)textFild text:(NSString *)text {
    
    if (textFild.tag == 620107) {
        
         [[self switchFontTextArrayNum:_orderTabsBtnTag] replaceObjectAtIndex:0 withObject:_fontTextField.text];
        return;
    }
    
    if (textFild.tag == 620118) {
        
        [[self switchFontTextArrayNum:_orderTabsBtnTag] replaceObjectAtIndex:1 withObject:_fonColorTextfield.text];
        return;
    }
    
    if (textFild.tag == 620119) {
        
        [[self switchFontTextArrayNum:_orderTabsBtnTag] replaceObjectAtIndex:2 withObject:_positionTextField.text];
        return;
    }
    
    NSLog(@"%@",text);
    TabsButton * button = (TabsButton *)[self.view viewWithTag:_selectedButtonTag];
    button.parameterLab.text = text;
    
    [self addtextFieldData];
    
    if ([button.titleLabel.text isEqualToString:@"面料"]) {
        
        [self mianLiaoScrollViewGo:button.titleLabel.text type:text];
    }else {
        
        [self scrollViewGo:button.titleLabel.text type:text];
    }
    
}


-(void)LYTextFieldDeleteBackward:(UITextField *)textField {
    
    TabsButton * button = (TabsButton *)[self.view viewWithTag:_selectedButtonTag];
    button.parameterLab.text = _mainTextField.text;
    [self addtextFieldData];
}

-(void)addtextFieldData {
    
     [[self switchArrayNum:_orderTabsBtnTag] replaceObjectAtIndex:_selectedButtonTag-10800 withObject:_mainTextField.text];
    
}


-(void)photoshow:(NSString *)typeStr {
    
    [SVProgressHUD show];
    for (UIImageView * imageView in [_scrollView subviews]) {
        
        [imageView removeFromSuperview];
    }
    
    self.photos = [[NSMutableArray alloc]init];
    if ([PhotoShowType photoShowType:typeStr] ==nil) {
        
         [SVProgressHUD dismiss];
        return;
    }
    
    NSArray * array = [PhotoShowType photoShowType:typeStr];
    NSMutableArray *imageArrary = [[NSMutableArray alloc]init];
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        for (int imageNum=0; imageNum<array.count; imageNum++) {
            
            [imageArrary  addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[array objectAtIndex:imageNum]]]];
            [self.photos addObject:[MWPhoto photoWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[array objectAtIndex:imageNum]]]]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            for (int imageNum=0; imageNum<array.count; imageNum++) {
                
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame)*imageNum, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
//                imageView.backgroundColor = [UIColor orangeColor];
                imageView.userInteractionEnabled = YES;
                [imageView setImage:[imageArrary objectAtIndex:imageNum]];
                
                
                
                UITapGestureRecognizer*tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap)];
                [imageView addGestureRecognizer:tapGesture2];
                [_scrollView addSubview:imageView];
                
            }
            
            
        });   
    });
    
     _scrollView.contentSize = CGSizeMake (CGRectGetWidth(_scrollView.frame)*array.count,0);
     [SVProgressHUD dismiss];
}

-(void)imageTap {
    
    
    
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
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    nc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:nc animated:YES completion:nil];

}

-(void)scrollViewGo:(NSString *)arryName type:(NSString *)typeStr {
    
   
    NSArray * array = [PhotoShowType photoShowType:arryName];
    
    for (int num = 0; num<array.count; num++) {
        
        if ([[array objectAtIndex:num]isEqualToString:[NSString stringWithFormat:@"%@.jpg",typeStr]]) {
            
            [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame)*num, 0) animated:YES];
        }
        
    }
    
}

-(void)mianLiaoScrollViewGo:(NSString *)arryName type:(NSString *)typeStr {
    
    
    for (int num = 0; num<_mianLiaoPhotArray.count; num++) {
        
        if ([[_mianLiaoPhotArray objectAtIndex:num]isEqualToString:typeStr]) {
            
            _phontCout = num;
            break;
        }
        
    }
    
    [self mianliaoShowPhoto];
}



- (IBAction)doneBtn:(UIButton *)sender {
    
    for (int num = 100010; num<100015; num ++) {
        
        
        NSArray * array =  [self switchArrayNum:num];
        
        
        BOOL textNull = NO;
        for (int aryConut = 0; aryConut<array.count; aryConut ++) {
            
                if (![[array objectAtIndex:aryConut]isEqualToString:@""]) {
                    
                    textNull = YES;
                    break;
                }
        }
        
        
        
        if (textNull == YES) {
            
            if ([[array objectAtIndex:0]isEqualToString:@""]) {
                
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"订单-%d 面料未选择!",num-100010+1]];
                return;
            }
            
            if ([[array objectAtIndex:6]isEqualToString:@""]) {
                
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"订单-%d 合身度未选择!",num-100010+1]];
                return;
            }
            
            if ([[array objectAtIndex:10]isEqualToString:@""]) {
                
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"订单-%d 数量未选择!",num-100010+1]];
                return;
            }
        }

    }
    
    NSMutableArray * dataArray = [[NSMutableArray alloc]init];
    for (int num = 100010; num<100015; num ++) {
        
        
        NSArray * array =  [self switchArrayNum:num];
        NSArray * fontarray =  [self switchFontTextArrayNum:num];
        
        for (int aryConut = 0; aryConut<array.count; aryConut ++) {
            
            if (![[array objectAtIndex:aryConut]isEqualToString:@""]) {
                
                [dataArray addObject:[self clothingModel:array fontarray:fontarray]];
                break;
            }
        }
        
        
    }
 
    NSLog(@"%@---封装好的数据",dataArray);

    AdditionalInfoController * additiView = [[AdditionalInfoController alloc]init];
    additiView.orderdataArry = dataArray;
    additiView.iamge_dic = _iamge_dic;
    [self.navigationController pushViewController:additiView animated:YES];
}

-(ClothingModel*)clothingModel:(NSArray *)array  fontarray:(NSArray *)fontarray{

    NSString * str = nil;
    if ([[array objectAtIndex:8]length]>0) {
        
        str = @"是";
    }else {
        
        str = @"否";
    }
    
    
    
    NSDictionary * dic = @{@"code":[array objectAtIndex:0],
                           @"collar_type":[MemberType orderType:[array objectAtIndex:1]],
                           @"sleeve_linging":[MemberType orderType:[array objectAtIndex:2]],
                           @"placket":[MemberType orderType:[array objectAtIndex:3]],
                           @"style":[MemberType orderType:[array objectAtIndex:6]],
                           @"live_insert":[MemberType orderType:[array objectAtIndex:7]],
                           @"embroidered_text":[array objectAtIndex:8],
                           @"embroidered_font":[fontarray objectAtIndex:0],
                           @"color":[fontarray objectAtIndex:1],
                           @"embroidered_position":[fontarray objectAtIndex:2],
                           @"hem":[MemberType orderType:[array objectAtIndex:9]],
                           @"number":[array objectAtIndex:10],
                           @"note":[array objectAtIndex:11],
                           @"white_collar":[MemberType orderType:[array objectAtIndex:4]],
                           @"white_sleeve":[MemberType orderType:[array objectAtIndex:4]],
                           @"packet":[self packet:[array objectAtIndex:5]],
                           @"embroidered":[MemberType orderType:str]
                           };
    
    ClothingModel * odermodel = [[ClothingModel alloc]init];
    odermodel = nil;
    odermodel = [ClothingModel mj_objectWithKeyValues:dic];
    
    return odermodel;
}

-(NSString *)packet:(NSString*)str
{
    if ([str isEqualToString:@"是"])
    {
        return @"1";
    }else
    {
        return @"4";
    }
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
