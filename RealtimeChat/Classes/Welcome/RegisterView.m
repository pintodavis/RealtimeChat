//
// Copyright (c) 2015 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import <Firebase/Firebase.h>
#import <UIKit/UIViewController.h>

#import "utilities.h"

#import "RegisterView.h"
#import "ConfirmView.h"
#import "LoginView.h"


//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RegisterView()

@property (strong, nonatomic) IBOutlet UITableViewCell *cellName;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellEmail;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;

@property (strong, nonatomic) IBOutlet UITextField *fieldName;
@property (strong, nonatomic) IBOutlet UITextField *fieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation RegisterView

@synthesize cellName, cellEmail, cellPassword, cellButton;
@synthesize fieldName, fieldEmail, fieldPassword;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	self.title = @"Register";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	[self.tableView addGestureRecognizer:gestureRecognizer];
	gestureRecognizer.cancelsTouchesInView = NO;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	[fieldName becomeFirstResponder];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.view endEditing:YES];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionRegister
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *name		= fieldName.text;
	NSString *email		= [fieldEmail.text lowercaseString];
	NSString *password	= fieldPassword.text;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([name length] < 8)		{ [ProgressHUD showError:@"Name is too short."]; return; }
	if ([email length] == 0)	{ [ProgressHUD showError:@"Email must be set."]; return; }
	if ([password length] == 0)	{ [ProgressHUD showError:@"Password must be set."]; return; }
	//---------------------------------------------------------------------------------------------------------------------------------------------
//	[ProgressHUD show:@"Please wait..." Interaction:NO];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFUser *user = [PFUser user];

    NSString *varyingString = @"@funeventsapp.com";
    NSString *email_new = [NSString stringWithFormat: @"%@%@",email, varyingString];
   // email = email_new;
    user.email = email_new;
    user.username = email_new;
    user.password = password;
	user[PF_USER_EMAILCOPY] = email_new;
	user[PF_USER_FULLNAME] = name;
	user[PF_USER_FULLNAME_LOWER] = [name lowercaseString];
   
    /*

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:email_new forKey:@"email"];
    
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE];
    [ref createUser:email_new password:password
        withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
    
    if (error) {
         [ProgressHUD showError:error.userInfo[@"error"]];
    } else {
        NSString *uid = [result objectForKey:@"uid"];
        NSLog(@"Successfully created user account with uid: %@", uid);
        
       // Firebase *ref = [[Firebase alloc] initWithUrl:@"https://torrid-heat-2729.firebaseio.com//queue/tasks"];
       // [[ref childByAutoId] setValue:@{@"userid" : uid , @"password" : password, @"email": email_new, @"phonenumber":  email, @"_state": @"spec_1_start"}];
        ConfirmView *confirmView = [[ConfirmView alloc] init];
       // [self presentViewController:confirmView animated:YES completion:nil];
        [self.navigationController pushViewController:confirmView animated:YES];
       // [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
       // [self dismissViewControllerAnimated:YES completion:nil];
        //[self presentViewController:confirmView animated:YES completion:nil];
        
    }
}];
    */
   
	[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error == nil)
		{
			ParsePushUserAssign();
			PostNotification(NOTIFICATION_USER_LOGGED_IN);
			[ProgressHUD showSuccess:@"Succeed."];
			[self dismissViewControllerAnimated:YES completion:nil];
		}
		else [ProgressHUD showError:error.userInfo[@"error"]];
	}];
   
    
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 4;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.row == 0) return cellName;
	if (indexPath.row == 1) return cellEmail;
	if (indexPath.row == 2) return cellPassword;
	if (indexPath.row == 3) return cellButton;
	return nil;
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (indexPath.row == 3) [self actionRegister];
}

#pragma mark - UITextField delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (textField == fieldName)
	{
		[fieldEmail becomeFirstResponder];
	}
	if (textField == fieldEmail)
	{
		[fieldPassword becomeFirstResponder];
	}
	if (textField == fieldPassword)
	{
		[self actionRegister];
	}
	return YES;
}

@end
