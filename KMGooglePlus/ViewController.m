//
//  ViewController.m
//  KMGooglePlus
//
//  Created by khaled el morabea on 2/5/15.
//  Copyright (c) 2015 Ibtikar. All rights reserved.
//

#import "ViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface ViewController ()<GPPSignInDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = @"ClientID";
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didDisconnectWithError:(NSError *)error
{
    
}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
}

- (IBAction) didTapShare: (id)sender {
    // Use the native share dialog in your app:
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    // The share preview, which includes the title, description, and a thumbnail,
    // is generated from the page at the specified URL location.
    [shareBuilder setURLToShare:[NSURL URLWithString:@"https://www.example.com/restaurant/sf/1234567/"]];
    
    [shareBuilder setPrefillText:@"I made reservations!"];
    
    // This line passes the string "rest=1234567" to your native application
    // if somebody opens the link on a supported mobile device
    [shareBuilder setContentDeepLinkID:@"rest=1234567"];
    
    // This method creates a call-to-action button with the label "RSVP".
    // - URL specifies where people will go if they click the button on a platform
    // that doesn't support deep linking.
    // - deepLinkID specifies the deep-link identifier that is passed to your native
    // application on platforms that do support deep linking
    [shareBuilder setCallToActionButtonWithLabel:@"RSVP"
                                             URL:[NSURL URLWithString:@"https://www.example.com/reservation/4815162342/"]
                                      deepLinkID:@"rsvp=4815162342"];
    
    [shareBuilder open];
}
@end
