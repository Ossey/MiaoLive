//
//  XYNetworkRequest.h
//  XYNetworkDemo
//
//  Created by mofeini on 16/12/2.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XYNetworkRequestType) {
    XYNetworkRequestTypeGET = 0,  // GET请求
    XYNetworkRequestTypePOST,     // POST请求
    XYNetworkRequestTypePUT,      // PUT请求
    XYNetworkRequestTypeDELETE,   // DELETE请求
};

/**
 * 请求完成的回调
 */
typedef void(^FinishedCallBack)(id responseObject, NSError *error);

/**
 * 请求响应block
 */
//typedef void(^ReponseCallBack)(id dataObject, NSError *error);

/**
 监听进度响应block
 */
typedef void(^ProgressCallBack)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);


@class XYFileConfig;
@interface XYNetworkRequest : NSObject

/**
 * 根据传入的请求方式发送网络请求
 */
+ (void)request:(XYNetworkRequestType)type url:(NSString *)urlStr parameters:(NSDictionary *)parameters progress:(ProgressCallBack)progress finished:(FinishedCallBack)finishedCallBack;

/**
 * 下载文件，监听文件下载进度
 */
+ (void)downloadRequest:(NSString *)url progress:(ProgressCallBack)progressHandler complete:(FinishedCallBack)completionHandler;

/**
 * 文件上传, 未监听上传进度
 */
+ (void)updateRequest:(NSString *)url parameters:(NSDictionary *)parameters fileConfig:(XYFileConfig *)fileConfig finished:(FinishedCallBack)finishedCallBack;


@end

/**
 *  用来封装上传文件数据的模型类
 */
@interface XYFileConfig : NSObject

/** 上传文件的二进制数据 */
@property (nonatomic, strong) NSData *fileData;
/** 服务器接收的参数 */
@property (nonatomic, copy) NSString *name;
/** 文件名 */
@property (nonatomic, copy) NSString *fileNmae;
/** 文件类型 */
@property (nonatomic, copy) NSString *mimeType;

+ (instancetype)fileConfigWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

- (instancetype)initWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end
                                                                                        
                                                                                        
