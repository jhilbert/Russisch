//
//  VerbCell.h
//  Russisch
//
//  Created by Josef Hilbert on 19.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerbCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelRussian;
@property (weak, nonatomic) IBOutlet UILabel *labelDeutsch;
@property (weak, nonatomic) IBOutlet UILabel *labelP1E;
@property (weak, nonatomic) IBOutlet UILabel *labelP2E;
@property (weak, nonatomic) IBOutlet UILabel *labelP3E;
@property (weak, nonatomic) IBOutlet UILabel *labelP1M;
@property (weak, nonatomic) IBOutlet UILabel *labelP2M;
@property (weak, nonatomic) IBOutlet UILabel *labelP3M;
@end
