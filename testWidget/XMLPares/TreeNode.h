/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

//
//  TreeNode.h
//  Created by Erica Sadun on 4/6/09. Updated 4/26
//

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
@interface TreeNode : NSObject
{
	TreeNode		*parent;
	NSMutableArray	*children;
	NSDictionary   *attribute;
	NSString		*key;
	NSString		*leafvalue;
}
@property (nonatomic, strong) 	TreeNode		*parent;
@property (nonatomic, strong) 	NSMutableArray	*children;
@property (nonatomic, strong) NSDictionary   *attribute;
@property (nonatomic, strong) 	NSString		*key;
@property (nonatomic, strong) 	NSString		*leafvalue;

@property (nonatomic, readonly) BOOL			isLeaf;
@property (nonatomic, readonly) BOOL			hasLeafValue;

@property (nonatomic, readonly) NSArray			*keys;
@property (nonatomic, readonly) NSArray			*allKeys;
@property (nonatomic, readonly) NSArray			*uniqKeys;
@property (nonatomic, readonly) NSArray			*uniqAllKeys;
@property (nonatomic, readonly) NSArray			*leaves;
@property (nonatomic, readonly) NSArray			*allLeaves;

@property (nonatomic, readonly) NSString		*dump;


+ (TreeNode *) treeNode;
- (NSString *) dump;
- (void) teardown;

// Leaf Utils
- (BOOL) isLeaf;
- (BOOL) hasLeafValue;
- (NSArray *) leaves;
- (NSArray *) allLeaves;

// Key Utils
- (NSArray *) keys; 
- (NSArray *) allKeys; 
- (NSArray *) uniqKeys;
- (NSArray *) uniqAllKeys;


// Search Utils
- (TreeNode *) objectForKey: (NSString *) aKey;
- (NSString *) leafForKey: (NSString *) aKey;
- (NSMutableArray *) objectsForKey: (NSString *) aKey;
- (NSMutableArray *) leavesForKey: (NSString *) aKey;
- (TreeNode *) objectForKeys: (NSArray *) keys;
- (NSString *) leafForKeys: (NSArray *) keys;

// Convert Utils
- (NSMutableDictionary *) dictionaryForChildren;
@end
