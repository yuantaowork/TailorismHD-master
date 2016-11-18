//
//  PaddingDataController.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/25.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "PaddingDataController.h"
#import "LineLabel.h"
#import "LYNumKeyboard.h"
#import "TabsButton.h"
#import "LYUIImageView.h"
#import "MemberAmount.h"
#import "AlertTabelView.h"
#import "MemberModel.h"
@interface PaddingDataController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate,AlertTabelViewDelegate,LYTextFieldDelegate>
@property (weak, nonatomic) IBOutlet LYUITextField *initialTextField;
@property (weak, nonatomic) IBOutlet LYUITextField *increaseTextField;

@property(strong,nonatomic)NSArray * defaultArry; ///第一个TextField Titel
@property(strong,nonatomic)NSArray * additionalArry;///第二个TextField Titel

@property (weak, nonatomic) IBOutlet UILabel *defaultTitle;
@property (weak, nonatomic) IBOutlet UILabel *additionalTitle;

@property(strong,nonatomic)NSMutableArray * initialDataArry;
@property(strong,nonatomic)NSMutableArray * finishedArry;

@property(weak,nonatomic) LYUIImageView *selectImageView;

@property NSInteger  selectedButtonTag; ///参数按钮排，选中标示

@property (weak, nonatomic) IBOutlet UIView *photoBgView;

@property NSInteger  shapeTypeButtonTag; ///参数按钮排，选中标示

@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightButtonItem;

@property (weak, nonatomic) IBOutlet UIButton *sizeConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *additionBtn;
@property (weak, nonatomic) IBOutlet UIButton *subductionBtn;

@property (strong ,nonatomic)NSArray * imageNameArry;

@end


static BOOL selectField;///选中的TextField 判断

@implementation PaddingDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self performSelector:@selector(viewinit) withObject:nil afterDelay:1.0f];
   
}

-(void)viewinit {
    
    _initialTextField.delegate = self;
    _increaseTextField.delegate = self;
    
    _initialTextField.layer.borderColor  =[[UIColor colorWithHex:@"6d87c3"]CGColor];
    _increaseTextField.layer.borderColor =[[UIColor grayColor]CGColor];
    
    _initialTextField.layer.borderWidth= 2.f;
    _increaseTextField.layer.borderWidth= 1.f;
    
 
    
    _defaultArry = @[@"身高",@"体重",@"领围",@"胸围-量体尺寸",@"腰围-量体尺寸",@"下摆-量体尺寸"
                     ,@"袖肥-量体尺寸",@"左袖口-量体尺寸",@"右袖口-量体尺寸",@"肩宽",@"左袖长",
                     @"后衣长",@"前胸宽",@"后背宽",@"体型",@"站姿",@"肩部",@"腹部",@"备注",@""];
    
    _additionalArry = @[@"",@"",@"",@"胸围-成衣尺寸",@"腰围-成衣尺寸",@"下摆-成衣尺寸"
                        ,@"袖肥-成衣尺寸",@"左袖口-成衣尺寸",@"右袖口-成衣尺寸",@"",@"右袖长",
                        @"前衣长",@"",@"",@"",@"",@"",@"",@"",@""];
    
    _initialDataArry = [[NSMutableArray alloc]init];
    _finishedArry = [[NSMutableArray alloc]init];
    
    
    _initialDataArry = [MemberAmount memberAmount:_memberDic];
    _finishedArry = [MemberAmount memberAmountZoom:_memberDic];
    
    
    for (int i=0;i< _initialDataArry.count; i++) {
        
        TabsButton * button = (TabsButton*)[self.view viewWithTag:i+7000];
        
        NSLog(@"%ld---开始",(long)button.tag);
        if ([[_initialDataArry objectAtIndex:i]length]!=0)
        {
            NSLog(@"%@",[_initialDataArry objectAtIndex:i]);
            
            if (![[_initialDataArry objectAtIndex:i]isEqualToString:@"<null>"]) {
                
                button.parameterLab.text = [_initialDataArry objectAtIndex:i];
                NSLog(@"%------ld",(long)button.tag);
            }
            
            
            
        }
    }

    _initialTextField.text = [_initialDataArry objectAtIndex:0];
    
    selectField = YES;
    
    _selectedButtonTag =7000;
    [self assignment:7000];
    
    
    LYUIImageView * imageview = (LYUIImageView*)[self.view viewWithTag:100];
    LYUIImageView * imageview1 = (LYUIImageView*)[self.view viewWithTag:101];
    LYUIImageView * imageview2 = (LYUIImageView*)[self.view viewWithTag:102];
    
    [imageview viewinit];
    [imageview1 viewinit];
    [imageview2 viewinit];
    
    _photoBgView.hidden = YES;
    
    
    TabsButton * superbutton = (TabsButton *)[self.view viewWithTag:50502];
    superbutton.selected = YES;
    [self performSelector:@selector(getPhoto) withObject:nil/*可传任意类型参数*/ afterDelay:1];
}

