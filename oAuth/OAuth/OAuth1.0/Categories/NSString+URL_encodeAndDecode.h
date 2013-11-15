//
//  NSString+URL_encodeAndDecode.h
//  oAuth
//
//  Created by Savitha SR on 13/11/13.
//  Copyright (c) 2013 Savitha SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL_encodeAndDecode)


-(NSString *) encodeURL;
-(NSString *) decodeURL;


-(NSString *)encodeURLParameter;
@end
