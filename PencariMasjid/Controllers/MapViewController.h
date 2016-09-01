//
//  MapViewController.h
//  PencariMasjid
//
//  Created by Himawan Putra on 11/3/12.
//  Copyright (c) 2012 Himawan Putra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, ADBannerViewDelegate>
{
    CLLocation *prevLocation;
    CLLocation *currentLocation;
    Boolean isBannerVisible;
}

@property (assign, nonatomic) MKMapType mapType;

@end
