//
//  HistoryViewController.m
//  Card Matching
//
//  Created by Baris.
//  Copyright (c) 2016 Baris. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textfield;

@end

@implementation HistoryViewController


-(void)updateScreen{

    
    NSString *abc = [_dataPassed componentsJoinedByString:@"||||"];
    self.textfield.text = [NSString stringWithFormat:@"%@", abc];

}



-(void)viewDidLoad{
    [super viewDidLoad];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    [self updateScreen];
}



@end
