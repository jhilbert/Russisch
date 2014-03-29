//
//  Verb.h
//  Russisch
//
//  Created by Josef Hilbert on 19.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Verb : NSObject

@property (nonatomic, strong) NSString *nennformDeutsch;
@property (nonatomic, strong) NSString *nennformRussisch;
@property (nonatomic, strong) NSString *deklination;
@property (nonatomic, strong) NSString *p1eRussisch;
@property (nonatomic, strong) NSString *p2eRussisch;
@property (nonatomic, strong) NSString *p3eRussisch;
@property (nonatomic, strong) NSString *p1mRussisch;
@property (nonatomic, strong) NSString *p2mRussisch;
@property (nonatomic, strong) NSString *p3mRussisch;

+(NSArray*)verben;
+(NSArray*)verbsFiltered:(NSString*)searchText;
+(NSMutableDictionary*)verbDictionary;

@end
