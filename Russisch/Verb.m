//
//  Verb.m
//  Russisch
//
//  Created by Josef Hilbert on 19.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "Verb.h"
#import "CHCSVParser.h"
static NSMutableArray *verbs;
static NSMutableArray *verbsFiltered;
static NSMutableDictionary *verbDictionary;
static NSString * const ep1e = @"ю";
static NSString * const ewp1e = @"у";
static NSString * const ep2e = @"ешь";
static NSString * const ep3e = @"ет";
static NSString * const ep1m = @"ем";
static NSString * const ep2m = @"ете";
static NSString * const ep3m = @"ют";
static NSString * const ewp3m = @"ут";
static NSString * const ew = @"ш";
static NSString * const esch = @"ж";
static NSString * const eu = @"у";

static NSString * const jop1e = @"у";
static NSString * const jop2e = @"ёшь";
static NSString * const jop3e = @"ёт";
static NSString * const jop1m = @"ём";
static NSString * const jop2m = @"ёте";
static NSString * const jop3m = @"ут";

static NSString * const ip1e = @"ю";
static NSString * const iup1e = @"у";
static NSString * const ilp1e = @"лю";
static NSString * const ip2e = @"ишь";
static NSString * const ip3e = @"ит";
static NSString * const ip1m = @"им";
static NSString * const ip2m = @"ите";
static NSString * const ip3m = @"ят";
static NSString * const iup3m = @"ат";

static NSString * const vokale = @"яаеэиыёоую";
static NSString * const weichheitszeichen = @"ь";
static NSString * const zischLaute = @"жшщч";
@implementation Verb

