//
//  Substantiv.m
//  Russisch
//
//  Created by Josef Hilbert on 18.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "Substantiv.h"
#import "CHCSVParser.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSMutableArray *substantive;
static NSMutableArray *substantiveFiltered;
static NSMutableDictionary *substantivDictionary;
static NSString * const weichesA = @"я";
static NSString * const hartesA = @"а";
static NSString * const weichesE = @"е";
static NSString * const hartesE = @"э";
static NSString * const weichesI = @"и";
static NSString * const hartesI = @"ы";
static NSString * const weichesO = @"ё";
static NSString * const hartesO = @"о";
static NSString * const weichesU = @"ю";
static NSString * const hartesU = @"у";

static NSString * const vokale = @"яаеэиыёоую";
static NSString * const weicheVokale = @"яеиёю";
static NSString * const weicheVokalePlusWeichheitszeichen = @"яеийёюь";
static NSString * const J = @"й";
static NSString * const weichheitszeichen = @"ь";
static NSString * const vokalePlusJ = @"яаеэиыёоуюй";
static NSString * const vokalePlusJPlusWeichheitszeichen = @"яаеэиыёоуюйь";
static NSString * const kgx = @"кгх";
static NSString * const zischLaute = @"жшщч";

static UIFont *font;
static NSDictionary *attrsDictionary;
static NSInteger length;
static NSString *root;
static NSString *ending;
static NSString *secondlast;

@implementation Substantiv

+(void)genetiv:(Substantiv*)substantiv
{
 
    // indeklinierbare Substantive
    if ([substantiv.belebt isEqualToString:@"ui"])
    {
        substantiv.declination[kGenetive] = substantiv.nominativRussisch;
        return;
    }
    
    if ([substantiv.genus isEqualToString:@"w"])
    {
        if (([ending isEqualToString:hartesA]) && ([kgx rangeOfString:secondlast].location == NSNotFound) && ([zischLaute rangeOfString:secondlast].location == NSNotFound))
        {
            substantiv.declination[kGenetive] = [NSString stringWithFormat:@"%@%@", root, hartesI];
            substantiv.declinationSuffix[kGenetive] = [@"-" stringByAppendingString:hartesI];
        }
        else
        {
            substantiv.declination[kGenetive] = [NSString stringWithFormat:@"%@%@", root, weichesI];
            substantiv.declinationSuffix[kGenetive] = [@"-" stringByAppendingString:weichesI];
        }
        
    }
    
    if (([substantiv.genus isEqualToString:@"m"]) || ([substantiv.genus isEqualToString:@"s"]))
    {
        if ([weicheVokalePlusWeichheitszeichen rangeOfString:ending].location != NSNotFound)
        {
            substantiv.declination[kGenetive] = [NSString stringWithFormat:@"%@%@", root, weichesA];
            substantiv.declinationSuffix[kGenetive] = [@"-" stringByAppendingString:weichesA];
        }
        else
        {
            substantiv.declination[kGenetive] = [NSString stringWithFormat:@"%@%@", root, hartesA];
            substantiv.declinationSuffix[kGenetive] = [@"-" stringByAppendingString:hartesA];
        }
    }
    
    substantiv.declinationAttributed[kGenetive] = [self editAsAttributedString:substantiv.declination[kGenetive] withGenus:substantiv.genus];
    return;
}

+(void)dativ:(Substantiv*)substantiv
{

    // indeklinierbare Substantive
    if ([substantiv.belebt isEqualToString:@"ui"])
    {
        substantiv.declination[kDative] = substantiv.nominativRussisch;
        return;
    }
    
    substantiv.declination[kDative] = @" ";
    
    substantiv.declinationAttributed[kDative] = [self editAsAttributedString:substantiv.declination[kDative] withGenus:substantiv.genus];
    return;
}


