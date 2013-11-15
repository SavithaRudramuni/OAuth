//
//  Consumer.h
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Consumer : NSObject

@property (nonatomic,strong) NSString *consumerId;
@property (nonatomic,strong) NSString *consumerSecret;

-(id) initWithID:(NSString *)cID secret:(NSString *)secret;

@end
