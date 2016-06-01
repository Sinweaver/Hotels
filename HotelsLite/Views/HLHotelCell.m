//
//  HLHotelCell.m
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

#import "HLHotelCell.h"

#import "HLHotel.h"
#import "HCSStarRatingView.h"

#import "NSLayoutConstraint+HLConstraints.h"

@interface HLHotelCell ()

@property(strong, nonatomic) NSArray *layoutConstraints;

@end

@implementation HLHotelCell

#pragma mark - Initializer
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
        self.separatorInset = UIEdgeInsetsZero;
        
        UIView *selectView = [[UIView alloc] init];
        selectView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        self.selectedBackgroundView = selectView;
        
        [self.contentView addSubview:self.hotelImageView];
        [self.contentView addSubview:self.hotelNameLabel];
        [self.contentView addSubview:self.hotelAddressLabel];
        [self.contentView addSubview:self.hotelStars];
        
        [NSLayoutConstraint activateConstraints:self.layoutConstraints];
    }
    return self;
}

- (void)configureWithModel:(HLHotel *)model {
    self.hotelNameLabel.text = model.hotelName;
    self.hotelAddressLabel.text = model.hotelAddress;
}

#pragma mark - Lifecycle
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Getters (Public)
- (UIImageView *)hotelImageView {
    if (!_hotelImageView) {
        _hotelImageView = [[UIImageView alloc] init];
        _hotelImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _hotelImageView.backgroundColor = [UIColor colorWithWhite:0.95
                                                            alpha:1.0];
        _hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
        _hotelImageView.clipsToBounds = YES;
    }
    
    return _hotelImageView;
}

- (UILabel *)hotelNameLabel {
    if (!_hotelNameLabel) {
        _hotelNameLabel = [[UILabel alloc] init];
        _hotelNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _hotelNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _hotelNameLabel.textColor = [UIColor blackColor];
        _hotelNameLabel.numberOfLines = 1;
        _hotelNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _hotelNameLabel.text = @"<name>";
    }
    
    return _hotelNameLabel;
}

- (UILabel *)hotelAddressLabel {
    if (!_hotelAddressLabel) {
        _hotelAddressLabel = [[UILabel alloc] init];
        _hotelAddressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _hotelAddressLabel.font = [UIFont systemFontOfSize:12.0];
        _hotelAddressLabel.textColor = [UIColor blackColor];
        _hotelAddressLabel.numberOfLines = 2;
        _hotelAddressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _hotelAddressLabel.text = @"<address>";
    }
    
    return _hotelAddressLabel;
}

- (HCSStarRatingView *)hotelStars {
    if (!_hotelStars) {
        _hotelStars = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        _hotelStars.translatesAutoresizingMaskIntoConstraints = NO;
        _hotelStars.tintColor = [UIColor blackColor];
        _hotelStars.userInteractionEnabled = NO;
        _hotelStars.maximumValue = 5;
        _hotelStars.minimumValue = 0;
        _hotelStars.value = 0;
    }
    
    return _hotelStars;
}

#pragma mark - Getters (Private)
- (NSArray *)layoutConstraints {
    if (!_layoutConstraints) {
        NSDictionary *views = @{@"hotelImageView" : self.hotelImageView,
                                @"hotelNameLabel" : self.hotelNameLabel,
                                @"hotelAddressLabel" : self.hotelAddressLabel,
                                @"hotelStars" : self.hotelStars};
        
        NSArray *formatArray = @[@"V:|-0-[hotelImageView]-0-|",
                                 @"V:|-10-[hotelNameLabel]-10-[hotelStars(10)]",
                                 @"V:[hotelStars]-(>=10)-[hotelAddressLabel]-10-|",
                                 
                                 @"H:|-0-[hotelImageView(120)]-10-[hotelNameLabel]-10-|",
                                 @"H:[hotelImageView]-10-[hotelAddressLabel]-10-|",
                                 @"H:[hotelImageView]-10-[hotelStars(80)]"];
        
        _layoutConstraints = [NSLayoutConstraint constraintsWithFormatArray:formatArray
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    }
    
    return _layoutConstraints;
}

@end
