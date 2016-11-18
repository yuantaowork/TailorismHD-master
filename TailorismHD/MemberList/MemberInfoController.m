//
//  MemberInfoController.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/9/5.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "MemberInfoController.h"
#import "PaddingDataController.h"
#import "OrderHomeController.h"
#import "MemberModel.h"
@interface MemberInfoController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet LYUITextField *nameTextField;
@property (weak, nonatomic) IBOutlet LYUITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet LYUITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftItme;

@end

@implementation MemberInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameTextField.rightViewMode = UITextFieldViewModeNever;
    _phoneTextField.rightViewMode = UITextFieldViewModeNever;
    _addressTextField.rightViewMode = UITextFieldViewModeNever;
    
    self.navigationItem.rightBarButtonItem = _rightButtonItem;
    
    if ([_pushID isEqualToString:@"3"]) {
        
      self.navigationItem.leftBarButtonItem = _leftItme;
      self.title = @"添加客户";
    }
    
    _nameTextField.text  = [_memberDataDic objectForKey:@"name"];
    _phoneTextField.text  = [_memberDataDic objectForKey:@"phone_number"];
    _addressTextField.text  = [_memberDataDic objectForKey:@"consignee_address"];
    
    if ([_pushID isEqualToString:@"1"]) {
        
        _phoneTextField.delegate = self;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
 
    return NO;
}

- (IBAction)nextButtonItem:(UIBarButtonItem *)sender {
    
    
    if ([_nameTextField.text length]==0||[_phoneTextField.text length]==0||[_addressTextField.text length]==0) {
        
        [SVProgressHUD showErrorWithStatus:@"有必填项未填写!"];
        return;
    }
    
    
    
    if (![self isValidateMobile:_phoneTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }

    
    
    NSDictionary * dic = @{@"name":_nameTextField.text,@"phone_number":_phoneTextField.text,@"consignee_address":_addressTextField.text};
    MemberModel *member = [[MemberModel alloc]init];
    
    if ([_pushID isEqualToString:@"1"]) {
        
        
        NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]init];
        [dataDic addEntriesFromDictionary:_memberDataDic];
        [dataDic addEntriesFromDictionary:dic];
        
        member= [MemberModel mj_objectWithKeyValues:dataDic];
        
        member= [MemberModel mj_objectWithKeyValues:@{@"meberID":[dataDic valueForKey:@"id"]}];
        
        PaddingDataController * paddingView = [[PaddingDataController alloc]init];
        paddingView.memberDic = _memberDataDic;
        paddingView.pushID = _pushID;
        paddingView.imagedic = _imagedic;
        [self.navigationController pushViewController:paddingView animated:YES];
        
    }else if ([_pushID isEqualToString:@"2"]) {
        
        
        NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]init];
        [dataDic addEntriesFromDictionary:_memberDataDic];
        [dataDic addEntriesFromDictionary:dic];
        
        member= [MemberModel mj_objectWithKeyValues:dataDic];
        
        member= [MemberModel mj_objectWithKeyValues:@{@"meberID":[dataDic valueForKey:@"id"]}];
        
        OrderHomeController * paddingView = [[OrderHomeController alloc]init];
//        paddingView.memberDic = _memberDataDic;
        paddingView.iamge_dic = _imagedic;
        
        [self.navigationController pushViewController:paddingView animated:YES];
        
    }
    else {
        
        
        
        [SVProgressHUD show];
        
        NSDictionary * token = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"]};
        NSMutableDictionary * httpDetaDic = [[NSMutableDictionary alloc]init];
        [httpDetaDic addEntriesFromDictionary:dic];
        [httpDetaDic addEntriesFromDictionary:@{@"phone":[dic valueForKey:@"phone_number"]}];
        [httpDetaDic addEntriesFromDictionary:@{@"dressing_name":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminname"]}];
        [httpDetaDic addEntriesFromDictionary:token];
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:memberAdd parameters:httpDetaDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            NSLog(@"JSON: %@", responseObject);
            
            
            
            
            if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                
                
                [httpDetaDic addEntriesFromDictionary:@{@"id": [responseObject valueForKey:@"data"]}];
                
                if ([LYFmdbTool insertMemberName:@[@{@"name":[httpDetaDic objectForKey:@"name"],@"phone_number":[httpDetaDic objectForKey:@"phone"],@"consignee_address":[httpDetaDic objectForKey:@"consignee_address"]}]])
                {
                    
                    
                }
                
                [httpDetaDic addEntriesFromDictionary:dic];
                
                [httpDetaDic removeObjectForKey:@"phone"];;
                [httpDetaDic removeObjectForKey:@"meberID"];
                
                if ([LYFmdbTool insertMember2:@[httpDetaDic]])
                {
                    
                }
                
                [SVProgressHUD showSuccessWithStatus:@"添加客户成功"];
                [ self dismissViewControllerAnimated:YES completion:nil];
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            NSString * str = [NSString stringWithFormat:@"%@",error];
            [SVProgressHUD showErrorWithStatus:str];
            
            
        }];

        
    }
    
    
    
    
}

- (IBAction)leftItme:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([_pushID isEqualToString:@"3"]) {
        
        
    }
}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(170|173|171|172|175|176|177|178|179|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
