//
//  Created by Colin Eberhardt on 26/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "RWTFlickrPhoto.h"
#import "RWTSearchResultsItemViewModel.h"

@interface RWTSearchResultsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageThumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *favouritesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentsIcon;
@property (weak, nonatomic) IBOutlet UIImageView *favouritesIcon;

@end

@implementation RWTSearchResultsTableViewCell

#pragma mark - Private Methods

- (void)setParallax:(CGFloat)value {
    self.imageThumbnailView.transform = CGAffineTransformMakeTranslation(0, value);
}

#pragma mark - CEReactiveView
- (void)bindViewModel:(id)viewModel {
    
    /**
     *  这个代码监听了新的comments和favorites属性，当它们更新lable和image时会更新。最后，ModelView的isVisible属性被设置成YES。table view绑定辅助类只绑定可见的单元格，所以只有少部分ViewModel去请求元数据。
     */
    RWTSearchResultsItemViewModel *photo = viewModel;
    [RACObserve(photo, favorites) subscribeNext:^(NSNumber *x) {
        self.favouritesLabel.text = [x stringValue];
        self.favouritesIcon.hidden = (x == nil);
    }];
    
    [RACObserve(photo, comments) subscribeNext:^(NSNumber *x) {
        self.commentsLabel.text = [x stringValue];
        self.commentsIcon.hidden = (x == nil);
    }];
    
    /**
     *  慢着，还有一个问题没有解决。当我们快速地滚动滑动栏，如果不做特殊，会同时加载大量的元数据和图片，这将明显地降低我们程序的性能。为了解决这个问题，程序应该只在照片显示在界面上的的时候去初始化元数据请求。现在ViewModel的isVisible属性被设置为YES，但不会被设置成NO。我们现在来处理这个问题。
     
     当ViewModel绑定到View时，isVisible属性会被设置成YES。但是当cell被移出table view进行重用时会被设置成NO。我们通过rac_prepareForReuseSignal信号来实现这步操作。
     */
    photo.isVisible = YES;
    [self.rac_prepareForReuseSignal subscribeNext:^(id x) {
        photo.isVisible = NO;
    }];
    
#if 0
    RWTFlickrPhoto *photo = viewModel;
#endif
    
    self.titleLabel.text = photo.title;
    
    self.imageThumbnailView.contentMode = UIViewContentModeScaleToFill;
    
    [self.imageThumbnailView sd_setImageWithURL:photo.url];
    
    
}


@end
