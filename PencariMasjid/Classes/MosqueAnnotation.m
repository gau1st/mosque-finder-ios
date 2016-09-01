//
//  MosqueAnnotation.m
//  PencariMasjid
//
//  Created by Himawan Putra on 11/4/12.
//  Copyright (c) 2012 Himawan Putra. All rights reserved.
//

#import "MosqueAnnotation.h"

@implementation MosqueAnnotation

- initWithName:(NSString*)name idVenue:(NSString*)idVenue address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        self.name = name;
        self.idVenue = idVenue;
        self.address = address;
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return self.name;
}

- (NSString *)subtitle {
    return self.address;
}

@end
