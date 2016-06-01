//
//  HLHotelGalleryHeader.m
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

#import "HLHotelGalleryHeader.h"

#import "HLHotelLoader.h"
#import "UIColor+HLColors.h"
#import "HLLayoutHelper.h"
#import "HLHotelGalleryCell.h"

static NSString * const galleryCellId = @"cellCollectionId";

@interface HLHotelGalleryHeader () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout> {
    
    NSArray *_hotelImagesPath;
}

@property(assign, nonatomic) NSInteger currentIndex;
@property(strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) UIImageView *photoIconView;
@property(strong, nonatomic) UILabel *countPhotoLabel;

@property(strong, nonatomic) NSArray *layoutConstraints;

@end

@implementation HLHotelGalleryHeader

#pragma mark - Initializer
- (nullable instancetype)initWithImagePathArray:(nullable NSArray *)images {
    self = [super init];
    if (self) {
        _hotelImagesPath = images;
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        [self addSubview:self.photoIconView];
        [self addSubview:self.countPhotoLabel];
        [self _updateCountPhotoLabel];
        
        [NSLayoutConstraint activateConstraints:self.layoutConstraints];
    }
    return self;
}

#pragma mark - Lifecycle
- (void)layoutSubviews {
    [self.collectionViewLayout invalidateLayout];
    
    [super layoutSubviews];
    
    if (self.hotelImagesPath.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = [[[self.collectionView indexPathsForVisibleItems]
                          firstObject] row];
    
    [self _updateCountPhotoLabel];
}

#pragma mark - Methods (Private)
- (void)_updateCountPhotoLabel {
    if (self.hotelImagesPath.count > 0) {
        self.countPhotoLabel.text = [NSString stringWithFormat:@"%ld/%ld",
                                     self.currentIndex + 1,
                                     self.hotelImagesPath.count];
    }
    else {
        self.countPhotoLabel.text = @"нет фото";
    }
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return self.hotelImagesPath.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HLHotelGalleryCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:galleryCellId
                                                     forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    cell.hotelImageView.image = [UIImage imageNamed:@"HotelEmpty"];
    
    HLHotelLoader *loader = [HLHotelLoader sharedInstance];
    NSString *imagePath = [self.hotelImagesPath objectAtIndex:indexPath.row];
    if (imagePath) {
        [loader fetchHotelImageWithName:imagePath caching:YES block:
         ^(UIImage * _Nullable image) {
             if (image && cell.tag == indexPath.row) {
                 cell.hotelImageView.image = image;
             }
         }];
    }
    
    return cell;
}

#pragma mark - Getters (Private)
- (UICollectionViewFlowLayout *)collectionViewLayout {
    if(!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionViewLayout.scrollDirection =
        UICollectionViewScrollDirectionHorizontal;
        _collectionViewLayout.collectionView.pagingEnabled = YES;
        _collectionViewLayout.minimumLineSpacing = 0.0;
        _collectionViewLayout.minimumInteritemSpacing = 0.0;
        _collectionViewLayout.sectionInset = UIEdgeInsetsZero;
        _collectionViewLayout.footerReferenceSize = CGSizeZero;
        _collectionViewLayout.headerReferenceSize = CGSizeZero;
    }
    
    return _collectionViewLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.collectionViewLayout];
        [_collectionView registerClass:[HLHotelGalleryCell class]
            forCellWithReuseIdentifier:galleryCellId];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.bouncesZoom = NO;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

- (UIImageView *)photoIconView {
    if (!_photoIconView) {
        _photoIconView = [[UIImageView alloc] init];
        _photoIconView.translatesAutoresizingMaskIntoConstraints = NO;
        _photoIconView.contentMode = UIViewContentModeCenter;
        _photoIconView.image = [UIImage imageNamed:@"Photo"];
        _photoIconView.clipsToBounds = YES;
    }
    
    return _photoIconView;
}

- (UILabel *)countPhotoLabel {
    if (!_countPhotoLabel) {
        _countPhotoLabel = [[UILabel alloc] init];
        _countPhotoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _countPhotoLabel.font = [UIFont systemFontOfSize:12.0];
        _countPhotoLabel.textColor = [UIColor whiteColor];
        _countPhotoLabel.numberOfLines = 0;
        _countPhotoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _countPhotoLabel.textAlignment = NSTextAlignmentLeft;
        _countPhotoLabel.text = @"<photo>";
    }
    
    return _countPhotoLabel;
}

- (NSArray *)layoutConstraints {
    if (!_layoutConstraints) {
        NSDictionary *views = @{@"collectionView" : self.collectionView,
                                @"photoIconView" : self.photoIconView,
                                @"countPhotoLabel" : self.countPhotoLabel};
        
        NSArray *formatArray = @[@"V:|-0-[collectionView]-0-|",
                                 @"V:[photoIconView]-20-|",
                                 @"V:[countPhotoLabel]-20-|",
                                 
                                 @"H:|-0-[collectionView]-0-|",
                                 @"H:[photoIconView]-10-[countPhotoLabel(60)]-0-|"];
        
        _layoutConstraints = [HLLayoutHelper constraintsWithFormatArray:formatArray
                                                                options:0
                                                                metrics:nil
                                                                  views:views];
    }
    
    return _layoutConstraints;
}

@end
