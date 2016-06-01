//
//  HLHotel.h
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

#import <Foundation/Foundation.h>

@interface HLHotel : NSObject

@property(strong, nonatomic, nullable) NSNumber *hotelID;
@property(strong, nonatomic, nullable) NSNumber *hotelStars;
@property(strong, nonatomic, nullable) NSArray *hotelImagesPath;

@property(copy, nonatomic, nullable) NSString *hotelName;
@property(copy, nonatomic, nullable) NSString *hotelAddress;
@property(copy, nonatomic, nullable) NSString *hotelPhone;
@property(copy, nonatomic, nullable) NSString *hotelDescription;

+ (nullable instancetype)hotelWithID:(nullable NSNumber *)hotelID
                           hotelName:(nullable NSString *)hotelName
                        hotelAddress:(nullable NSString *)hotelAddress
                          hotelPhone:(nullable NSString *)hotelPhone
                          hotelStars:(nullable NSNumber *)hotelStars
                     hotelImagesPath:(nullable NSArray *)hotelImagesPath
                    hotelDescription:(nullable NSString *)hotelDescription;

+ (nullable instancetype)hotelWithDictionary:(nonnull NSDictionary *)dict;

- (nullable instancetype)initWithID:(nullable NSNumber *)hotelID
                          hotelName:(nullable NSString *)hotelName
                       hotelAddress:(nullable NSString *)hotelAddress
                         hotelPhone:(nullable NSString *)hotelPhone
                         hotelStars:(nullable NSNumber *)hotelStars
                    hotelImagesPath:(nullable NSArray *)hotelImagesPath
                   hotelDescription:(nullable NSString *)hotelDescription;

- (nullable instancetype)initWithDictionary:(nonnull NSDictionary *)dict;

@end

//Response example:
//"id": 1,
//"name": "Refinery Hotel",
//"address": "63 West 38th Street, New York, NY 10018, United States",
//"phone": "+1 646 664 0310",
//"stars": 5,
//"images": [
//           "Refinery_00001.jpg",
//           "Refinery_00002.jpg",
//           "Refinery_00003.jpg",
//           "Refinery_00004.jpg",
//           "Refinery_00005.jpg",
//           "Refinery_00006.jpg",
//           "Refinery_00007.jpg"
//           ],
//"description": "Местоположение отеля."
