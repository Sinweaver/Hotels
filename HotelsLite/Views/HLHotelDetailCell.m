//
//  HLHotelDetailCell.m
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

#import "HLHotelDetailCell.h"

#import "HLLayoutHelper.h"
#import "HCSStarRatingView.h"

@interface HLHotelDetailCell ()

@property(strong, nonatomic) UIImageView *locationImageView;
@property(strong, nonatomic) UIImageView *phoneImageView;

@property(strong, nonatomic) NSArray *layoutConstraints;

@end

@implementation HLHotelDetailCell

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
        
        [self.contentView addSubview:self.hotelNameLabel];
        [self.contentView addSubview:self.hotelStars];
        [self.contentView addSubview:self.hotelAddressLabel];
        [self.contentView addSubview:self.hotelPhoneLabel];
        [self.contentView addSubview:self.locationImageView];
        [self.contentView addSubview:self.phoneImageView];
        
        [NSLayoutConstraint activateConstraints:self.layoutConstraints];
    }
    return self;
}

#pragma mark - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Getters (Public)
- (UILabel *)hotelNameLabel {
    if (!_hotelNameLabel) {
        _hotelNameLabel = [[UILabel alloc] init];
        _hotelNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _hotelNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _hotelNameLabel.textColor = [UIColor blackColor];
        _hotelNameLabel.numberOfLines = 0;
        _hotelNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
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
        _hotelAddressLabel.numberOfLines = 0;
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
        _hotelStars.maximumValue = 5;
        _hotelStars.minimumValue = 0;
        _hotelStars.value = 0;
        [_hotelStars setUserInteractionEnabled:NO];
    }
    
    return _hotelStars;
}

- (UILabel *)hotelPhoneLabel {
    if (!_hotelPhoneLabel) {
        _hotelPhoneLabel = [[UILabel alloc] init];
        _hotelPhoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _hotelPhoneLabel.font = [UIFont systemFontOfSize:12.0];
        _hotelPhoneLabel.textColor = [UIColor blackColor];
        _hotelPhoneLabel.numberOfLines = 0;
        _hotelPhoneLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _hotelPhoneLabel.text = @"<phone>";
    }
    
    return _hotelPhoneLabel;
}

#pragma mark - Getters (Private)
- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _locationImageView.contentMode = UIViewContentModeCenter;
        _locationImageView.image = [UIImage imageNamed:@"Location"];
    }
    
    return _locationImageView;
}

- (UIImageView *)phoneImageView {
    if (!_phoneImageView) {
        _phoneImageView = [[UIImageView alloc] init];
        _phoneImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _phoneImageView.contentMode = UIViewContentModeCenter;
        _phoneImageView.image = [UIImage imageNamed:@"Phone"];
    }
    
    return _phoneImageView;
}

- (NSArray *)layoutConstraints {
    if (!_layoutConstraints) {
        NSDictionary *views = @{@"hotelNameLabel" : self.hotelNameLabel,
                                @"hotelAddressLabel" : self.hotelAddressLabel,
                                @"hotelStars" : self.hotelStars,
                                @"hotelPhoneLabel" : self.hotelPhoneLabel,
                                @"locationImageView" : self.locationImageView,
                                @"phoneImageView" : self.phoneImageView};
        
        NSArray *formatArray = @[@"V:|-10-[hotelNameLabel]-10-[hotelStars(10)]",
                                 @"V:[hotelStars]-10-[hotelAddressLabel]-10-[hotelPhoneLabel]-10-|",
                                 @"V:[hotelStars]-10-[locationImageView(==hotelAddressLabel)]",
                                 @"V:[hotelAddressLabel]-10-[phoneImageView(==hotelPhoneLabel)]",
                                 
                                 @"H:|-10-[hotelNameLabel]-10-|",
                                 @"H:|-10-[locationImageView(15)]-5-[hotelAddressLabel]-10-|",
                                 @"H:|-10-[phoneImageView(15)]-5-[hotelPhoneLabel]-10-|",
                                 @"H:|-10-[hotelStars(80)]"];
        
        _layoutConstraints = [HLLayoutHelper constraintsWithFormatArray:formatArray
                                                                options:0
                                                                metrics:nil
                                                                  views:views];
    }
    
    return _layoutConstraints;
}

@end