-(void)getPhoto
{
    
    LYUIImageView * imageview = (LYUIImageView*)[self.view viewWithTag:100];
    LYUIImageView * imageview1 = (LYUIImageView*)[self.view viewWithTag:101];
    LYUIImageView * imageview2 = (LYUIImageView*)[self.view viewWithTag:102];
    
    
    if (![[_imagedic valueForKey:@"image"]isEqual:[NSString string]]) {
        
        if([[_imagedic allKeys] containsObject:@"image"])
        {
            imageview.image = [_imagedic valueForKey:@"image"];
            imageview.clipsToBounds = YES;
            imageview.iamgeShow  =YES;
        }
        
        
    }
    if (![[_imagedic valueForKey:@"image1"]isEqual:[NSString string]]) {
        
        if([[_imagedic allKeys] containsObject:@"image1"])
        {
            imageview1.image = [_imagedic valueForKey:@"image1"];
            imageview1.clipsToBounds = YES;
            imageview1.iamgeShow  =YES;
        }
        
        
    }
    
    if (![[_imagedic valueForKey:@"image2"]isEqual:[NSString string]]) {
        
        if([[_imagedic allKeys] containsObject:@"image2"])
        {
            imageview2.image = [_imagedic valueForKey:@"image2"];
            imageview2.clipsToBounds = YES;
            imageview2.iamgeShow  =YES;
        }
        
    }
    
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
        self = [[UIStoryboard storyboardWithName:@"Member" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([super class])];
    }
    return self;
}


///键盘按钮方法
- (IBAction)numKeyBoard:(UIButton*)btn {
    
    if (_selectedButtonTag==7014||_selectedButtonTag==7015||_selectedButtonTag==7016||_selectedButtonTag==7017||_selectedButtonTag==7018) {
        
        
        return;
    }
    
    UITextField  *textfield = [[UITextField alloc]init];
    if (selectField) {
        
        textfield =_initialTextField;
        
    }else{
        
        textfield =_increaseTextField;
    }
    
    
    if (btn.tag!=80010) {
        
        if ([textfield.text length]==3) {
            
            textfield.text =  [LYNumKeyboard inputContentRestriction:textfield btntag:80011].text;
        }
        
    }

    textfield.text =  [LYNumKeyboard inputContentRestriction:textfield btntag:btn.tag].text;
    
   
    TabsButton * button = (TabsButton*)[self.view viewWithTag:_selectedButtonTag];
    
    button.parameterLab.text = _initialTextField.text;
    

}

///Layout 点击输入框方法代理/开始编辑状态
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.rightViewMode == UITextFieldViewModeAlways) {
        
        [self textFieldright:textField]; 
    }
    
    if (textField != _initialTextField)
    {
        selectField = NO;
        
        _initialTextField.layer.borderColor=[[UIColor grayColor]CGColor];
        _increaseTextField.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
        
        _initialTextField.layer.borderWidth= 1.f;
        _increaseTextField.layer.borderWidth= 2.f;
    }else
    {
        _initialTextField.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
        _increaseTextField.layer.borderColor=[[UIColor grayColor]CGColor];
        selectField = YES;
        _initialTextField.layer.borderWidth= 2.f;
        _increaseTextField.layer.borderWidth= 1.f;
    }
    
    if (_selectedButtonTag==7018) {
        
        return YES;
        
    }else {
        
        return NO;
    }
    
    
    
}

