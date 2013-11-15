//
//  Consumer.m
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import "Consumer.h"

@implementation Consumer

-(id) initWithID:(NSString *)cID secret:(NSString *)secret
{
    self = [super init];
    
    if(self)
    {
        self.consumerId = cID;
        self.consumerSecret = secret;
    
    }
    return self;
}

@end
