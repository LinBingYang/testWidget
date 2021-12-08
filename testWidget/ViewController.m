//
//  ViewController.m
//  testWidget
//
//  Created by Admin on 2020/10/16.
//

#import "ViewController.h"
#import "WzLocationInfos.h"
#import "testWidget-Swift.h"
#import "TreeNode.h"
#import "GetXMLData.h"

@interface ViewController ()<GetXMLDelegate>
@property(nonatomic,strong)WzLocationInfos *LocationInfo;//定位查询

@property(nonatomic,strong)NSMutableArray *arealists;//定位查询
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor redColor];
    self.arealists=[[NSMutableArray alloc]init];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
    [btn setTitle:@"鼓楼区" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.center=self.view.center;
    NSString *district=[[NSUserDefaults standardUserDefaults] objectForKey:@"district"];
    [btn setTitle:district forState:UIControlStateNormal];
    
    [[GetXMLData alloc] startRead:@"areaList" withObject:self withFlag:1];
   
    
}
-(void)btnaction{
    mainViewController *mvc=[mainViewController new];
    [self presentViewController:mvc animated:YES completion:^{
        
    }];
    
}
#pragma mark xml delegate

-(void)readFinish:(TreeNode *)p_treeNode withFlag:(int)p_flag
{
    [p_treeNode.children enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
        TreeNode *t_node = [p_treeNode.children objectAtIndex:idx];
        TreeNode *t_node_child = [t_node.children objectAtIndex:2];
        TreeNode *t_node_child1 = [t_node.children objectAtIndex:1];
        NSString *name = [NSString stringWithFormat:@"%@",t_node_child.leafvalue];
        NSString *areaId = [NSString stringWithFormat:@"%@",t_node_child1.leafvalue];
        NSDictionary *dic=@{@"name":name,@"areaid":areaId};
        [self.arealists addObject:dic];
    }];
    
    self.LocationInfo=[WzLocationInfos new];
    [self.LocationInfo startLocationWithScucessinfo:^(NSDictionary *locationinfo) {
        NSLog(@"***%@",locationinfo);
        NSString *district=[locationinfo objectForKey:@"district"];
        NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.pcs.testWidget"];
        [userDf setObject:@"72321" forKey:@"currentCityID"];
        [userDf setObject:district forKey:@"currentCity"];
        [userDf setObject:self.arealists forKey:@"arealist"];
        [userDf synchronize];
//        [btn setTitle:district forState:UIControlStateNormal];

        WidgetManager *wm=[[WidgetManager alloc]init];
        [wm reloadAlltimelines];
        } WithFailure:^(NSString *error) {
            NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.pcs.testWidget"];
            [userDf setObject:@"72321" forKey:@"currentCityID"];
            [userDf setObject:@"鼓楼区" forKey:@"currentCity"];
            [userDf synchronize];
        }];

}
@end