+(void)akkusativ:(Substantiv*)substantiv
{
    // indeklinierbare Substantive
    if ([substantiv.belebt isEqualToString:@"ui"])
    {
        substantiv.declination[kAccusative] = substantiv.nominativRussisch;
        return;
    }
    
    if ([substantiv.genus isEqualToString:@"w"])
    {
        if (([ending isEqualToString:weichesA]) && ([zischLaute rangeOfString:secondlast].location == NSNotFound))
        {
            substantiv.declination[kAccusative] = [NSString stringWithFormat:@"%@%@", root, weichesU];
            substantiv.declinationSuffix[kAccusative] = [@"-" stringByAppendingString:weichesU];
        }
        else
        {
            substantiv.declination[kAccusative] = [NSString stringWithFormat:@"%@%@", root, hartesU];
            substantiv.declinationSuffix[kAccusative] = [@"-" stringByAppendingString:hartesU];
        }
    }
    else
    {
        if (([substantiv.genus isEqualToString:@"m"]) && ([substantiv.belebt isEqualToString:@"b"]))
        {
            substantiv.declination[kAccusative] = substantiv.declination[kGenetive];
            substantiv.declinationSuffix[kAccusative] = @"=G";
        }
        else
        {
            substantiv.declination[kAccusative] = substantiv.declination[kNominative];
            substantiv.declinationSuffix[kAccusative] = @"=N";
        }
    }

    substantiv.declinationAttributed[kAccusative] = [self editAsAttributedString:substantiv.declination[kAccusative] withGenus:substantiv.genus];
    return;
}

+(void)instrumental:(Substantiv*)substantiv
{
    
    // indeklinierbare Substantive
    if ([substantiv.belebt isEqualToString:@"ui"])
    {
        substantiv.declination[kInstrumental] = substantiv.nominativRussisch;
        return;
    }
    
    substantiv.declination[kInstrumental] = @" ";
    
    substantiv.declinationAttributed[kInstrumental] = [self editAsAttributedString:substantiv.declination[kInstrumental] withGenus:substantiv.genus];
    return;
}

+(void)praepositiv:(Substantiv*)substantiv
{
    // indeklinierbare Substantive
    if ([substantiv.belebt isEqualToString:@"ui"])
    {
        substantiv.declination[kPrepositional] = substantiv.nominativRussisch;
        return;
    }
    
    if (([secondlast isEqualToString:weichesI]) && ([weicheVokalePlusWeichheitszeichen rangeOfString:ending].location != NSNotFound))
    {
        substantiv.declination[kPrepositional] = [NSString stringWithFormat:@"%@%@", root, weichesI];
        substantiv.declinationSuffix[kPrepositional] = [@"-" stringByAppendingString:weichesI];
    }
    else
    {
        substantiv.declination[kPrepositional] = [NSString stringWithFormat:@"%@%@", root, weichesE];
        substantiv.declinationSuffix[kPrepositional] = [@"-" stringByAppendingString:weichesE];
    }

    substantiv.declinationAttributed[kPrepositional] = [self editAsAttributedString:substantiv.declination[kPrepositional] withGenus:substantiv.genus];
    
    return;
}

