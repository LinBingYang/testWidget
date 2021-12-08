//
//  GetXMLData.m
//  WeatherForecast
//
//  Created by superman on 10-11-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GetXMLData.h"

#import "XMLParser.h"

@implementation GetXMLData

-(void)startRead:(NSString *)p_fileName withObject:(id)p_object withFlag:(int)p_flag
{
	m_flag = p_flag;
	delegate = p_object;
	
	m_saveStr = [[NSString alloc] initWithString:p_fileName];
//    [self readData:p_fileName];
	[self performSelectorInBackground:@selector(readData:) withObject:p_fileName];
}
-(void)readData:(NSString *)p_fileName
{
    @autoreleasepool {
        NSString *fileOfThePath= [[NSBundle mainBundle] pathForResource:p_fileName ofType:@"xml"] ;
        NSData *t_data = [NSData dataWithContentsOfFile:fileOfThePath];
        __strong TreeNode * root = [[XMLParser sharedInstance] parseXMLFromData:t_data];
//        [self readFinish:root];
        [self performSelectorOnMainThread:@selector(readFinish:) withObject:root waitUntilDone:NO];
    }
}

-(void)readFinish:(TreeNode *)p_treeNode
{
	
	if(delegate != nil)
		[delegate readFinish:p_treeNode withFlag:m_flag];

}

@end
