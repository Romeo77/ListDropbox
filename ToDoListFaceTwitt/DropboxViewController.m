//
//  DropboxViewController.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 28.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "DropboxViewController.h"

@interface DropboxViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DropboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSURL *url = [NSURL URLWithString:@"https://www.dropbox.com/s/w76lwg4jof3mp34/filik.html?dl=1"];
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestUrl];
    
}

@end
