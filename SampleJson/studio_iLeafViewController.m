//
//  studio_iLeafViewController.m
//  SampleJson
//
//  Created by 平杉 敦史 on 12/08/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "studio_iLeafViewController.h"

@interface studio_iLeafViewController ()

@end

@implementation studio_iLeafViewController

@synthesize activeDownload;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSString *string = @"http://lbs-stg.mapion.co.jp/map/uc/PoiCircle?grp=cat_m&json=1&oe=utf-8&scl=1&vo=mbml&el=139.748247&nl=35.642581&dist=700&pm=20&start=1";
    
    //NSString *string = @"http://pipes.yahoo.com/pipes/pipe.run?_id=f8bab625ccf0b64b2e0110e3147b6011&_render=json";
    
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:string]] delegate:self];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *str= [[NSString alloc] initWithData:self.activeDownload encoding:NSUTF8StringEncoding];
    int i = [str length];
    str = [str substringWithRange:NSMakeRange(1,i-4)];
    NSLog(@"%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // jsonの前後にある『();』のかっことコロンを削除するとパースが可能
    
    NSError *error=nil;
    //NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:self.activeDownload  options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"jsonObject = %@", [jsonObject description]);
}

@end
