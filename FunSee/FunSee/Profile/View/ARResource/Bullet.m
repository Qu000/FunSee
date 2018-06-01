//
//  Bullet.m
//  ARBallGame
//
//  Created by qujiahong on 2018/5/15.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        SCNSphere * sphere = [SCNSphere sphereWithRadius:0.025];
        
        self.geometry = sphere;
        
        SCNPhysicsShape * shape = [SCNPhysicsShape shapeWithGeometry:sphere options:nil];
        
        self.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:shape];
        
        [self.physicsBody setAffectedByGravity:NO];
        
        self.physicsBody.categoryBitMask = 2;
        self.physicsBody.contactTestBitMask = 1;
        
        SCNMaterial * material = [[SCNMaterial alloc]init];
        
        material.diffuse.contents = [UIImage imageNamed:@"ball"];
        
        self.geometry.materials = @[material];
        
    }
    return self;
}

@end