- (IBAction)imageTap:(UITapGestureRecognizer *)sender {
    
    NSLog(@"%@,%@",NSStringFromCGRect(sender.view.frame),sender.view);
    
    
    _selectImageView = (LYUIImageView *)sender.view;
    
    if(_selectImageView.iamgeShow == NO){
        
        UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"选择照片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [self openCamera];
            
        }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self openPics];
            
        }];
        
        UIAlertAction *thridAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
        }];
        
        
        
        
        [alertCtr addAction:firstAction];
        [alertCtr addAction:secondAction];
        [alertCtr addAction:thridAction];
        
        
        [self presentViewController:alertCtr animated:YES completion:^{
            
        }];



    }else
    {
        
        LYUIImageView * imageview = (LYUIImageView*)[self.view viewWithTag:100];
        LYUIImageView * imageview1 = (LYUIImageView*)[self.view viewWithTag:101];
        LYUIImageView * imageview2 = (LYUIImageView*)[self.view viewWithTag:102];
        
        
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        NSMutableArray *thumbs = [[NSMutableArray alloc] init];
        
        
        if (imageview.iamgeShow)
        {
            [photos addObject:[MWPhoto photoWithImage:imageview.image]];
        }
        if (imageview1.iamgeShow)
        {
            [photos addObject:[MWPhoto photoWithImage:imageview1.image]];
        }
        if (imageview2.iamgeShow)
        {
            [photos addObject:[MWPhoto photoWithImage:imageview2.image]];
        }
        self.photos = photos;
        self.thumbs = thumbs;
        
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
        [self presentViewController:nc animated:YES completion:nil];
        
    }
    
    
    
}


- (IBAction)longPressGes:(UILongPressGestureRecognizer *)sender {
    
    _selectImageView = (LYUIImageView *)sender.view;
    
    if (_selectImageView.iamgeShow)
    {
        
        
        
        UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"选择照片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [self openCamera];
            
        }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self openPics];
            
        }];
        
        UIAlertAction *thridAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction *thridAction2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [_selectImageView setImage:[UIImage imageNamed:@"add5"]];
            [_selectImageView setIamgeShow:NO];
        }];
        
        
        [alertCtr addAction:firstAction];
        [alertCtr addAction:secondAction];
        [alertCtr addAction:thridAction];
        [alertCtr addAction:thridAction2];
        
        [self presentViewController:alertCtr animated:YES completion:^{
            
        }];

    }
}



// 打开相机
- (void)openCamera {
    // UIImagePickerControllerCameraDeviceRear 后置摄像头
    // UIImagePickerControllerCameraDeviceFront 前置摄像头
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        NSLog(@"没有摄像头");
        return ;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.navigationBar.tintColor = [UIColor colorWithHex:@"007aff"];
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


// 打开相册
- (void)openPics {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.navigationBar.tintColor = [UIColor colorWithHex:@"007aff"];
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.popoverController = popover;
        [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, 600, 800) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight animated:YES];
    }];
}


// 选中照片

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _selectImageView.clipsToBounds = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _selectImageView.image = image;
    _selectImageView.iamgeShow =YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp)
        
        return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
    
    
}

// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    
    [photoBrowser dismissViewControllerAnimated:YES completion:^{
        
        self.tabBarController.tabBar.hidden = YES;
        
    }];
    
}



///-按钮参数方法
-(IBAction)selectbutton:(UIButton *)btn {
    

    [self assignment:btn.tag];
    
}

///下一步切换按钮方法
- (IBAction)nextBtn:(UIButton*)sender {
    

    if (_selectedButtonTag==7019) {
        
        [self assignment:7000];
        return;
        
    }
    [self assignment:_selectedButtonTag+1];
    
    
}

-(void)assignment:(NSInteger)btnTag {
    
    for (int selectNum=7000;selectNum<7020 ; selectNum++) {
        
        TabsButton * button = (TabsButton *)[self.view viewWithTag:selectNum];
        TabsButton * button1 = (TabsButton *)[self.view viewWithTag:btnTag];
        if (selectNum==btnTag) {
            
            button1.selected = YES;
        }else {
            button.selected = NO;
        }
        
    }
    
    [self titleText:btnTag];
    
    [_initialDataArry replaceObjectAtIndex:_selectedButtonTag-7000 withObject:_initialTextField.text];
    [_finishedArry replaceObjectAtIndex:_selectedButtonTag-7000 withObject:_increaseTextField.text];
    
    
    selectField = YES;
    _increaseTextField.layer.borderWidth= 1.f;
    
    _selectedButtonTag=btnTag;
    
    [self titleText:_selectedButtonTag];
    [self additionalTextfieldHidden:_selectedButtonTag];
    
    _initialTextField.text = [_initialDataArry objectAtIndex:_selectedButtonTag-7000];
    _increaseTextField.text = [_finishedArry objectAtIndex:_selectedButtonTag-7000];
    
    if (btnTag==7019) {
        
        _photoBgView.hidden = NO;
        
    }else {
        
        _photoBgView.hidden = YES;
    }
    
    
    if (_selectedButtonTag==7014) {
        
        _initialTextField.tag =70114;
        _initialTextField.rightViewMode = UITextFieldViewModeAlways;
        
    }else if (_selectedButtonTag==7015) {
        
        _initialTextField.tag =70115;
        _initialTextField.rightViewMode = UITextFieldViewModeAlways;
        
    }else if (_selectedButtonTag==7016) {
        
        _initialTextField.tag =70116;
        _initialTextField.rightViewMode = UITextFieldViewModeAlways;
        
    }else if (_selectedButtonTag==7017) {
        
        _initialTextField.tag =70117;
        _initialTextField.rightViewMode = UITextFieldViewModeAlways;
        
    }else {
        
        _initialTextField.rightViewMode = UITextFieldViewModeNever;
    }
}


