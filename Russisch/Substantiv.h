//
//  Substantiv.h
//  Russisch
//
//  Created by Josef Hilbert on 18.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kNominative @"Nominative"
#define kGenetive @"Genetive"
#define kDative @"Dative"
#define kAccusative @"Accusative"
#define kInstrumental @"Instrumental"
#define kPrepositional @"Prepositional"
#define kNominativePlural @"NominativePlural"
#define kGenetivePlural @"GenetivePlural"
#define kDativePlural @"DativePlural"
#define kAccusativePlural @"AccusativePlural"
#define kInstrumentalPlural @"InstrumentalPlural"
#define kPrepositionalPlural @"PrepositionalPlural"
#define kIndeclinable @"ui"

@interface Substantiv : NSObject

@property (nonatomic, strong) NSString *nominativDeutsch;
@property (nonatomic, strong) NSString *nominativRussisch;
@property (nonatomic, strong) NSMutableAttributedString *nominativRussischAttributed;
@property (nonatomic, strong) NSString *genus;
@property (nonatomic, strong) NSString *genusPlural;
@property (nonatomic        ) BOOL pluralException;
@property (nonatomic, strong) NSString *belebt;
@property (nonatomic, strong) NSMutableDictionary *declination;
@property (nonatomic, strong) NSMutableDictionary *declinationAttributed;
@property (nonatomic, strong) NSMutableDictionary *declinationSuffix;


+(NSArray*)substantive;
+(NSArray*)substantiveFiltered:(NSString*)searchText;
+(NSMutableDictionary*)substantivDictionary;
@end