+(void)plural:(Substantiv*)substantiv
{
    // irregular plural (not being generated, but defined in input file)
    if (((NSString*)substantiv.declination[kNominativePlural]).length > 0)
    {
        return;
    }
    
    // indeklinierbare Substantive
    if ([substantiv.belebt isEqualToString:@"ui"])
    {
        substantiv.declination[kNominativePlural] = substantiv.nominativRussisch;
        substantiv.declinationSuffix[kNominativePlural] = @"=";
        return;
    }

    if ([substantiv.genusPlural isEqualToString:@"s"])
    {
        if (([weicheVokale rangeOfString:ending].location != NSNotFound) && ([zischLaute rangeOfString:secondlast].location == NSNotFound))
        {
            substantiv.declination[kNominativePlural] = [NSString stringWithFormat:@"%@%@", root, weichesA];
            substantiv.declinationSuffix[kNominativePlural] = [@"-" stringByAppendingString:weichesA];
        }
        else
        {
            substantiv.declination[kNominativePlural] = [NSString stringWithFormat:@"%@%@", root, hartesA];
            substantiv.declinationSuffix[kNominativePlural] = [@"-" stringByAppendingString:hartesA];
        }
    }
    else
    {
        if (([weicheVokalePlusWeichheitszeichen rangeOfString:ending].location != NSNotFound) || ([zischLaute rangeOfString:ending].location != NSNotFound) || ([kgx rangeOfString:ending].location != NSNotFound) || ([zischLaute rangeOfString:secondlast].location != NSNotFound) || ([kgx rangeOfString:secondlast].location != NSNotFound))
        {
            substantiv.declination[kNominativePlural] = [NSString stringWithFormat:@"%@%@", root, weichesI];
            substantiv.declinationSuffix[kNominativePlural] = [@"-" stringByAppendingString:weichesI];
        }
        else
        {
            substantiv.declination[kNominativePlural] = [NSString stringWithFormat:@"%@%@", root, hartesI];
            substantiv.declinationSuffix[kNominativePlural] = [@"-" stringByAppendingString:hartesI];
        }
    }
    
    substantiv.declinationAttributed[kNominativePlural] = [self editAsAttributedString:substantiv.declination[kNominativePlural] withGenus:substantiv.genus];
    
    return;
}


+(NSMutableAttributedString*)editAsAttributedString:(NSString*)string withGenus:(NSString*)genus
{
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attrsDictionary];
    
    NSRange range = NSMakeRange(attributedString.length - 1, 1);
    NSString *end = [string substringWithRange:range];
    
    if ([weicheVokalePlusWeichheitszeichen rangeOfString:end].location != NSNotFound)
    {
        [attributedString addAttribute:NSUnderlineStyleAttributeName
                                 value:[NSNumber numberWithInt:NSUnderlineStyleDouble]
                                 range:range];
        
    }
    else
    {
        [attributedString addAttribute:NSUnderlineStyleAttributeName
                                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 range:range];
    }
    range = NSMakeRange(0, attributedString.length);
    NSRange rangeEnd = NSMakeRange(attributedString.length - 1, 1);
    
    if ([genus isEqualToString:@"w"])
    {
        [attributedString addAttribute:NSBackgroundColorAttributeName
         //                                                     value:UIColorFromRGB(0xFFD2ED)
                                 value:[UIColor yellowColor]
                                 range:rangeEnd];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:UIColorFromRGB(0xF80091)
                                 range:range];
        
    }
    else
    {
        if ([genus isEqualToString:@"m"])
        {
            [attributedString addAttribute:NSBackgroundColorAttributeName
             //                                                         value:UIColorFromRGB(0xD7E4FF)
             
                                     value:[UIColor yellowColor]
                                     range:rangeEnd];
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:UIColorFromRGB(0x004EF3)
                                     range:range];
        }
        else
        {
            [attributedString addAttribute:NSBackgroundColorAttributeName
             //                                                         value:UIColorFromRGB(0xFFF0D2)
                                     value:[UIColor yellowColor]
                                     range:rangeEnd];
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:UIColorFromRGB(0xFFA900)
                                     range:range];
        }
    }
    return attributedString;
}

