//
//  Signature.h
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Signature : NSObject


- (NSString *)name ;
- (NSString *) hashedValue :(NSString *) key andMessage: (NSString *) message;

@end
