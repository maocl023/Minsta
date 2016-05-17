//
//  MSPhotoFeedCellNode.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSPhotoFeedCellNode.h"
#import "MSPhoto.h"
#import "MSUser.h"
#import "MinstaMacro.h"
#import "NSString+MinstaAdd.h"

static const CGFloat kFunctionNodeSizeWidth = 48.f;
static const CGFloat kSeparatorNodeLeadingMargin = 15.f;
static const CGFloat kSymbolNodeSizeWidth = 12.f;
#define kVotesFont [UIFont boldSystemFontOfSize:13.f]

@interface MSPhotoFeedCellNode ()

@property (nonatomic, strong) MSPhoto *photo;

@property (nonatomic, strong) ASNetworkImageNode *photoNode;
@property (nonatomic, strong) ASImageNode *likeNode;
@property (nonatomic, strong) ASImageNode *commentNode;
@property (nonatomic, strong) ASImageNode *sendNode;
@property (nonatomic, strong) ASDisplayNode *separatorNode;
@property (nonatomic, strong) ASImageNode *likeMeNode;
@property (nonatomic, strong) ASTextNode *votesNode;

@end

@implementation MSPhotoFeedCellNode

#pragma mark - Lifecycle

- (instancetype)initWithPhoto:(MSPhoto *)photo {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _photo = photo;

        [self _setupSubnodes];
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    CGFloat votesNodeWidth = [_votesNode.attributedText.string widthForFont:kVotesFont];
    CGFloat votesNodeHeight = [_votesNode.attributedText.string heightForFont:kVotesFont width:votesNodeWidth];

    // set subnode preferred size
    _likeNode.preferredFrameSize = (CGSize){kFunctionNodeSizeWidth, kFunctionNodeSizeWidth};
    _commentNode.preferredFrameSize = _likeNode.preferredFrameSize;
    _sendNode.preferredFrameSize = _likeNode.preferredFrameSize;
    _separatorNode.preferredFrameSize = (CGSize){constrainedSize.max.width, 1.f / [UIScreen mainScreen].scale};
    _likeMeNode.preferredFrameSize = (CGSize){kSymbolNodeSizeWidth, kSymbolNodeSizeWidth};
    _votesNode.preferredFrameSize = (CGSize){votesNodeWidth, votesNodeHeight};

    // photo ratio layout
    ASRatioLayoutSpec *ratioLayout = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:MS_HOME_PHOTO_RATIO child:_photoNode];

    // function node horizontal stack layout
    ASStackLayoutSpec *fhStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:1.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[_likeNode, _commentNode, _sendNode]];

    // separator inset layout
    ASInsetLayoutSpec *sInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsets){0.f, kSeparatorNodeLeadingMargin, 0.f, kSeparatorNodeLeadingMargin} child:_separatorNode];

    // votes node horizontal stack layout
    ASStackLayoutSpec *vhStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:kSeparatorNodeLeadingMargin / 3.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_likeMeNode, _votesNode]];

    // votes node inset layout
    ASInsetLayoutSpec *vInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsets){kSeparatorNodeLeadingMargin / 2.f, kSeparatorNodeLeadingMargin, kSeparatorNodeLeadingMargin / 2.f, kSeparatorNodeLeadingMargin} child:vhStackLayout];

    // vertical stack layout
    ASStackLayoutSpec *vStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:1.f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[ratioLayout, fhStackLayout, sInsetLayout, vInsetLayout]];

    return vStackLayout;
}

#pragma mark - Private

- (void)_setupSubnodes {
    NSString *photoUrlString = _photo.images[0].url;
    NSString *votesString = [NSString stringWithFormat:NSLocalizedString(@"%d likes", nil), _photo.votesCount];

    if (photoUrlString && ![@"" isEqualToString:photoUrlString]) {
        _photoNode = [ASNetworkImageNode new];
        _photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _photoNode.URL = [NSURL URLWithString:photoUrlString];
        _photoNode.layerBacked = YES;

        _likeNode = [ASImageNode new];
        _likeNode.image = [UIImage imageNamed:@"like"];
        _likeNode.contentMode = UIViewContentModeCenter;
        _likeNode.backgroundColor = self.backgroundColor;

        _commentNode = [ASImageNode new];
        _commentNode.image = [UIImage imageNamed:@"comment"];
        _commentNode.contentMode = UIViewContentModeCenter;
        _commentNode.backgroundColor = self.backgroundColor;

        _sendNode = [ASImageNode new];
        _sendNode.image = [UIImage imageNamed:@"send"];
        _sendNode.contentMode = UIViewContentModeCenter;
        _sendNode.backgroundColor = self.backgroundColor;

        _separatorNode = [ASDisplayNode new];
        _separatorNode.backgroundColor = [UIColor lightGrayColor];
        _separatorNode.layerBacked = YES;

        [self addSubnode:_photoNode];
        [self addSubnode:_likeNode];
        [self addSubnode:_commentNode];
        [self addSubnode:_sendNode];
        [self addSubnode:_separatorNode];
    }

    _likeMeNode = [ASImageNode new];
    _likeMeNode.image = [UIImage imageNamed:@"likemetaheart"];
    _likeMeNode.contentMode = UIViewContentModeCenter;
    _likeMeNode.backgroundColor = self.backgroundColor;
    _likeMeNode.layerBacked = YES;

    _votesNode = [ASTextNode new];
    _votesNode.backgroundColor = self.backgroundColor;
    _votesNode.attributedString = [[NSAttributedString alloc] initWithString:votesString attributes:@{NSFontAttributeName : kVotesFont}];
    _votesNode.flexShrink = YES;
    _votesNode.truncationMode = NSLineBreakByTruncatingTail;
    _votesNode.maximumNumberOfLines = 1;

    [self addSubnode:_likeMeNode];
    [self addSubnode:_votesNode];
}

@end
