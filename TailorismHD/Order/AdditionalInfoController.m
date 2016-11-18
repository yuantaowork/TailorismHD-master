//
//  AdditionalInfoController.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/9/8.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "AdditionalInfoController.h"
#import "ConfirmOrderController.h"
#import "MemberModel.h"
#import "OrderModel.h"
#import "MemberType.h"
#import "AlertTabelView.h"
@interface AdditionalInfoController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AlertTabelViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightButtonItem;

@property (strong,nonatomic)LYUITextField * saleNameText; //销售人员
@property (strong,nonatomic)LYUITextField * payTypeText;  //支付方式
@property (strong,nonatomic)LYUITextField * discountText; //打折金额
@property (strong,nonatomic)LYUITextField * discountRemarkText; //打折原因
@property (strong,nonatomic)LYUITextField * invoiceText; //发票
@property (strong,nonatomic)LYUITextField * expressNote; //订单备注


@end

@implementation AdditionalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = _rightButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (IBAction)rightbutton:(UIBarButtonItem *)sender {

    
    if ([_payTypeText.text length]==0) {
        
        [SVProgressHUD showInfoWithStatus:@"有必填项未填写"];
        return;
    }
    
    if ([_discountText.text length]>0) {
        
        if ([_discountRemarkText.text length]==0) {
            
            [SVProgressHUD showInfoWithStatus:@"填写打折金额后,打折原因必须填写"];
            return;
        }
    }
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //     NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //     [formatter setTimeZone:timeZone];
    //
    //    NSDate * measuredate = [formatter dateFromString:_measureTimeText.text];
    //    NSString *measuretimeSp = [NSString stringWithFormat:@"%ld", (long)[measuredate timeIntervalSince1970]];
    //
    //    NSDate * serviceEndDate = [formatter dateFromString:_serviceEndTimeText.text];
    //    NSString *serviceEndSp = [NSString stringWithFormat:@"%ld", (long)[serviceEndDate timeIntervalSince1970]];
    
    
    NSDictionary * dic = @{@"sale_name":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminname"],
                           @"pay_type":[MemberType orderType:[self Nallstring:_payTypeText.text]],
                           @"discount":[self Nallstring:_discountText.text],
                           @"discount_remark":[self Nallstring:_discountRemarkText.text],
                           @"invoice":[self Nallstring:_invoiceText.text],
                           @"express_note":[self Nallstring:_expressNote.text]
                           };
    
    OrderModel * ordermodel = [[OrderModel alloc]init];
    ordermodel = nil;
    ordermodel = [OrderModel mj_objectWithKeyValues:dic];
    
    
    ConfirmOrderController * view = [[ConfirmOrderController alloc]init];
    view.imagedic = _iamge_dic;
    view.orderdataArry = _orderdataArry;
    [self.navigationController pushViewController:view animated:YES];
    
}


-(NSString *)Nallstring:(id)str {
    
    
    if ([str isEqual:[NSNull null]]||str==nil)
    {
        
        
        return @"";
    }else
    {
        
        return str;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
            //            case 0:
            //                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation1" forIndexPath:indexPath];
            //                _saleNameText = (LYUITextField*)[cell.contentView viewWithTag:66770];
            //
            //                break;
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInfoCell1" forIndexPath:indexPath];
            _payTypeText = (LYUITextField*)[cell.contentView viewWithTag:1214];
            _payTypeText.rightViewMode = UITextFieldViewModeAlways;
            _payTypeText.delegate = self;
            
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInfoCell2" forIndexPath:indexPath];
            _discountText = (LYUITextField*)[cell.contentView viewWithTag:66772];
            _discountText.delegate = self;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInfoCell3" forIndexPath:indexPath];
            _discountRemarkText = (LYUITextField*)[cell.contentView viewWithTag:66773];
            _discountRemarkText.delegate = self;
            break;
        case 3:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInfoCell4" forIndexPath:indexPath];
            _invoiceText = (LYUITextField*)[cell.contentView viewWithTag:66774];
            break;
        }
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInfoCell5" forIndexPath:indexPath];
            _expressNote = (LYUITextField*)[cell.contentView viewWithTag:66777];
            break;
        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInfoCell6" forIndexPath:indexPath];
           
            break;

        default:
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInfoCell1" forIndexPath:indexPath];
            break;
    }
    // Configure the cell...
    
    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignResponder];
}


-(void)resignResponder
{
    [_saleNameText resignFirstResponder]; //销售人员
    [_payTypeText resignFirstResponder];  //支付方式
    [_discountText resignFirstResponder]; //打折金额
    [_discountRemarkText resignFirstResponder]; //打折原因
    [_invoiceText resignFirstResponder]; //发票
    [_expressNote resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self resignResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==1214) {
        
        
        [self textFieldright:textField];
        return NO;
    }
    
    if (_discountText==textField||_discountRemarkText==textField) {
        
        if (_discountText ==textField) {
            
            return YES;
        }
        
        
        if (_discountRemarkText ==textField) {
            
            if ([_discountText.text length]==0) {
                
                [SVProgressHUD showInfoWithStatus:@"请先填写打折金额"];
                return NO;
            }else
            {
                return YES;
            }
        }
    }
    
    
    return NO;
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
        
        [SVProgressHUD dismiss];
    }];
    
    
}

-(void)alertTabel:(UITextField *)textFild text:(NSString *)text {
    
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
    if ([string isEqualToString:@"."]) {
        
        return YES;
        
    }else {
        
        if (textField == _discountText) {
            
            if( ![self isPureInt:string] || ![self isPureFloat:string])
            {
                
                return NO;
                
            }else {
                
                return YES;
                
            }
            
        }else {
            
            return YES;
        }
        
    }

}

//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
