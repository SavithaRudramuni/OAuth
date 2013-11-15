//
//  ConnectionManager.h
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^connectionCompletionBlock)(id  details);

@interface ConnectionManager : NSObject

-(id)initWithRequest:(NSURLRequest *) request WithComplition:(connectionCompletionBlock)completionHandler;

@end
