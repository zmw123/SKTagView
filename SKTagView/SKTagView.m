//
//  SKTagView.m
//
//  Created by Shaokang Zhao on 15/1/12.
//  Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import "SKTagButton.h"
#import "SKTagView.h"

@interface SKTagView ()
@property(strong, nonatomic, nullable) NSMutableArray *tagsConstraints;
@property(assign, nonatomic) BOOL didSetup;

@end

@implementation SKTagView
- (id)init
{
    self = [super init];
    if (self)
    {
        self.maxLineCount = 0;
    }
    return self;
}
#pragma mark - Lifecycle

- (CGSize)intrinsicContentSize {
  if (!self.tags.count) {
    return CGSizeZero;
  }

  NSArray *subviews = self.subviews;
  UIView *previousView = nil;
  CGFloat topPadding = self.padding.top;
  CGFloat bottomPadding = self.padding.bottom;
  CGFloat leftPadding = self.padding.left;
  CGFloat rightPadding = self.padding.right;
  CGFloat itemSpacing = self.interitemSpacing;
  CGFloat lineSpacing = self.lineSpacing;
  CGFloat currentX = leftPadding;
  CGFloat intrinsicHeight = topPadding;
  CGFloat intrinsicWidth = leftPadding;

  if (!self.singleLine && self.preferredMaxLayoutWidth > 0) {
    NSInteger lineCount = 0;
    for (UIView *view in subviews) {
        CGSize size = view.intrinsicContentSize;
        if (size.width <= 0 || size.height <= 0)
        {
            size = view.frame.size;
        }
      if (previousView) {
        CGFloat width = size.width;
        currentX += itemSpacing;
        if (currentX + width + rightPadding <= self.preferredMaxLayoutWidth) {
          currentX += size.width;
        } else {
          lineCount++;
            if (self.maxLineCount > 0)
            {
                if (self.maxLineCount > 0 && lineCount >= self.maxLineCount + 1)
                {
                    currentX += size.width;
                    view.hidden = YES;
                }
                else
                {
                    currentX = leftPadding + size.width;
                    intrinsicHeight += size.height;
                }
            }
            else
            {
                currentX = leftPadding + size.width;
                intrinsicHeight += size.height;
            }
        }
      } else {
        lineCount++;
        intrinsicHeight += size.height;
        currentX += size.width;
      }
      previousView = view;
      intrinsicWidth = MAX(intrinsicWidth, currentX + rightPadding);
    }

      if (self.maxLineCount > 0)
      {
          intrinsicHeight += bottomPadding + lineSpacing * (self.maxLineCount - 1);
      }
      else
      {
          intrinsicHeight += bottomPadding + lineSpacing * (lineCount - 1);
      }
  } else {
    for (UIView *view in subviews) {
        CGSize size = view.intrinsicContentSize;
        if (size.width <= 0 || size.height <= 0)
        {
            size = view.frame.size;
        }
      intrinsicWidth += size.width;
    }
    intrinsicWidth += itemSpacing * (subviews.count - 1) + rightPadding;
      CGSize first = ((UIView *)subviews.firstObject).intrinsicContentSize;
      if (first.width <= 0 || first.height <= 0)
      {
          first = ((UIView *)subviews.firstObject).frame.size;
      }
    intrinsicHeight +=
        first.height +
        bottomPadding;
  }
  return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

- (void)layoutSubviews {
  if (!self.singleLine) {
    self.preferredMaxLayoutWidth = self.frame.size.width;
  }

  [super layoutSubviews];

  [self layoutTags];
}

#pragma mark - Custom accessors

- (NSMutableArray *)tags {
  if (!_tags) {
    _tags = [NSMutableArray array];
  }
  return _tags;
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
  if (preferredMaxLayoutWidth != _preferredMaxLayoutWidth) {
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    _didSetup = NO;
    [self invalidateIntrinsicContentSize];
  }
}

#pragma mark - Private

- (void)layoutTags {
  if (self.didSetup || !self.tags.count) {
    return;
  }

  NSArray *subviews = self.subviews;
  UIView *previousView = nil;
  CGFloat topPadding = self.padding.top;
  CGFloat leftPadding = self.padding.left;
  CGFloat rightPadding = self.padding.right;
  CGFloat itemSpacing = self.interitemSpacing;
  CGFloat lineSpacing = self.lineSpacing;
  CGFloat currentX = leftPadding;
    
    NSInteger lineCount = 1;

  if (!self.singleLine && self.preferredMaxLayoutWidth > 0) {
    for (UIView *view in subviews) {
      CGSize size = view.intrinsicContentSize;
        if (size.width <= 0 || size.height <= 0)
        {
            size = view.frame.size;
        }
      if (previousView) {
        CGFloat width = size.width;
        currentX += itemSpacing;
        if (currentX + width + rightPadding <= self.preferredMaxLayoutWidth) {
          view.frame = CGRectMake(currentX, CGRectGetMinY(previousView.frame),
                                  size.width, size.height);
          currentX += size.width;
        } else {
            lineCount ++;
            if (self.maxLineCount > 0 && lineCount >= self.maxLineCount + 1)
            {
                view.frame = CGRectMake(currentX, CGRectGetMinY(previousView.frame),
                                        size.width, size.height);
                currentX += size.width;
            }
            else
            {
                CGFloat width = MIN(size.width, self.preferredMaxLayoutWidth -
                                    leftPadding - rightPadding);
                view.frame = CGRectMake(
                                        leftPadding, CGRectGetMaxY(previousView.frame) + lineSpacing,
                                        width, size.height);
                currentX = leftPadding + width;
            }
          
        }
      } else {
        CGFloat width = MIN(size.width, self.preferredMaxLayoutWidth -
                                            leftPadding - rightPadding);
        view.frame = CGRectMake(leftPadding, topPadding, width, size.height);
        currentX += width;
      }

      previousView = view;
    }
  } else {
    for (UIView *view in subviews) {
      CGSize size = view.intrinsicContentSize;
      view.frame = CGRectMake(currentX, topPadding, size.width, size.height);
      currentX += size.width;

      previousView = view;
    }
  }

  self.didSetup = YES;
}

#pragma mark - IBActions

- (void)onTag:(UIButton *)btn {
  if (self.didTapTagAtIndex) {
    self.didTapTagAtIndex([self.subviews indexOfObject:btn]);
  }
}

#pragma mark - Public

- (void)addTag:(SKTag *)tag {
  NSParameterAssert(tag);
  SKTagButton *btn = [SKTagButton buttonWithTag:tag];

  switch (tag.type) {
  case SKtagTypeTaped:
    [btn addTarget:self
                  action:@selector(onTag:)
        forControlEvents:UIControlEventTouchUpInside];
    break;
  case SKtagTypeLongPressed: {
    // button长按事件
    UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(btnLong:)];
    [btn addGestureRecognizer:longPress];

  } break;
          case SKTagTypeCustomDelete:
      {
          if (self.delegate && [self.delegate respondsToSelector:@selector(customViewForTag:)])
          {
              btn = [self.delegate customViewForTag:tag];
          }
      }break;
      case SKTagTypeCustomAdd:
      {
          if (self.delegate && [self.delegate respondsToSelector:@selector(customViewForTag:)])
          {
              btn = [self.delegate customViewForTag:tag];
          }
      }break;
  default:
    [btn addTarget:self
                  action:@selector(onTag:)
        forControlEvents:UIControlEventTouchUpInside];
    break;
  }

  // btn 长按手势

  [self addSubview:btn];
  [self.tags addObject:tag];

  self.didSetup = NO;
  [self invalidateIntrinsicContentSize];
}