-(void)titleText:(NSInteger)titletag
{
    _defaultTitle.text = [_defaultArry objectAtIndex:titletag-7000];
    _additionalTitle.text =[_additionalArry objectAtIndex:titletag-7000];
    _increaseTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    _initialTextField.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    
}

/**
 *  用来隐藏成衣尺寸输入框
 *
 *  @param hiddentag 按钮tag
 */
-(void)additionalTextfieldHidden:(NSInteger)hiddentag
{
    
    if (hiddentag==7003||hiddentag==7004||hiddentag==7005||hiddentag==7006||hiddentag==7007||hiddentag==7008||hiddentag==7010||hiddentag==7011)
    {
        _initialTextField.hidden = NO;
        _increaseTextField.hidden = NO;
        
        if (hiddentag!=7010||hiddentag!=7011) {
            
            _sizeConfirmBtn.hidden = NO;
            _additionBtn.hidden = NO;
            _subductionBtn.hidden = NO;
        }
       

    }else
    {
        
        _increaseTextField.hidden = YES;
        _increaseTextField.hidden = YES;
        
        _sizeConfirmBtn.hidden = YES;
        _additionBtn.hidden = YES;
        _subductionBtn.hidden = YES;
    }
    
    _initialTextField.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    _initialTextField.layer.borderWidth= 2.f;
    
    
}


/**
 *  修身合身标签选择
 *
 *  @param sender button
 */
- (IBAction)shapeTypeButton:(UIButton *)sender {
    
    
    
    UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"选择后会清空全部成衣尺寸数据" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        for (int selectNum=50501;selectNum<50504 ; selectNum++) {
            
            TabsButton * button = (TabsButton *)[self.view viewWithTag:selectNum];
            TabsButton * button1 = (TabsButton *)[self.view viewWithTag:sender.tag];
            if (selectNum==sender.tag) {
                
                button1.selected = YES;
            }else {
                button.selected = NO;
            }
            
        }
        
        _shapeTypeButtonTag = sender.tag;
        [self assignment:7000];
        
        [_finishedArry removeAllObjects];
        
        for (int i =0; i<20; i++){
            
            [_finishedArry addObject:@""];
        }
  
        
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        
    }];

    
    [alertCtr addAction:firstAction];
    [alertCtr addAction:secondAction];
    
    [self presentViewController:alertCtr animated:YES completion:^{
        
    }];
    
    

    
}



-(void)textFieldright:(UITextField *)textField {
    

    
    AlertTabelView * viewcontroller = [[AlertTabelView alloc]init];
    viewcontroller.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    viewcontroller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [viewcontroller setTagID:textField.tag];
    
    
    viewcontroller.view.backgroundColor = [UIColor clearColor];
    viewcontroller.delegate =self;
    [self presentViewController:viewcontroller animated:YES completion:^{
        
        viewcontroller.view.backgroundColor = [UIColor clearColor];
        
    }];
    
    
}

-(void)alertTabel:(UITextField *)textFild text:(NSString *)text {
    
    TabsButton * button = (TabsButton *)[self.view viewWithTag:_selectedButtonTag];
    button.parameterLab.text = text;
    
    [self addtextFieldData];
    
    
    
}

-(void)LYTextFieldDeleteBackward:(UITextField *)textField {
    
    TabsButton * button = (TabsButton *)[self.view viewWithTag:_selectedButtonTag];
    button.parameterLab.text = _initialTextField.text;
    [self addtextFieldData];
}

