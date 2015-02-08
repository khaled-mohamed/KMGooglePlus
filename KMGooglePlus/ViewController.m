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
@class GPPSignInButton;

@interface ViewController ()<GPPSignInDelegate>
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = @"827644785479-5pcfmfi0vnogo29lonkkjp6nctjojqm4.apps.googleusercontent.com";
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[kGTLAuthScopePlusLogin,@"profile"];  // "https://www.googleapis.com/auth/plus.login" scope
    //  signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    [signIn trySilentAuthentication];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
       GTLPlusPerson *googlePerson=[[GPPSignIn sharedInstance] googlePlusUser];
        NSLog(@"%@",googlePerson.birthday);
        NSLog(@"%@",googlePerson.aboutMe);
        NSLog(@"%@",googlePerson.displayName);
        NSLog(@"%@",googlePerson.emails);
        NSLog(@"%@",googlePerson.name);
        NSLog(@"%@",googlePerson.image);


        self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}
-(IBAction)loginAction:(id)sender
{
//    GPPSignIn *signIn = [GPPSignIn sharedInstance];
//    signIn.shouldFetchGooglePlusUser = YES;
//    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
//    
//    // You previously set kClientId in the "Initialize the Google+ client" step
//    signIn.clientID = @"827644785479-5pcfmfi0vnogo29lonkkjp6nctjojqm4.apps.googleusercontent.com";
//    
//    // Uncomment one of these two statements for the scope you chose in the previous step
//    signIn.scopes = @[kGTLAuthScopePlusLogin,@"profile"];  // "https://www.googleapis.com/auth/plus.login" scope
//  //  signIn.scopes = @[ @"profile" ];            // "profile" scope
//    
//    // Optional: declare signIn.actions, see "app activities"
//    signIn.delegate = self;
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    [signIn authenticate];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        [self refreshInterfaceBasedOnSignIn];
    }
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

- (IBAction) didTapShare: (id)sender {
    // Use the native share dialog in your app:

    
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    // The share preview, which includes the title, description, and a thumbnail,
    // is generated from the page at the specified URL location.
    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://ibtikar.net.sa/EN/"]];
    
    [shareBuilder setPrefillText:@"Test google plus share !"];
  //  [shareBuilder setTitle:@"Google Plus Login" description:@"Description Description Description" thumbnailURL:[NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"]];
    
    // This line passes the string "rest=1234567" to your native application
    // if somebody opens the link on a supported mobile device
    
   // [shareBuilder setContentDeepLinkID:@"rest=1234567"];
    
    // This method creates a call-to-action button with the label "RSVP".
    // - URL specifies where people will go if they click the button on a platform
    // that doesn't support deep linking.
    // - deepLinkID specifies the deep-link identifier that is passed to your native
    // application on platforms that do support deep linking
    
    
    [shareBuilder setCallToActionButtonWithLabel:@"Ibtikar"
                                             URL:[NSURL URLWithString:@"http://ibtikar.net.sa/EN/"]
                                      deepLinkID:@"Ibtikar=4815162342"];
    
   // [shareBuilder attachImage:[UIImage imageNamed:@"circle.png"]];
    
    [shareBuilder open];
}
@end
