//
//  OARequestParameter.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "OAuth1RequestParameter.h"


@implementation OAuth1RequestParameter
@synthesize name, value;

- (id)initWithName:(NSString *)aName value:(NSString *)aValue {
    self = [super init];
    self.name = aName;
    self.value = aValue;
    return self;
}

- (NSString *)URLEncodedName {
	return self.name;
//    return [self.name encodedURLParameterString];
}

- (NSString *)URLEncodedValue {
    return [self.value encodeURLParameter];
}

- (NSString *)URLEncodedNameValuePair {
    return [NSString stringWithFormat:@"%@=%@", [self URLEncodedName], [self URLEncodedValue]];
}

- (BOOL)isEqual:(id)object {
	if ([object isKindOfClass:[self class]]) {
		return [self isEqualToRequestParameter:(OAuth1RequestParameter *)object];
	}
	
	return NO;
}

- (BOOL)isEqualToRequestParameter:(OAuth1RequestParameter *)parameter {
	return ([self.name isEqualToString:parameter.name] &&
			[self.value isEqualToString:parameter.value]);
}


+ (id)requestParameter:(NSString *)aName value:(NSString *)aValue
{
	return [[self alloc] initWithName:aName value:aValue];
}

@end
