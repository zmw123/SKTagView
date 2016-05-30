//
//  SKTagView.h
//
//  Created by Shaokang Zhao on 15/1/12.
//  Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import "SKTag.h"
#import <UIKit/UIKit.h>

@protocol SKTagVieDataSource <NSObject>

@optional
- (nonnull UIView *)customViewForTag:(nonnull SKTag *)tag;
@end


@interface SKTagView : UIView

@property(assign, nonatomic) UIEdgeInsets padding;
@property(assign, nonatomic) CGFloat lineSpacing;
@property(assign, nonatomic) CGFloat interitemSpacing;
@property(assign, nonatomic) CGFloat preferredMaxLayoutWidth;
@property(assign, nonatomic) BOOL singleLine;
@property(assign, nonatomic) NSInteger maxLineCount;
@property(copy, nonatomic, nullable) void (^didTapTagAtIndex)(NSUInteger index);
@property(copy, nonatomic, nullable) void (^didLongPressedTagAtIndex)(NSUInteger index);
@property(strong, nonatomic, nullable) NSMutableArray *tags;

@property(weak, nonatomic) id<SKTagVieDataSource> delegate;
- (void)addTag:(nonnull SKTag *)tag;
- (void)insertTag:(nonnull SKTag *)tag atIndex:(NSUInteger)index;
- (void)removeTag:(nonnull SKTag *)tag;
- (void)removeTagAtIndex:(NSUInteger)index;
- (void)removeAllTags;

@end

