//
//  XYNetworkRequest.m
//  XYNetworkDemo
//
//  Created by mofeini on 16/12/2.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  主要是做GET、POST请求，请求完成后直接以数组或者字典的形式返回

#import "XYNetworkRequest.h"
#import "AFNetworking.h"

/**
 * 请求成功回调的block
 */
typedef void(^RequestSuccessCallBack)(NSURLSessionDataTask *task, id responseObject);
/**
 * 请求失败回调的block
 */
typedef void(^RequestFailureCallBack)(NSURLSessionDataTask *task, NSError *error);

@interface XYNetworkRequest ()


@end

@implementation XYNetworkRequest
/**
 * 判断网络状态是否可以使用的属性，当为YES时网络可以使用，NO则不能使用网络
 */
static BOOL _isNetworkUse;


/**
 * 根据传入的请求方式发送网络请求
 */
+ (void)request:(XYNetworkRequestType)type url:(NSString *)urlStr parameters:(NSDictionary *)parameters progress:(ProgressCallBack)progress finished:(FinishedCallBack)finishedCallBack {
    
    // 定义请求成功回调的block
    RequestSuccessCallBack successCallBack = ^(NSURLSessionDataTask *task, id responseObject){
        finishedCallBack(responseObject, nil);
    };
    
    // 定义请求失败回调的block
    RequestFailureCallBack failureCallBack = ^(NSURLSessionDataTask *task,NSError *error){
        finishedCallBack(nil, error);
    };
    
    // 根据type发送网络请求
    if (type == XYNetworkRequestTypeGET) {
        [self.manager GET:urlStr parameters:parameters progress:nil success:successCallBack failure:failureCallBack];
    }
    
    if (type == XYNetworkRequestTypePOST) {
        [self.manager POST:urlStr parameters:parameters progress:nil success:successCallBack failure:failureCallBack];
    }
    
    if (type == XYNetworkRequestTypePUT) {
        [self.manager PUT:urlStr parameters:parameters success:successCallBack failure:failureCallBack];
    }
    
    if (type == XYNetworkRequestTypeDELETE) {
        [self.manager DELETE:urlStr parameters:parameters success:successCallBack failure:failureCallBack];
    }
}

/**
 * 下载文件请求
 */
+ (void)downloadRequest:(NSString *)url progress:(ProgressCallBack)progressHandler complete:(FinishedCallBack)completionHandler {
    
    // 下载之前，先检查网络是否可用，若不可用就不必下载
    if (![self checkNewworkStatus]) {
        progressHandler(0, 0, 0);
        completionHandler(nil, nil);
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        // suggestedFilename获取文件名
        return [documentURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        completionHandler(response, error);
    }];
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];

    [downloadTask resume];
}

/**
 * 上传文件请求
 */
+ (void)updateRequest:(NSString *)url parameters:(NSDictionary *)parameters fileConfig:(XYFileConfig *)fileConfig finished:(FinishedCallBack)finishedCallBack {
    
    // 定义请求成功的block
    RequestSuccessCallBack successCallBack = ^(NSURLSessionDataTask *task, id responseObject){
        finishedCallBack(responseObject, nil);
    };
    
    // 定义请求失败的block
    RequestFailureCallBack failureCallBack = ^(NSURLSessionDataTask *task, NSError *error){
        finishedCallBack(nil, error);
    };
    
    // 发送POST请求
    [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileConfig.fileData name:fileConfig.name fileName:fileConfig.fileNmae mimeType:fileConfig.mimeType];
        
    } progress:nil success:successCallBack failure:failureCallBack];
    
}



+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 10; // 请求超时时间
    return manager;
}

/**
 * 监控网络状态
 */
+ (BOOL)checkNewworkStatus {
    AFNetworkReachabilityManager *reachabiltyMnaager = [AFNetworkReachabilityManager sharedManager];
    
    [reachabiltyMnaager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 网络状态不清楚
                _isNetworkUse = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 网络异常
                _isNetworkUse = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 蜂窝网络
                _isNetworkUse = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI网络
                _isNetworkUse = YES;
                break;
                
            default:
                break;
        }
    }];
    
    [reachabiltyMnaager startMonitoring];
    return _isNetworkUse;
}




@end

@implementation XYFileConfig

- (instancetype)initWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    
    if (self = [super init]) {
        self.fileData = fileData;
        self.name = name;
        self.fileNmae = fileName;
        self.mimeType = mimeType;
    }
    return self;
}

+(instancetype)fileConfigWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    
    return [[self alloc] initWithfileData:fileData name:name fileName:fileName mimeType:mimeType];
}

@end
