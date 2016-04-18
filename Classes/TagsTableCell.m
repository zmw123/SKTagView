//
//  TagsTableCell.m
//  WrapViewWithAutolayout
//
//  Created by Shaokang Zhao on 15/1/12.
//  Copyright (c) 2015年 shiweifu. All rights reserved.
//

#import "SKTagView.h"
#import "TagsTableCell.h"
#import <Masonry.h>
@implementation TagsTableCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {

  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    self.tagView = [[SKTagView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.contentView)
          .with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
  }

  return self;
}

@end
