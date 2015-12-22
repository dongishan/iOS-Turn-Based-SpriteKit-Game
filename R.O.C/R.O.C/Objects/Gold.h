//
//  Gold.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 20/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gold : Resource

@property (nonatomic)CGPoint workPosition;
@property (nonatomic)CGPoint position;
@property (nonatomic)NSInteger value;
@property (nonatomic,retain) SKSpriteNode *goldNode;
- (instancetype)initWithImageName :(NSString *)imageName position: (CGPoint)position value:(NSInteger)value;

@end
