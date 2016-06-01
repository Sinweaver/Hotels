//
//  HLHotelGalleryCell.m
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

#import "HLHotelGalleryCell.h"

#import "NSLayoutConstraint+HLConstraints.h"

@interface HLHotelGalleryCell ()

@property(strong, nonatomic) NSArray *layoutConstraints;

@end

@implementation HLHotelGalleryCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.contentView addSubview:self.hotelImageView];
        [NSLayoutConstraint activateConstraints:self.layoutConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.hotelImageView];
        [NSLayoutConstraint activateConstraints:self.layoutConstraints];
    }
    return self;
}

#pragma mark - Getters (Public)
- (UIImageView *)hotelImageView {
    if (!_hotelImageView) {
        _hotelImageView = [[UIImageView alloc] init];
        _hotelImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _hotelImageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
        _hotelImageView.clipsToBounds = YES;
    }
    
    return _hotelImageView;
}

#pragma mark - Getters (Private)
- (NSArray *)layoutConstraints {
    if (!_layoutConstraints) {
        NSDictionary *views = @{@"hotelImageView" : self.hotelImageView};
        
        NSArray *formatArray = @[@"V:|-0-[hotelImageView]-0-|",
                                 @"H:|-0-[hotelImageView]-0-|"];
        
        _layoutConstraints = [NSLayoutConstraint constraintsWithFormatArray:formatArray
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    }
    
    return _layoutConstraints;
}

@end
