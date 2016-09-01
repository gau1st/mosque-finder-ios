//
//  PoiDetailViewController.h
//  PencariMasjid
//
//  Created by Himawan Putra on 11/4/12.
//  Copyright (c) 2012 Himawan Putra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoiDetailViewController : UIViewController

@property (strong, nonatomic) NSString *theName;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) NSString *theAddress;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) NSString *idVenue;
@property (strong, nonatomic) IBOutlet UIImageView *mosqueImage;
@property float currentLatitude;
@property float currentLongitude;
@property float targetLatitude;
@property float targetLongitude;

@end
