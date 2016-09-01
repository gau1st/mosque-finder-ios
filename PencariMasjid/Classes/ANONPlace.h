//
//  ANONPlace.h
//  PencariMasjid
//
//  Created by Himawan Putra on 11/4/12.
//  Copyright (c) 2012 Himawan Putra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ANONPlace : NSObject

-(void) near:(CLLocationCoordinate2D) coordinate distance:(float)meters callback:(void(^)(NSDictionary*))cb;
-(void) getImage:(NSString*) idVenue callback:(void(^)(NSDictionary*))cb;

@end
