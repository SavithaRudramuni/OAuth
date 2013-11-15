//
//  OAuthManager.h
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth1RequiredParameters.h"
#import "OAuth2Parameters.h"

@protocol OAuthorizeDelegate <NSObject>

-(UIWebView *) didLoadWebViewForAuthorization;

@end


typedef void (^oAuthCompletionBlock)(id details);

@interface OAuthManager : NSObject



+(void) getAccessTokenUsingOAuth1RequiredParameters:(OAuth1RequiredParameters *)parameters
             withCompletionoAuthDetails:(oAuthCompletionBlock)completionHandler;

+(void) getAccessTokenUsingOAuth2RequiredParameters:(OAuth2Parameters *)parameters
                         withCompletionoAuthDetails:(oAuthCompletionBlock)completionHandler;



@end
