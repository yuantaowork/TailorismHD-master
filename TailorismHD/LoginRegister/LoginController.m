//
//  LoginController.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "LoginController.h"
#import "AppDelegate.h"

@interface LoginController ()
@property (weak, nonatomic)  UITextField *userTextField;
@property (weak, nonatomic)  UITextField *passwTextField;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImageView * bgimgeView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [bgimgeView setImage:[UIImage imageNamed:@"longinBg.jpg"]];
    bgimgeView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:bgimgeView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
    
    if (_userTextField.text.length==0||_passwTextField.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"输入框不能为空!"];
        return;
    }
    
    [SVProgressHUD show];
    
    
    NSDictionary * dic = @{@"phone":[NSString stringWithFormat:@"%@",_userTextField.text],@"password":[NSString stringWithFormat:@"%@",_passwTextField.text]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval  = 30;
    [LYAFNetworking AFNetworking:LoginUrl parameters:dic completionBlock:^(id responseObject, NSError *error) {
        
        
        if (responseObject) {
            
            if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSLog(@"%@",[[responseObject objectForKey:@"data"] valueForKey:@"name"]);
                
                [SVProgressHUD dismiss];
                
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"againLogin"]==YES) {
                    
                    
                    
                    if (![[[responseObject objectForKey:@"data"] valueForKey:@"id"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"]]) {
                        
                        
                        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"TailorismDB.sqlite"];
                        
                        NSFileManager* fileManager=[NSFileManager defaultManager];
                        [fileManager removeItemAtPath:filePath error:nil];
                        
                        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"firstStart"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        
                    }
                    
                }
                
                
                [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"token"] forKey:@"Token"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults]setObject:[[responseObject objectForKey:@"data"] valueForKey:@"name"] forKey:@"adminname"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults]setObject:[[responseObject objectForKey:@"data"] valueForKey:@"id"] forKey:@"adminID"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                
                
                
                if ([[[responseObject objectForKey:@"data"] valueForKey:@"roles"]isKindOfClass:[NSArray class]]) {
                    
                    if ([[[responseObject objectForKey:@"data"] valueForKey:@"roles"]count]>0)
                    {
                        if ([[[responseObject objectForKey:@"data"] valueForKey:@"roles"]containsObject:@"Manager"]) {
                            
                            [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"Roles"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                        }else {
                            
                            [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"Roles"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                        }
                        
                        
                    }else
                    {
                        [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"Roles"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                }else {
                    
                    [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"Roles"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                
//                [UMessage setAlias:_userTextField.text type:@"UserName" response:^(id responseObject, NSError *error) {
//                    
//                }];
                
                
                
                
                AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                [appdelegate getrootViewController];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
            }

            
            
        }
        
        
        
    }];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LoginCell" forIndexPath:indexPath];
    _userTextField = (UITextField*)[cell viewWithTag:1000101];
    _passwTextField = (UITextField*)[cell viewWithTag:1000102];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_userTextField resignFirstResponder];
    [_passwTextField resignFirstResponder];
    
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"LoginController" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([super class])];
    }
    return self;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
