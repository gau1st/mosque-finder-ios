//
//  ANONPlace.m
//  PencariMasjid
//
//  Created by Himawan Putra on 11/4/12.
//  Copyright (c) 2012 Himawan Putra. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "ANONPlace.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@implementation ANONPlace

-(void) near:(CLLocationCoordinate2D) coordinate distance:(float)meters callback:(void(^)(NSDictionary*))cb
{
    float latitude = coordinate.latitude;
    float longitude = coordinate.longitude;
    
    NSString *url = [NSString stringWithFormat:@"http://anonim.myapp.jit.su/1.0/places/near/%f/%f", longitude, latitude];
    NSLog(@"aaaa %@", url);
    //Formulate the string as a URL object.
    NSURL *requestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: requestURL];
        
        if(data == NULL)
        {
            NSLog(@"something wrong with API");
            
            NSDictionary * response = @{@"stat": @"fail", @"code":@"0", @"message":@"API can not be contacted"};
            
            //return cb(response);
            dispatch_async(dispatch_get_main_queue(), ^{
                cb(response);
            });
            return;
        }
        
        NSError* error;
        NSDictionary* results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]; //1
        
        //NSArray* venues = [json objectForKey:@"pois"]; //2
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cb(results);
        });
    });
    
}

-(void) getImage:(NSString *)idVenue callback:(void(^)(NSDictionary*))cb
{
    
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?group=venue&oauth_token=XOFMXDG0Z15UAZ1XQI2VAU04D02NBIH55GBQXXNUHLF4QXEL&v=20121108", idVenue];
    //Formulate the string as a URL object.
    NSURL *requestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: requestURL];
        
        if(data == NULL)
        {
            NSLog(@"something wrong with API");
            
            NSDictionary * response = @{@"stat": @"fail", @"code":@"0", @"message":@"API can not be contacted"};
            
            //return cb(response);
            dispatch_async(dispatch_get_main_queue(), ^{
                cb(response);
            });
            return;
        }
        
        NSError* error;
        NSDictionary* results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]; //1
        
        //NSLog(@"aaaaasssss %@", results);
        
        //NSString *test = results[@"response"][@"photos"][@"items"][0][@"prefix"];
        //NSLog(@"test: %@", test);
        
        //NSArray* venues = [json objectForKey:@"pois"]; //2
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cb(results);
        });
    });
    
}

- (void)doMathWithBlock:(int (^)(int, int))mathBlock {
    //self.label.text = [NSString stringWithFormat:@"%d", mathBlock(3, 5)];
}

@end
