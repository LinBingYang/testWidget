//
//  AMapFoundationConst.h
//  AMapFoundationKit
//
//  Created by JL on 2019/7/22.
//  Copyright © 2019 Amap.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSInteger AMapFoundationNSErrorCode;

//ErrorDomain:文件不存在 错误码:-555555
extern NSErrorDomain const AMapFoundationNSErrorFileDonotExist;
extern AMapFoundationNSErrorCode const AMapFoundationNSErrorFileDonotExistCode;

//ErrorDomain:文件路径不合法 错误码:-555556
extern NSErrorDomain const AMapFoundationNSErrorFilePathInvaild;
extern AMapFoundationNSErrorCode const AMapFoundationNSErrorFilePathInvaildCode;

//ErrorDomain:指定类型的日志文件不存在 错误码:-555557
extern NSErrorDomain const AMapFoundationNSErrorTypeLogDonotExist;
extern AMapFoundationNSErrorCode const AMapFoundationNSErrorTypeLogDonotExistCode;

//ErrorDomain:待上传的数据为空(可能是组装/压缩时出错) 错误码:-555558
extern NSErrorDomain const AMapFoundationNSErrorUploadDataIsEmpty;
extern AMapFoundationNSErrorCode const AMapFoundationNSErrorUploadDataIsEmptyCode;

//ErrorDomain:参数错误 错误码:-444444
extern NSErrorDomain const AMapFoundationNSErrorParametersInvalid;
extern AMapFoundationNSErrorCode const AMapFoundationNSErrorParametersInvalidCode;


extern NSErrorDomain const AMapFoundationNSErrorCloudConfigDisable;
extern AMapFoundationNSErrorCode const AMapFoundationNSErrorCloudConfigDisableCode;

extern NSErrorDomain const AMapFoundationNSErrorNetworkUnusable;
extern AMapFoundationNSErrorCode const AMapFoundationNSErrorNetworkUnusableCode;

extern NSErrorDomain const AMapFoundationNSErrorCurrentworkIsRunning;
extern AMapFoundationNSErrorCode const AMapFoundationNSErrorCurrentworkIsRunningCode;

extern NSErrorDomain const AMapFoundationNSErrorCurrentUploadSizeHaveExcess;
extern AMapFoundationNSErrorCode const AMapFoundationNSErrorCurrentUploadSizeHaveExcessCode;

NS_ASSUME_NONNULL_END
