//
//  HLHotel.m
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

#import "HLHotel.h"

@implementation HLHotel

+ (nullable instancetype)hotelWithID:(nullable NSNumber *)hotelID
                           hotelName:(nullable NSString *)hotelName
                        hotelAddress:(nullable NSString *)hotelAddress
                          hotelPhone:(nullable NSString *)hotelPhone
                          hotelStars:(nullable NSNumber *)hotelStars
                     hotelImagesPath:(nullable NSArray *)hotelImagesPath
                    hotelDescription:(nullable NSString *)hotelDescription {
    
    return [[self alloc] initWithID:hotelID
                          hotelName:hotelName
                       hotelAddress:hotelAddress
                         hotelPhone:hotelPhone
                         hotelStars:hotelStars
                    hotelImagesPath:hotelImagesPath
                   hotelDescription:hotelDescription];
}

+ (nullable instancetype)hotelWithDictionary:(nonnull NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (nullable instancetype)initWithID:(nullable NSNumber *)hotelID
                          hotelName:(nullable NSString *)hotelName
                       hotelAddress:(nullable NSString *)hotelAddress
                         hotelPhone:(nullable NSString *)hotelPhone
                         hotelStars:(nullable NSNumber *)hotelStars
                    hotelImagesPath:(nullable NSArray *)hotelImagesPath
                   hotelDescription:(nullable NSString *)hotelDescription {
    
    self = [super init];
    if (self) {
        _hotelID = hotelID;
        _hotelName = hotelName;
        _hotelAddress = hotelAddress;
        _hotelPhone = hotelPhone;
        _hotelStars = hotelStars;
        _hotelImagesPath = hotelImagesPath;
        _hotelDescription = hotelDescription;
    }
    return self;
}

- (nullable instancetype)initWithDictionary:(nonnull NSDictionary *)dict {
    return [self initWithID:dict[@"id"]
                  hotelName:dict[@"name"]
               hotelAddress:dict[@"address"]
                 hotelPhone:dict[@"phone"]
                 hotelStars:dict[@"stars"]
            hotelImagesPath:dict[@"images"]
           hotelDescription:dict[@"description"]];
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"Hotel %@\n%@\n%@\n%@\n%@\n%@\n%@\n\n",
                             self.hotelID, self.hotelName, self.hotelAddress,
                             self.hotelPhone, self.hotelStars, self.hotelImagesPath,
                             self.hotelDescription];
    return description;
}

@end