-(void)addtextFieldData {
    
    [_initialDataArry replaceObjectAtIndex:_selectedButtonTag-7000 withObject:_initialTextField.text];
    
}

/**
 *  尺寸确认
 *
 *  @param sender button
 */
- (IBAction)sizeConfirm:(UIButton *)sender {
    
    
}

/**
 *  尺寸加法
 *
 *  @param sender button
 */
- (IBAction)additionBtn:(UIButton *)sender {
    
    
}

/**
 *  尺寸减法
 *
 *  @param sender Button
 */
- (IBAction)subductionBtn:(UIButton *)sender {
    
    
}


- (IBAction)doneBtn:(UIButton *)sender {
    
    NSLog(@"%@---量体数据",_initialDataArry);
    NSLog(@"%@---成衣数据",_finishedArry);
    
    if (_selectedButtonTag==7019) {
        
        [self assignment:7000];
        
    }
    [self assignment:_selectedButtonTag+1];
    
    NSString * body_shapestr= nil;
    if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"一般"]) {
        body_shapestr = @"normal";
        
    }else if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"纤细"])
    {
        body_shapestr = @"thin";
    }else if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"富贵"])
    {
        body_shapestr = @"rich";
    }else if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"微胖"])
    {
        body_shapestr = @"little_fat";
    }else if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"强壮"])
    {
        body_shapestr = @"strong";
    }else
    {
        body_shapestr = @"";
    }
    
    
    NSString * station_layoutstr= nil;
    if ([[_initialDataArry objectAtIndex:15]isEqualToString:@"普通"]) {
        station_layoutstr = @"normal";
        
    }else if ([[_initialDataArry objectAtIndex:15]isEqualToString:@"挺胸"])
    {
        station_layoutstr = @"raised_chest";
    }else if ([[_initialDataArry objectAtIndex:15]isEqualToString:@"驼背"])
    {
        station_layoutstr = @"humpbacked";
    }else if ([[_initialDataArry objectAtIndex:15]isEqualToString:@"哄背"])
    {
        station_layoutstr = @"coax_back";
    }else
    {
        station_layoutstr = @"";
    }
    
    NSString * shoulderstr= nil;
    if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"普通"]) {
        shoulderstr = @"normal";
        
    }
    else if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"小平肩"])
    {
        shoulderstr = @"xiaoping_shoulder";
    }else if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"大平肩"])
    {
        shoulderstr = @"daping_shoulder";
    }else if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"小溜肩"])
    {
        shoulderstr = @"small_shoulder";
    }else if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"大溜肩"])
    {
        shoulderstr = @"big_shoulder";
    }else
    {
        shoulderstr = @"";
    }
    
    
    NSString * abdomenStr= nil;
    if ([[_initialDataArry objectAtIndex:17]isEqualToString:@"平腹"]) {
        abdomenStr = @"flat_belly";
        
    }
    else if ([[_initialDataArry objectAtIndex:17]isEqualToString:@"微腹"])
    {
        abdomenStr = @"micro_abdominal";
    }else if ([[_initialDataArry objectAtIndex:17]isEqualToString:@"大腹"])
    {
        abdomenStr = @"upper_abdomen";
    }else
    {
        abdomenStr = @"";
    }
    
    MemberModel * meber = [[MemberModel alloc]init];
    
    NSDictionary* dic11111 =@{@"height": [_initialDataArry objectAtIndex:0],//身高
                              @"weight": [_initialDataArry objectAtIndex:1],//体重
                              @"collar_opening": [_initialDataArry objectAtIndex:2],//领围
                              @"chest_width": [_initialDataArry objectAtIndex:3],//胸围
                              @"processed_chest_width": [_finishedArry objectAtIndex:3],
                              @"middle_waisted": [_initialDataArry objectAtIndex:4],//腰围
                              @"processed_middle_waisted": [_finishedArry objectAtIndex:4],
                              @"swing_around": [_initialDataArry objectAtIndex:5],//下摆
                              @"processed_swing_around": [_finishedArry objectAtIndex:5],
                              @"arm_width": [_initialDataArry objectAtIndex:6],//袖肥
                              @"processed_arm_width": [_finishedArry objectAtIndex:6],
                              @"left_wrist_width": [_initialDataArry objectAtIndex:7],//左袖口
                              @"processed_left_wrist_width": [_finishedArry objectAtIndex:7],
                              @"right_wrist_width": [_initialDataArry objectAtIndex:8],//右袖口
                              @"processed_right_wrist_width": [_finishedArry objectAtIndex:8],
                              @"should_width": [_initialDataArry objectAtIndex:9],//肩宽
                              @"left_sleeve": [_initialDataArry objectAtIndex:10],//左袖长
                              @"right_sleeve": [_finishedArry objectAtIndex:10],//右袖长
                              @"back_length": [_initialDataArry objectAtIndex:11],//后衣长
                              @"front_length": [_finishedArry  objectAtIndex:11],//前背宽
                              @"chest": [_initialDataArry objectAtIndex:12],//前胸
                              @"back": [_initialDataArry objectAtIndex:13],//后背
                              @"body_shape": body_shapestr,//体型
                              @"station_layout":station_layoutstr,//站姿
                              @"shoulder":shoulderstr,//肩部
                              @"abdomen":abdomenStr,//腹部
                              @"consignee_address":meber.consignee_address,//收货地址
                              @"name": meber.name,//名字
                              @"phone_number":meber.phone_number,//电话
                              @"note": [_initialDataArry objectAtIndex:18],//备注
                              @"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],
                              @"dressing_name":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminname"],
                              @"staff_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"]};
    
    
    
    NSMutableDictionary * mutdic = [[NSMutableDictionary alloc]init];
    
    
    for (int i = 0; i<[dic11111 allKeys].count; i++) {
        
        if ([[dic11111 objectForKey:[[dic11111 allKeys] objectAtIndex:i]]length]!=0)
        {
            [mutdic addEntriesFromDictionary:@{[[dic11111 allKeys]objectAtIndex:i]:[dic11111 objectForKey:[[dic11111 allKeys] objectAtIndex:i]]}];
        }
        
    }
    
    
    
    
    if ([_pushID isEqualToString:@"1"])
    {
        [mutdic addEntriesFromDictionary:@{@"member_id":[_memberDic objectForKey:@"id"]}];
        [self getHttpAddMember:mutdic POST:memberUpdateUrl];
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)getHttpAddMember:(NSMutableDictionary*)mutdic POST:(NSString*)postUrl
{
    [SVProgressHUD show];
    
    LYUIImageView * imageview = (LYUIImageView*)[self.view viewWithTag:100];
    LYUIImageView * imageview1 = (LYUIImageView*)[self.view viewWithTag:101];
    LYUIImageView * imageview2 = (LYUIImageView*)[self.view viewWithTag:102];
    
    NSDictionary * oderNameArry = [[NSUserDefaults standardUserDefaults]valueForKey:@"OderName"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:postUrl parameters:mutdic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            
            
            if (![_pushID isEqualToString:@"1"])
            {
                
                [mutdic addEntriesFromDictionary:@{@"id": [responseObject valueForKey:@"data"]}];
                
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mutdic];
                
                [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"DONEMEMBER"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self savedata:[responseObject valueForKey:@"data"]];
                
                
                if ([LYFmdbTool insertMemberName:@[@{@"name":[mutdic objectForKey:@"name"],@"phone_number":[mutdic objectForKey:@"phone_number"],@"consignee_address":[mutdic objectForKey:@"consignee_address"]}]])
                {
                    
                    
                }
                
                if ([LYFmdbTool insertMember2:@[mutdic]])
                {
                    
                }
                
            }else
            {
                
                
                if ([LYFmdbTool insertMemberName:@[@{@"name":[mutdic objectForKey:@"name"],@"phone_number":[mutdic objectForKey:@"phone_number"],@"consignee_address":[mutdic objectForKey:@"consignee_address"]}]])
                {
                    
                    
                }
                
                
                [mutdic addEntriesFromDictionary:@{@"id": [mutdic valueForKey:@"member_id"]}];
                [mutdic removeObjectForKey:@"member_id"];
                [mutdic removeObjectForKey:@"phone"];
                [mutdic addEntriesFromDictionary:@{@"phone_number":[_memberDic valueForKey:@"phone_number"]}];
                
                
                if ([LYFmdbTool insertMember2:@[mutdic]])
                {
                    
                }
                
            }
            
            
            if (imageview.iamgeShow) {
                
                
                
                
                if ([_pushID isEqualToString:@"1"])
                {
                    [self getHttpimage:@{@"name":[_memberDic valueForKey:@"name"],@"phone": [_memberDic valueForKey:@"phone_number"],@"member_id": [_memberDic valueForKey:@"id"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"1"} image:imageview.image];
                }else
                {
                    [self getHttpimage:@{@"name":[oderNameArry valueForKey:@"name"],@"phone": [oderNameArry valueForKey:@"phoneNum"],@"member_id": [responseObject valueForKey:@"data"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"1"}image:imageview.image];
                }
                
                
            }
            
            if (imageview1.iamgeShow) {
                
                double delayInSeconds1 = 1.0;
                dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds1 * NSEC_PER_SEC);
                dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                    
                    
                    //执行事件
                    
                    if ([_pushID isEqualToString:@"1"])
                    {
                        [self getHttpimage:@{@"name":[_memberDic valueForKey:@"name"],@"phone": [_memberDic valueForKey:@"phone_number"],@"member_id": [_memberDic valueForKey:@"id"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"2"}image:imageview1.image];
                    }else
                    {
                        [self getHttpimage:@{@"name":[oderNameArry valueForKey:@"name"],@"phone": [oderNameArry valueForKey:@"phoneNum"],@"member_id": [responseObject valueForKey:@"data"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"2"}image:imageview1.image];
                        
                    }
                    
                    
                    
                });
            }
            
            if (imageview2.iamgeShow) {
                double delayInSeconds2 = 1.0;
                dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds2 * NSEC_PER_SEC);
                dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
                    
                    
                    if ([_pushID isEqualToString:@"1"])
                    {
                        [self getHttpimage:@{@"name":[_memberDic valueForKey:@"name"],@"phone": [_memberDic valueForKey:@"phone_number"],@"member_id": [_memberDic valueForKey:@"id"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"3"}image:imageview2.image];
                    }else
                    {
                        [self getHttpimage:@{@"name":[oderNameArry valueForKey:@"name"],@"phone": [oderNameArry valueForKey:@"phoneNum"],@"member_id": [responseObject valueForKey:@"data"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"3"}image:imageview2.image];
                        
                    }
                    
                    //执行事件
                });
            }
            
            
            
            if (imageview.iamgeShow==NO&&imageview1.iamgeShow==NO&&imageview2.iamgeShow==NO) {
                
                
                if ([_pushID isEqualToString:@"1"]) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"修改客户数据成功"];
                    
                    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"LinShi"]isEqualToString:@"NO"]) {
                        
                        [[NSUserDefaults standardUserDefaults]setObject:@"Yes"forKey:@"LinShi"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                    
                    double delayInSeconds = 2.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        
                        
                        
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                                              animated:YES];
                        //执行事件
                    });
                    
                }else
                {
                    
                    [SVProgressHUD dismiss];
//                    [self getHttpDone];
                    
                }
                
                
            }
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        NSString * str = [NSString stringWithFormat:@"%@",error];
        [SVProgressHUD showErrorWithStatus:str];
        
        
    }];
    
}

