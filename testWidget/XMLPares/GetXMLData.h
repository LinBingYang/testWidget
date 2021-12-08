//
//  GetXMLData.h
//  WeatherForecast
//
//  Created by superman on 10-11-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"

@protocol GetXMLDelegate <NSObject>
@required
-(void)readFinish:(TreeNode *)p_treeNode withFlag:(int)p_flag;
@end

@interface GetXMLData : NSObject <NSXMLParserDelegate>{

	id <GetXMLDelegate> delegate;
	int m_flag;
	NSString *m_saveStr;
}
-(void)startRead:(NSString *)p_fileName withObject:(id)p_object withFlag:(int)p_flag;
-(void)readData:(NSString *)p_fileName;
-(void)readFinish:(TreeNode *)p_treeNode;
@end
