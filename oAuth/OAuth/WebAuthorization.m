//
//  WebAuthorization.m
//  SociallyConnecting
//
//  Created by myCompany on 22/05/13.
//  Copyright (c) 2013 myCompany. All rights reserved.
//

#import "WebAuthorization.h"

@interface WebAuthorization () <UIWebViewDelegate>

@end

@implementation WebAuthorization


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
    
    
    BOOL requestForCallbackURL = ([urlString rangeOfString:self.authorizedUrl].location != NSNotFound);
    
    if ( requestForCallbackURL )
    {
        BOOL userAllowedAccess = ([urlString rangeOfString:@"user_refused"].location == NSNotFound);
        if ( userAllowedAccess )
        {
            if([self.version isEqualToString:@"OAUTH 1.0"])
            {
                [self.requestToken setVerifierWithUrl:url];
                
                if(self.delegate)
                {
                    if([self.delegate respondsToSelector:@selector(loadedSuccesfully:)])
                    {
                        [self.delegate loadedSuccesfully:self.requestToken];
                    }
                }
            }
            else{
                
                if(self.delegate)
                {
                    if([self.delegate respondsToSelector:@selector(loadedSuccesfullyusingOAuth:)])
                    {
                        [self.delegate loadedSuccesfullyusingOAuth:[self getCode:url]];
                    }
                }
            }
            

        }
        else
        {
            
        }
    }
    else
    {
        // Case (a) or (b), so ignore it
        
        //[self errorHandler];
    }
	return YES;
}

- (NSString *)getCode:(NSURL *)aURL
{
    NSString *query = [aURL query];
    NSArray *pairs = [query componentsSeparatedByString:@"?"];
    
	for (NSString *pair in pairs)
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if ([[elements objectAtIndex:0] isEqualToString:@"code"])
        {
           return [elements objectAtIndex:1];
        }
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(loadedSuccesfully:)])
        {
            [self.delegate loadedSuccesfully:nil];
        }
    }
}
@end
