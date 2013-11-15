//
//  ViewController.m
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import "ViewController.h"
#import "OAuth1RequiredParameters.h"
#import "OAuthManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    OAuth1RequiredParameters *parameter = [[OAuth1RequiredParameters alloc]init];
    
    [parameter setConsumerKey:@"4baea9e751b7bf404e5831525ad36e53"];
    [parameter setSecreatKey:@"478068baf865989f"];
    [parameter setRequestTokenURL:@"http://www.flickr.com/services/oauth/request_token"];
    [parameter setAuthorizationURL:@"http://www.flickr.com/services/oauth/authorize"];
    [parameter setAccessTokenURL:@"http://www.flickr.com/services/oauth/access_token"];
    [parameter setCallBackURL:@"http://www.example.com"];
    
    [OAuthManager getAccessTokenUsingOAuth1RequiredParameters:parameter withCompletionoAuthDetails:^(id details) {
        
        NSLog(@"Details %@",details);
        if(details)
        {
            NSString *string = details;
            
            NSArray *pairs = [string componentsSeparatedByString:@"&"];
            
            for (NSString *pair in pairs)
            {
                NSArray *elements = [pair componentsSeparatedByString:@"="];
                
                if ([[elements objectAtIndex:0] isEqualToString:@"user_nsid"])
                {
                    NSString *userID =[elements objectAtIndex:1];
                    NSLog(@"User ID:%@",userID);
                }
            }
            
           
            
            
        }
        
        
    }];
    
    OAuth2Parameters *parameter2 = [[OAuth2Parameters alloc]init];
    
    
    [OAuthManager getAccessTokenUsingOAuth1RequiredParameters:parameter withCompletionoAuthDetails:^(id details) {
        
        NSLog(@"Details %@",details);
        if(details)
        {
            NSString *string = details;
            
            NSArray *pairs = [string componentsSeparatedByString:@"&"];
            
            for (NSString *pair in pairs)
            {
                NSArray *elements = [pair componentsSeparatedByString:@"="];
                
                if ([[elements objectAtIndex:0] isEqualToString:@"user_nsid"])
                {
                    NSString *userID =[elements objectAtIndex:1];
                    NSLog(@"User ID:%@",userID);
                }
            }
            
            
            
            
        }
        
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