-(void)getHttpimage:(NSDictionary *)dic image:(UIImage*)image
{
    
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:appUpload parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        
        NSData *data = UIImageJPEGRepresentation([self normalizedImage:image],0.2);
        [formData appendPartWithFileData:data name:@"upload" fileName:@"upload.png" mimeType:@"image/png"];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                          
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
                          
                      } else {
                          //                          NSLog(@"%@ %@", response, responseObject);
                          
                          NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                          NSLog(@"%@", content);
                          
                          
                          if ([[content valueForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
                          {
                              if (_imageNameArry.count>0)
                              {
                                  NSFileManager* fileManager=[NSFileManager defaultManager];
                                  
                                  if ([[dic valueForKey:@"type"] isEqualToString:@"1"])
                                  {
                                      for (int i = 0; i<_imageNameArry.count; i++) {
                                          
                                          if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
                                          {
                                              
                                              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                                              NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                                              [fileManager removeItemAtPath:filePath error:nil];
                                          }
                                          
                                          
                                      }
                                      
                                      
                                  }
                                  
                                  if ([[dic valueForKey:@"type"] isEqualToString:@"2"]) {
                                      
                                      for (int i = 0; i<_imageNameArry.count; i++) {
                                          
                                          if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
                                          {
                                              
                                              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                                              NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                                              [fileManager removeItemAtPath:filePath error:nil];
                                          }
                                          
                                          
                                      }
                                  }
                                  
                                  if ([[dic valueForKey:@"type"] isEqualToString:@"3"]) {
                                      
                                      for (int i = 0; i<_imageNameArry.count; i++) {
                                          
                                          if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
                                          {
                                              
                                              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                                              NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                                              [fileManager removeItemAtPath:filePath error:nil];
                                          }
                                          
                                          
                                      }
                                      
                                  }
                              }
                              
                              
                              
                              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                              NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[content valueForKey:@"data"]valueForKey:@"file"]];   // 保存文件的名称
                              [UIImageJPEGRepresentation(image,0.2) writeToFile:filePath atomically:YES];
                              
                              NSLog(@"%@",filePath);
                              
                              
                              if ([_pushID isEqualToString:@"1"])
                              {
                                  
                                  
                                  
                                  
                                  if ([LYFmdbTool insertImageName2:@[@{@"id":@"",@"m_id":[dic valueForKey:@"member_id"],@"name":[[content valueForKey:@"data"]valueForKey:@"file"],@"type":[dic valueForKey:@"type"]}]del:NO] ) {
                                      
                                      
                                  }
                              }else
                              {
                                  
                                  
                                  if ([LYFmdbTool insertImageName:@[@{@"id":@"",@"m_id":[dic valueForKey:@"member_id"],@"name":[[content valueForKey:@"data"]valueForKey:@"file"],@"type":[dic valueForKey:@"type"]}]del:NO] ) {
                                      
                                  }
                              }
                              
                              
                              
                              if ([_pushID isEqualToString:@"1"]) {
                                  
                                  [SVProgressHUD showSuccessWithStatus:@"修改客户数据成功"];
                                  
                                  
                                  double delayInSeconds = 2.0;
                                  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                      
                                      [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]animated:YES];
                                      //执行事件
                                  });
                                  
                              }else
                              {
                                  [SVProgressHUD dismiss];
//                                  [self getHttpDone];
                                  
                                  
                                  
                              }
                              
                              
                          }
                      }
                  }];
    
    [uploadTask resume];
    
    
    
    
}


