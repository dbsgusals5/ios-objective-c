//
//  DataController.m
//  iPadCourceYun
//
//  Created by alpha on 2019/10/10.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "DataController.h"
#import <iCommonNetworkConnection/iCommonNetworkConnection.h>
#import "AppDelegate.h"
#import "LoadingProcess.h"


@interface DataController()
@property (copy, nonatomic) completeBlock requestBlock;

@end
@implementation DataController


+(void)dbConn:(NSString *)authId dic:(NSDictionary *)dic initMode:(int)initMode complete:(completeBlock)complete{
    NSString *url = @"";
    
    NSString *authUserId = authId;
    
    NSDictionary *dictionary = dic;
    DataController *dataController = [[DataController alloc] init];
    dataController.requestBlock = complete;
    // モード、モード枝番、接続先URL、共通パラメータ（個人認証ID）を指定して通信オブジェクトを作成
    iCommonNetworkConnection *conn = [[iCommonNetworkConnection alloc] initWithMode:initMode procMode:1
                                                                                url:url authUserId:authUserId];
    if (conn) {
        NSError *error;
        // 問い合わせのための設定を作成
        NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
        [LoadingProcess showLoading];
        [conn appendDataByString:@"&individual="];
        [conn appendData:json];
        [conn deposit:dictionary];
        // 通信終了時に（通信結果の成否に問わず）connectionDidFinishLoading 関数が呼び出される
        [conn getJson:dataController callbackTo:@"connectionDidFinishLoading" withCancelDialog:NO timeoutFlg:YES];
    }
}
- (void)connectionDidFinishLoading:(NSDictionary *)dic with:(NSDictionary *)stock {
    
    if (!dic || [dic[@"responseStatus"][@"status"] integerValue] == -1) {
        // 通信s
        NSLog(@"失敗");
        [LoadingProcess hideLoading];
    }
    else {
        // 受信成功
        NSLog(@"成功");
        NSLog(@"%@", dic);
        self.requestBlock(dic);
        [LoadingProcess hideLoading];
    }
}


@end
