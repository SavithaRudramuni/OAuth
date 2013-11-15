//
//  OAuthRequiredParameters.h
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuth1RequiredParameters : NSObject

@property (nonatomic,strong) NSString *requestTokenURL;
@property (nonatomic,strong) NSString *authorizationURL;
@property (nonatomic,strong) NSString *callBackURL;
@property (nonatomic,strong) NSString *accessTokenURL;
@property (nonatomic,strong) NSString *consumerKey;
@property (nonatomic,strong) NSString *secreatKey;

@end
