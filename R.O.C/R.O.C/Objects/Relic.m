//
//  Relic.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 16/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Relic.h"

@implementation Relic
-(instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    
    if (self) {
        self.life = 100;
    }
    return self;
}
@end
