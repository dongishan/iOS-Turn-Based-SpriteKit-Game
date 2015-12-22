//
//  ProjectEnums.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 16/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#ifndef R_O_C_ProjectEnums_h
#define R_O_C_ProjectEnums_h

typedef enum {
    FARMER,
    AI_FARMER,
    WARRIOR,
    AI_WARRIOR
} SUB_TYPE;

typedef enum {
    PC,
    NPC
} MAIN_TYPE;

typedef enum {
    ALL,
    GOLD,
    STONE,
    WOOD,
    WARRIOR_HOUSE
} REQUIRED_RESOURCE_TYPE;

typedef enum {
    NON,
    GATHER_GOLD,
    GATHER_STONE,
    GATHER_WOOD,
    ATTACK_ENEMY_RELIC,
    BUILD_WARRIOR_HOUSE,
    ATTACK_ENEMY_NEAR
} CURRENT_TASK;


#endif

