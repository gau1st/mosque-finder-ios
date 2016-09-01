//
//  PoiDetailViewController.m
//  PencariMasjid
//
//  Created by Himawan Putra on 11/4/12.
//  Copyright (c) 2012 Himawan Putra. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "PoiDetailViewController.h"
#import "ANONPlace.h"
#import "UIImage+animatedGIF.h"

@interface PoiDetailViewController ()

@end

@implementation PoiDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.name.text = self.theName;
    self.address.text = self.theAddress;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    self.mosqueImage.image = [UIImage animatedImageWithAnimatedGIFURL:url duration:2];

    
        
        ANONPlace *PhotoApi = [[ANONPlace alloc] init];
        
        [PhotoApi getImage:self.idVenue callback:^(NSDictionary *response) {
            
            NSArray *photos = response[@"response"][@"photos"][@"items"];
            //NSString *msg = [NSString stringWithFormat:@"There are %i Photos Found", [photos count]];
            //UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Photos Found"
            //                                                  message:msg
            //                                                 delegate:nil
            //                                        cancelButtonTitle:@"OK"
            //                                        otherButtonTitles:nil];
            //[message show];
            if ([photos count] != 0) {
                
                dispatch_async(kBgQueue, ^{
                
                    NSString *prefix = response[@"response"][@"photos"][@"items"][[photos count]-1][@"prefix"];
                    NSString *width = response[@"response"][@"photos"][@"items"][[photos count]-1][@"width"];
                    NSString *height = response[@"response"][@"photos"][@"items"][[photos count]-1][@"height"];
                    NSString *suffix = response[@"response"][@"photos"][@"items"][[photos count]-1][@"suffix"];
                    //self.urlImage = [NSString stringWithFormat:@"%@%@x%@%@", prefix, width, height, suffix];
                    //self.mosqueImage.ima
                
                    NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@x%@%@", prefix, width, height, suffix]]];
                
                    UIImage* image = [[UIImage alloc] initWithData:imageData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.mosqueImage.image = image;
                    });
                    
                });
                
            } else {
                NSLog(@"NO PHOTOS");
                self.mosqueImage.image = [UIImage imageNamed:@"silhouette.png"];
            }
            
        }];
        
   
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)directionButton:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", self.currentLatitude, self.currentLongitude, self.targetLatitude, self.targetLongitude]]];
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setAddress:nil];
    [self setMosqueImage:nil];
    [self setName:nil];
    [self setAddress:nil];
    [super viewDidUnload];
}
@end
