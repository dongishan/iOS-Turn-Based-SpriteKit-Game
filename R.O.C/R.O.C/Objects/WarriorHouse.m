//
//  WarriorHouse.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 08/03/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "WarriorHouse.h"

@implementation WarriorHouse
-(instancetype)initWithImageNamed:(NSString *)name{
    self = [super initWithImageNamed:name];
    if (self) {
        self.health = 0;
    }
    return self;

}
@end
