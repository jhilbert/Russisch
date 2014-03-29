//
//  SubstantivCell.h
//  Russisch
//
//  Created by Josef Hilbert on 21.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubstantivCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelRussian;
@property (weak, nonatomic) IBOutlet UILabel *labelDeutsch;
@property (weak, nonatomic) IBOutlet UILabel *labelGenetiv;
@property (weak, nonatomic) IBOutlet UILabel *labelDativ;
@property (weak, nonatomic) IBOutlet UILabel *labelAkkusativ;
@property (weak, nonatomic) IBOutlet UILabel *labelInstrumental;
@property (weak, nonatomic) IBOutlet UILabel *labelPraepositiv;
@property (weak, nonatomic) IBOutlet UILabel *labelPluralNominativ;

@end