+(NSMutableArray*)substantiveFiltered:(NSString*)filterString
{
    substantiveFiltered = [NSMutableArray new];
    
    NSString* stringToBeSearched;
    
    for (Substantiv *substantiv in [self substantive])
    {
        
        stringToBeSearched = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", substantiv.nominativDeutsch, substantiv.nominativRussisch, substantiv.declination[kGenetive], substantiv.declination[kDative], substantiv.declination[kAccusative], substantiv.declination[kInstrumental], substantiv.declination[kPrepositional], substantiv.declination[kNominativePlural]];
        
        if ([stringToBeSearched rangeOfString:filterString options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [substantiveFiltered addObject:substantiv];
        }
    }
    return substantiveFiltered;
    
}

+(NSMutableArray*)substantive
{
    font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:16.0];
    //    font = [UIFont fontWithName:@"Courier" size:20.0];
    attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                  forKey:NSFontAttributeName];
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        substantive = [NSMutableArray new];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Substantive" ofType:@"csv"];
        NSError *error = nil;
        NSArray *substantiveCSV = [NSArray arrayWithContentsOfCSVFile:path options:CHCSVParserOptionsSanitizesFields delimiter:';'];
        if (substantiveCSV == nil) {
            //something went wrong; log the error and exit
            NSLog(@"error parsing file: %@", error);
            return;
        }
        
        for (int i = 1; i < substantiveCSV.count; i++)
        {
            Substantiv *substantiv = [Substantiv new];
            substantiv.declinationSuffix = [NSMutableDictionary new];
            substantiv.declination = [NSMutableDictionary new];
            substantiv.declinationAttributed = [NSMutableDictionary new];

            substantiv.nominativDeutsch = substantiveCSV[i][0];
            substantiv.nominativRussisch = substantiveCSV[i][1];
            substantiv.declination[kNominative] = substantiveCSV[i][1];
            substantiv.genus = substantiveCSV[i][2];
            substantiv.belebt = substantiveCSV[i][3];
            
            substantiv.genusPlural = substantiv.genus;
            substantiv.pluralException = NO;
            substantiv.declination[kNominativePlural] = @"";
            if (((NSArray*)substantiveCSV[i]).count > 4)
            {
                substantiv.pluralException = YES;
                if (((NSString*)substantiveCSV[i][4]).length == 1)
                {
                    substantiv.genusPlural = substantiveCSV[i][4];
                }
                else
                {
                    substantiv.declination[kNominativePlural] = substantiveCSV[i][4];
                }
            }

            length = substantiv.nominativRussisch.length;
            ending = [substantiv.nominativRussisch substringWithRange:NSMakeRange(length - 1, 1)];
            if (length > 1)
            {
                secondlast = [substantiv.nominativRussisch substringWithRange:NSMakeRange(length - 2, 1)];
            }
            else
            {
                secondlast = @"";
            }
            if ([vokalePlusJPlusWeichheitszeichen rangeOfString:ending].location != NSNotFound)
            {
                root = [substantiv.nominativRussisch substringWithRange:NSMakeRange(0, length - 1)];
                substantiv.nominativRussischAttributed = [self editAsAttributedString:substantiv.nominativRussisch withGenus:substantiv.genus];
                substantiv.declinationAttributed[kNominative] = [self editAsAttributedString:substantiv.declination[kNominative] withGenus:substantiv.genus];
            }
            else
            {
                root = substantiv.nominativRussisch;
                substantiv.nominativRussischAttributed = [self editAsAttributedString:[substantiv.nominativRussisch stringByAppendingString:@" "] withGenus:substantiv.genus];
                substantiv.declinationAttributed[kNominative] = [self editAsAttributedString:[substantiv.declination[kNominative] stringByAppendingString:@" "] withGenus:substantiv.genus];
            }

            [self genetiv:substantiv];
            [self dativ:substantiv];
            [self akkusativ:substantiv];
            [self instrumental:substantiv];
            [self praepositiv:substantiv];
            [self plural:substantiv];
            [substantive addObject:substantiv];
        }
        
        substantive  = [substantive sortedArrayUsingComparator:^NSComparisonResult(Substantiv *s1, Substantiv *s2) {
            return [s1.nominativRussisch localizedCaseInsensitiveCompare:s2.nominativRussisch];
        }].mutableCopy;
        
        substantivDictionary = [NSMutableDictionary new];
        for (Substantiv *substantiv in substantive)
        {
            [substantivDictionary setObject:substantiv forKey:substantiv.nominativRussisch];
        }
    });
    
    return substantive;
    
}


+(NSMutableDictionary*)substantivDictionary
{
    if (!(substantivDictionary))
    {
        [self substantive];
    }
    return substantivDictionary;
}
@end
