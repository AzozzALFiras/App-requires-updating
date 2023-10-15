// Developer by : Azozz ALFiras

@interface AppStoreInfoApp 
- (void)sentRequestWithBundleId:(NSString *)bundleId completion:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))completion;
- (void)getInfoAppWithBundleId:(NSString *)bundleId version:(NSString *)version completion:(void (^)(NSDictionary * _Nullable))completion;
- (NSDictionary *)responseApiWithStatus:(NSString *)status url:(NSString *)url;
@end 

@implementation AppStoreInfoApp

- (void)sentRequestWithBundleId:(NSString *)bundleId completion:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", bundleId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (!jsonError) {
            completion(json, nil);
        }
    }];
    
    [task resume];
}

- (void)getInfoAppWithBundleId:(NSString *)bundleId version:(NSString *)version completion:(void (^)(NSDictionary * _Nullable))completion {
    [self sentRequestWithBundleId:bundleId completion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            NSString *vAppStore = data[@"version"];
            NSString *appLink = data[@"trackViewUrl"];
            
            if ([vAppStore isEqualToString:version]) {
                completion([self responseApiWithStatus:@"Yes" url:appLink]);
            } else {
                completion([self responseApiWithStatus:@"No" url:appLink]);
            }
        }
    }];
}

- (NSDictionary *)responseApiWithStatus:(NSString *)status url:(NSString *)url {
    if ([status isEqualToString:@"Yes"]) {
        return @{
            @"status": @"success",
            @"status_message": @"There is no application update"
        };
    } else {
        return @{
            @"status": @"failed",
            @"status_message": @"The version does not match. An update is required",
            @"app_link": url
        };
    }
}

@end