- (void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer {

  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {

    if (self.didLongPressedTagAtIndex) {
      self.didLongPressedTagAtIndex(
          [self.subviews indexOfObject:gestureRecognizer.view]);
    }
  }
}

- (void)insertTag:(SKTag *)tag atIndex:(NSUInteger)index {
  NSParameterAssert(tag);
  if (index + 1 > self.tags.count) {
    [self addTag:tag];
  } else {
    SKTagButton *btn = [SKTagButton buttonWithTag:tag];
    [btn addTarget:self
                  action:@selector(onTag:)
        forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:btn atIndex:index];
    [self.tags insertObject:tag atIndex:index];

    self.didSetup = NO;
    [self invalidateIntrinsicContentSize];
  }
}

- (void)removeTag:(SKTag *)tag {
  NSParameterAssert(tag);
  NSUInteger index = [self.tags indexOfObject:tag];
  if (NSNotFound == index) {
    return;
  }

  [self.tags removeObjectAtIndex:index];
  if (self.subviews.count > index) {
    [self.subviews[index] removeFromSuperview];
  }

  self.didSetup = NO;
  [self invalidateIntrinsicContentSize];
}

- (void)removeTagAtIndex:(NSUInteger)index {
  if (index + 1 > self.tags.count) {
    return;
  }

  [self.tags removeObjectAtIndex:index];
  if (self.subviews.count > index) {
    [self.subviews[index] removeFromSuperview];
  }

  self.didSetup = NO;
  [self invalidateIntrinsicContentSize];
}

- (void)removeAllTags {
  [self.tags removeAllObjects];
  for (UIView *view in self.subviews) {
    [view removeFromSuperview];
  }

  self.didSetup = NO;
  [self invalidateIntrinsicContentSize];
}

@end
