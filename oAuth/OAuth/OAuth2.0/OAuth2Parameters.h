//
//  OAuth2Parameters.h
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuth2Parameters : NSObject

@property (nonatomic,strong) NSString *clientID;
@property (nonatomic,strong) NSString *clientSecret;
@property (nonatomic,strong) NSString *authorizationURL;
@property (nonatomic,strong) NSString *redirectURL;
@property (nonatomic,strong) NSString *accessTokenURL;
@property (nonatomic,strong) NSString *scope;
@property (nonatomic,strong) NSString *state;

@end
