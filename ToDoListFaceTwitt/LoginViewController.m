//
//  ViewController.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 18.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

#pragma btnActions
- (IBAction)btnSendSmsTapped:(id)sender {
    
    [PFCloud callFunctionInBackground:@"inviteWithTwilio"
                       withParameters:@{@"number":@"+38063....."}//enter your number
                                block:^(id object, NSError *error) {
                                    UIMsg(@"Welcome sms is sent");
                                }];
    
}

- (IBAction)btnLoginTapped:(id)sender {
    HUDSHOW
    [PFUser logInWithUsernameInBackground:self.tfLogin.text password:self.tfPassword.text
                                    block:^(PFUser *user, NSError *error) {
                                        HUDHIDE
                                        
                                        UIErrReturn(@"Cannot login");
                                        
                                        [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
                                        
                                        
                                    }];
}

- (IBAction)btnLoginFacebook:(id)sender {
    NSArray *permissionsArray = @[ @"public_profile", @"user_birthday",@"user_about_me",@"email"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if(!user){
            return;
        }
        UIErrReturn (@"You cancelled the Facebook login")
        if (user.isNew) {
            UIMsg(@"You signed up and logged in through Facebook!");
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                UIErrReturn (@"Something wrong")
                [[PFUser currentUser] setObject:[result objectForKey:@"email"]forKey:@"email"];
                [[PFUser currentUser] saveInBackground];
            }];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
        }
    }];
}

- (IBAction)btnLoginTwitter:(id)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        UIErrReturn (@"You cancelled the Twitter login")
        
        if(!user){
            return;
        }
        else if (user.isNew) {
            UIMsg(@"You signed up and logged in through Twitter!");
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
            [self getEmailForTwitter];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationLogin object:nil];
        }
    }];
}

- (IBAction)btnForgotPasswordTapped:(id)sender {
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Password reset" message:@"Please enter your email" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
    
    av.tapBlock = ^(UIAlertView *av, NSInteger buttonIndex){
        
        if(buttonIndex == av.cancelButtonIndex)return ;
        HUDSHOW
        [PFUser requestPasswordResetForEmailInBackground:[av textFieldAtIndex:0].text block:^(BOOL succeeded,NSError *error){
            HUDHIDE
            UIErrReturn (@"Failed to request password reset")
            UIMsg(@"Reguest instructions sent to your email")
            
            
        }];
        
    };
    
}

- (void) getEmailForTwitter{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add Email" message:@"Please enter your email" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
    av.tapBlock = ^(UIAlertView *av, NSInteger buttonIndex)
    
    {     if (buttonIndex == av.cancelButtonIndex) return;
        if ([av textFieldAtIndex:0].text.length < 1) {
            UIMsg(@"Please enter your email");
            [self getEmailForTwitter];
            return;
        }
        [[PFUser currentUser] setObject: [av textFieldAtIndex:0].text forKey:@"email"];
        [[PFUser currentUser] saveInBackground];
    };
}

@end