-(void)savedata:(NSString * )str
{
    NSDictionary * dic = @{@"height": [_initialDataArry objectAtIndex:0],
                           @"weight": [_initialDataArry objectAtIndex:1],
                           @"lingwei": [_initialDataArry objectAtIndex:2],
                           @"xiongweilt": [_initialDataArry objectAtIndex:3],
                           @"xiongweicy": [_finishedArry objectAtIndex:3],
                           @"yaoweilt": [_initialDataArry objectAtIndex:4],
                           @"yaoweicy": [_finishedArry objectAtIndex:4],
                           @"xiabailt": [_initialDataArry objectAtIndex:5],
                           @"xiabaicy": [_finishedArry objectAtIndex:5],
                           @"xiufeilt": [_initialDataArry objectAtIndex:6],
                           @"xiufeicy": [_finishedArry objectAtIndex:6],
                           @"zuoxiukoult": [_initialDataArry objectAtIndex:7],
                           @"zuoxiukoucy": [_finishedArry objectAtIndex:7],
                           @"youxiukoult": [_initialDataArry objectAtIndex:8],
                           @"youxiukoucy": [_finishedArry objectAtIndex:8],
                           @"should_width": [_initialDataArry objectAtIndex:9],
                           @"zuoxiuc": [_initialDataArry objectAtIndex:10],
                           @"youxiuc": [_initialDataArry objectAtIndex:10],
                           @"houyic": [_initialDataArry objectAtIndex:11],
                           @"qianyic": [_finishedArry objectAtIndex:11],
                           @"qianxk": [_initialDataArry objectAtIndex:12],
                           @"houbeik": [_initialDataArry objectAtIndex:13],
                           @"body_shape": [_initialDataArry objectAtIndex:14],
                           @"zhanzi": [_initialDataArry objectAtIndex:15],
                           @"jianbu": [_initialDataArry objectAtIndex:16],
                           @"fubu": [_initialDataArry objectAtIndex:17],
                           @"id":[self Nallstring:str]};
    
    
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"liangyicc"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)Nallstring:(id)str {
    
    
    if ([str isEqual:[NSNull null]])
    {
        return @"";
    }else if ([str isEqualToString:@"<null>"]) {
        
        return @"";
    }
    else if ([str isEqual:@"0.0"])
    {
        return @"";
    }else
    {
        return str;
    }
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
