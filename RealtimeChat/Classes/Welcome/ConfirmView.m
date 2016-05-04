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

#import "utilities.h"

#import "ConfirmView.h"
#import "ConfirmView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ConfirmView()

@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;

@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation ConfirmView

@synthesize  cellPassword, cellButton;
@synthesize  fieldPassword;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	self.title = @"Confirm";
    
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
	[fieldPassword becomeFirstResponder];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.view endEditing:YES];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionConfirm
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    NSString *password	= fieldPassword.text;
    //[ProgressHUD show:@"Please wait..." Interaction:NO];
    
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSString *email = [defaults objectForKey:@"email"];
    
    
    
    Firebase *ref = [[Firebase alloc] initWithUrl:FIREBASE];
    [ref authUser:email password:password
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
    if (error) {
        [ProgressHUD showError:error.userInfo[@"error"]];
    } else {
        [defaults setObject:authData.uid forKey:@"uid"];
        PostNotification(NOTIFICATION_USER_LOGGED_IN);
        [ProgressHUD showSuccess:@"Succeed."];
        
       // [self.navigationController popToRootViewControllerAnimated:YES];
        //     UIViewController *vc = [self presentingViewController]; //ios 5 or later
      //  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
      // [self dismissViewControllerAnimated:YES completion:nil];
   //      [super dismissViewControllerAnimated:YES completion:nil];
    //    [super.navigationController popViewControllerAnimated:YES];
  
    //    [self.navigationController popViewControllerAnimated:YES];
        
        UIViewController *vc = self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:NULL];
    }
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
	return 2;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.row == 0) return cellPassword;
	if (indexPath.row == 1) return cellButton;
	return nil;
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (indexPath.row == 1) [self actionConfirm];
}

#pragma mark - UITextField delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

	if (textField == fieldPassword)
	{
		[self actionConfirm];
	}
	return YES;
}

@end