+(NSMutableArray*)verben
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        verbs = [NSMutableArray new];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Verben" ofType:@"csv"];
        NSError *error = nil;
        NSArray *verbenCSV = [NSArray arrayWithContentsOfCSVFile:path options:CHCSVParserOptionsSanitizesFields delimiter:';'];
        if (verbenCSV == nil) {
            //something went wrong; log the error and exit
            NSLog(@"error parsing file: %@", error);
            return;
        }
        
        for (int i = 0; i < verbenCSV.count; i++)
        {
            Verb *verb = [Verb new];
            verb.nennformDeutsch = verbenCSV[i][0];
            verb.nennformRussisch = verbenCSV[i][1];
            verb.deklination = verbenCSV[i][2];
            // irregular verbs first
            if ([verb.deklination isEqualToString:@"х"])
            {
                verb.p1eRussisch = verbenCSV[i][3];
                verb.p2eRussisch = verbenCSV[i][4];
                verb.p3eRussisch = verbenCSV[i][5];
                verb.p1mRussisch = verbenCSV[i][6];
                verb.p2mRussisch = verbenCSV[i][7];
                verb.p3mRussisch = verbenCSV[i][8];
            }
            else
            {
                // е-variant:   most cases we need to cut off 2 characters to get root
                // е3-variant:  some cases we cut off 3 characters to get the root
                // ев-variant:  extend root with extra "в"
                // е3ь-variant: cut off 3 characters for root, extend root with extra "ь"
                // е4ш-variant: some cases we cut off 4 character, and then extend root with extra "ш"
                // *** e-Konjukation: -ю, -ешь, -ет, -ем, -ете, -ют (when last character of stem is a vocal)
                // *** e-Konjukation: -у, -ешь, -ет, -ем, -ете, -ут (when last character of stem is a consonant and stem has more than 1 syllable)
                // *** ё-Konjukation: -у, -ёшь, -ёт, -ём, -ёте, -ут (when last character of stem is a consonant and stem has only 1 syllable)
                // .... REVISIT!  currently check if nominal form is < 6 characters, then assume 1 syllable only
                
                if ([verb.deklination isEqualToString:@"е"] || [verb.deklination isEqualToString:@"е3"] || [verb.deklination isEqualToString:@"ев"] || [verb.deklination isEqualToString:@"е4ш"] || [verb.deklination isEqualToString:@"е3ь"])
                {
                    NSString *root;
                    NSInteger numberOfCharactersToCut;
                    if ([verb.deklination isEqualToString:@"е4ш"])
                    {
                        numberOfCharactersToCut = 4;
                    }
                    else
                    {
                        if ([verb.deklination isEqualToString:@"е3"] || [verb.deklination isEqualToString:@"е3ь"])
                        {
                            numberOfCharactersToCut = 3;
                        }
                        else
                        {
                            numberOfCharactersToCut = 2;
                        }
                    }
                    
                    root = [verb.nennformRussisch substringWithRange:NSMakeRange(0, verb.nennformRussisch.length - numberOfCharactersToCut)];
                    
                    if ([verb.deklination isEqualToString:@"ев"])
                    {
                        root = [NSString stringWithFormat:@"%@%@", root, @"в"];
                    }
                    if ([verb.deklination isEqualToString:@"е4ш"])
                    {
                        root = [NSString stringWithFormat:@"%@%@", root, @"ш"];
                    }
                    if ([verb.deklination isEqualToString:@"е3ь"])
                    {
                        root = [NSString stringWithFormat:@"%@%@", root, @"ь"];
                    }
                    
                    NSString *endOfRoot = [root substringWithRange:NSMakeRange(root.length - 1, 1)];
                    if (([vokale rangeOfString:endOfRoot].location != NSNotFound) || ([weichheitszeichen rangeOfString:endOfRoot].location != NSNotFound))
                    {
                        verb.p1eRussisch = [NSString stringWithFormat:@"%@%@", root, ep1e];
                        verb.p3mRussisch = [NSString stringWithFormat:@"%@%@", root, ep3m];
                    }
                    else
                    {
                        verb.p1eRussisch = [NSString stringWithFormat:@"%@%@", root, jop1e];
                        verb.p3mRussisch = [NSString stringWithFormat:@"%@%@", root, jop3m];
                    }
                    
                    if (verb.nennformRussisch.length < 6)
                    {
                        verb.p2eRussisch = [NSString stringWithFormat:@"%@%@", root, jop2e];
                        verb.p3eRussisch = [NSString stringWithFormat:@"%@%@", root, jop3e];
                        verb.p1mRussisch = [NSString stringWithFormat:@"%@%@", root, jop1m];
                        verb.p2mRussisch = [NSString stringWithFormat:@"%@%@", root, jop2m];
                    }
                    else
                    {
                        verb.p2eRussisch = [NSString stringWithFormat:@"%@%@", root, ep2e];
                        verb.p3eRussisch = [NSString stringWithFormat:@"%@%@", root, ep3e];
                        verb.p1mRussisch = [NSString stringWithFormat:@"%@%@", root, ep1m];
                        verb.p2mRussisch = [NSString stringWithFormat:@"%@%@", root, ep2m];
                    }
                    
                }
                else
                {
                    if ([verb.deklination isEqualToString:@"еова"] || [verb.deklination isEqualToString:@"еева"] )
                    {
                        NSString *root = [verb.nennformRussisch substringWithRange:NSMakeRange(0, verb.nennformRussisch.length - 5)];
                        verb.p1eRussisch = [NSString stringWithFormat:@"%@%@%@", root, eu, ep1e];
                        verb.p2eRussisch = [NSString stringWithFormat:@"%@%@%@", root, eu, ep2e];
                        verb.p3eRussisch = [NSString stringWithFormat:@"%@%@%@", root, eu, ep3e];
                        verb.p1mRussisch = [NSString stringWithFormat:@"%@%@%@", root, eu, ep1m];
                        verb.p2mRussisch = [NSString stringWithFormat:@"%@%@%@", root, eu, ep2m];
                        verb.p3mRussisch = [NSString stringWithFormat:@"%@%@%@", root, eu, ep3m];
                    }
                    
                    else
                        // и-variant: we need to cut off 3 characters to get root
                        // *** и-Konjukation: -ю, -ишь, -ит, -им, -ите, -ят (when last character of root is a vocal or consonant except for "жшщч")
                        // *** и-Konjukation: -у, -ишь, -ит, -им, -ите, -ат (when last character of root is on of these: "жшщч")
                        // *** ил-Konjukation: -лю (insert "л" on 1.Person Singular only)
                        // *** иж-Konjukation: -жу (replace ending of root with "ж" on 1.Person Singular only)
                        // *** иш-Konjukation: -шу (replace ending of root with "ш" on 1.Person Singular only)
                        
                    {
                        NSString *root = [verb.nennformRussisch substringWithRange:NSMakeRange(0, verb.nennformRussisch.length - 3)];
                        
                        NSString *endOfRoot = [root substringWithRange:NSMakeRange(root.length - 1, 1)];
                        if ([zischLaute rangeOfString:endOfRoot].location != NSNotFound)
                        {
                            verb.p1eRussisch = [NSString stringWithFormat:@"%@%@", root, iup1e];
                            verb.p3mRussisch = [NSString stringWithFormat:@"%@%@", root, iup3m];
                        }
                        else
                        {
                            verb.p3mRussisch = [NSString stringWithFormat:@"%@%@", root, ip3m];
                            if ([verb.deklination isEqualToString:@"ил"])
                            {
                                verb.p1eRussisch = [NSString stringWithFormat:@"%@%@", root, ilp1e];
                            }
                            else
                            {
                                if ([verb.deklination isEqualToString:@"иж"])
                                {
                                    verb.p1eRussisch = [NSString stringWithFormat:@"%@%@%@", [root substringWithRange:NSMakeRange(0, root.length - 1)], esch, eu];
                                }
                                else
                                {
                                    if ([verb.deklination isEqualToString:@"иш"])
                                    {
                                        verb.p1eRussisch = [NSString stringWithFormat:@"%@%@%@", [root substringWithRange:NSMakeRange(0, root.length - 1)], ew, eu];
                                    }
                                    else
                                    {
                                        verb.p1eRussisch = [NSString stringWithFormat:@"%@%@", root, ip1e];
                                        
                                    }
                                }
                            }
                        }
                        verb.p2eRussisch = [NSString stringWithFormat:@"%@%@", root, ip2e];
                        verb.p3eRussisch = [NSString stringWithFormat:@"%@%@", root, ip3e];
                        verb.p1mRussisch = [NSString stringWithFormat:@"%@%@", root, ip1m];
                        verb.p2mRussisch = [NSString stringWithFormat:@"%@%@", root, ip2m];
                    }
                }
            }
            [verbs addObject:verb];
        }
        
        verbs  = [verbs sortedArrayUsingComparator:^NSComparisonResult(Verb *v1, Verb *v2) {
            
            return [v1.nennformRussisch localizedCaseInsensitiveCompare:v2.nennformRussisch];
        }].mutableCopy;
        
        verbDictionary = [NSMutableDictionary new];
        for (Verb *verb in verbs)
        {
            [verbDictionary setObject:verb forKey:verb.nennformRussisch];
        }
    });
    
    return verbs;
    
}

+(NSMutableArray*)verbsFiltered:(NSString*)filterString
{
    verbsFiltered = [NSMutableArray new];
    
    NSString* stringToBeSearched;
    
    for (Verb *verb in [self verben])
    {
        stringToBeSearched = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", verb.nennformDeutsch, verb.nennformRussisch, verb.p1eRussisch, verb.p2eRussisch, verb.p3eRussisch, verb.p1mRussisch, verb.p2mRussisch, verb.p3mRussisch];
        
        if ([stringToBeSearched rangeOfString:filterString options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [verbsFiltered addObject:verb];
        }
    }
    return verbsFiltered;
}

+(NSMutableDictionary*)verbDictionary
{
    if (!(verbDictionary))
    {
        [self verben];
    }
    return verbDictionary;
}
@end
