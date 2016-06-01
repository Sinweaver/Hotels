//
//  HLHotelLoader.m
//  HotelsLite
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Alexander Borovikov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "HLHotelLoader.h"

#import "HLHotel.h"

//#define BASE_URL @"https://raw.githubusercontent.com/Sinweaver/HotelsJson/master/"
#define BASE_URL @"http://localhost/HotelsJson/"
static NSString * const kServerHotelsUrl = BASE_URL @"hotelsList.json";

@interface HLHotelLoader ()

@property(strong, nonatomic) NSURLSession *session;
@property(strong, nonatomic) NSCache *imageCache;
@property(strong, nonatomic) NSMutableArray<__kindof NSURLSessionTask *> *requests;

@end

@implementation HLHotelLoader

#pragma mark - SharedInstance
+ (nullable instancetype)sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    //static id sharedObject = nil;  //if you're not using ARC
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
        //_sharedObject = [[[self alloc] init] retain]; // if you're not using ARC
    });
    return _sharedObject;
}

#pragma mark - Initialization Methods
- (instancetype)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(cleanMemory:)
         name:UIApplicationDidReceiveMemoryWarningNotification
         object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self cancelAllRequests];
}

- (void)cancelAllRequests {
    for (NSUInteger i = 0; i < self.requests.count; i++) {
        [self.requests[i] cancel];
    }
    
    [self.requests removeAllObjects];
}

- (void)fetchDataWithURL:(NSURL *)url addTask:(BOOL)addTask
                   block:(void (^)(NSData * _Nullable data))block {
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    __weak typeof(self) weakSelf = self;
    void(^completionHandler)(NSData *, NSURLResponse *, NSError *) =
    ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(self)strongSelf = weakSelf;
        
        [strongSelf.requests removeObject:dataTask];
        
        if (block) {
            block(data);
        }
    };
    
    dataTask = [self.session dataTaskWithURL:url completionHandler:completionHandler];
    if (addTask) {
        [self.requests addObject:dataTask];
    }
    
    [dataTask resume];
}

- (void)fetchHotelsWithBlock:(nullable HotelsCompletedBlock)block {
    NSURL *url = [NSURL URLWithString:kServerHotelsUrl];
    
    [self fetchDataWithURL:url addTask:NO block:^(NSData * _Nullable data) {
        NSArray<HLHotel *> *result = nil;
        
        if (data) {
            NSError *jsonError = nil;
            NSArray *jsonHotels = [NSJSONSerialization JSONObjectWithData:data options:0
                                                                    error:&jsonError];
            if (!jsonError) {
                NSMutableArray<HLHotel *> *hotels = [NSMutableArray array];
                for (id object in jsonHotels) {
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        [hotels addObject:[HLHotel hotelWithDictionary:object]];
                    }
                }
                
                result = [hotels copy];
            }
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
    }];
}

- (void)fetchHotelImageWithName:(nullable NSString *)name caching:(BOOL)caching
                          block:(nullable HotelImagesCompletedBlock)block {
    
    UIImage *currentImage = [self.imageCache objectForKey:name];
    if (currentImage) {
        if (block) {
            block(currentImage);
        }
        
        return;
    }
    
    NSString *fullImagePath = [NSString stringWithFormat:@"%@%@", BASE_URL, name];
    NSURL *url = [NSURL URLWithString:fullImagePath];
    
    __weak typeof(self) weakSelf = self;
    [self fetchDataWithURL:url addTask:YES block:^(NSData * _Nullable data) {
        __strong typeof(self)strongSelf = weakSelf;
        
        UIImage *resultImage = nil;
        
        if (data) {
            resultImage = [UIImage imageWithData:data];
            
            if (resultImage && caching) {
                [strongSelf.imageCache setObject:resultImage forKey:name];
            }
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(resultImage);
            });
        }
    }];
}

#pragma mark - Memory notification
- (void)cleanMemory:(NSNotification *)notification {
    [self.imageCache removeAllObjects];
}

#pragma mark - Getters (Private)
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    }
    return _session;
}

- (NSCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSCache alloc] init];
    }
    
    return _imageCache;
}

- (NSMutableArray<NSURLSessionTask *> *)requests {
    if (!_requests) {
        _requests = [NSMutableArray array];
    }
    
    return _requests;
}

@end
