/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <SenTestingKit/SenTestingKit.h>

#import <POP/POPAnimatableProperty.h>

static const CGFloat epsilon = 0.0001f;
static NSArray *properties = @[@"name", @"readBlock", @"writeBlock", @"threshold"];

static void assertPropertyEqual(id self, POPAnimatableProperty *prop1, POPAnimatableProperty *prop2)
{
  for (NSString *property in properties) {
    id value = [prop1 valueForKey:property];
    id valueCopy = [prop2 valueForKey:property];
    STAssertEqualObjects(value, valueCopy, @"unexpected inequality; value:%@ copy:%@", value, valueCopy);
  }
}

@interface POPAnimatablePropertyTests : SenTestCase
@end

@implementation POPAnimatablePropertyTests

- (void)testProvidedExistence
{
  NSArray *names = @[kPOPLayerPosition,
                     kPOPLayerOpacity,
                     kPOPLayerScaleXY,
                     kPOPLayerSubscaleXY,
                     kPOPLayerSubtranslationX,
                     kPOPLayerSubtranslationY,
                     kPOPLayerSubtranslationZ,
                     kPOPLayerSubtranslationXY,
                     kPOPLayerZPosition,
                     kPOPLayerSize,
                     kPOPLayerRotation,
                     kPOPLayerRotationY,
                     kPOPLayerRotationX,
                     kPOPShapeLayerStrokeStart,
                     kPOPShapeLayerStrokeEnd,
                     kPOPShapeLayerStrokeColor,
#if TARGET_OS_IPHONE
                     kPOPViewAlpha,
                     kPOPViewBackgroundColor,
                     kPOPViewCenter,
                     kPOPViewFrame,
                     kPOPViewBounds,
                     kPOPViewSize,
                     kPOPTableViewContentSize,
                     kPOPTableViewContentOffset,
                     kPOPLabelTextColor
#endif
                     ];

  for (NSString *name in names) {
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:name];
    STAssertNotNil(prop, @"animatable property %@ should exist", name);
  }
}

- (void)testUserCreation
{
  static NSString *name = @"lalalala";
  static CGFloat threshold = 0.07;
  POPAnimatableProperty *prop;

  prop = [POPAnimatableProperty propertyWithName:name];
  STAssertNil(prop, @"animatable property %@ should not exist", name);

  prop = [POPAnimatableProperty propertyWithName:name initializer:^(POPMutableAnimatableProperty *p){
    p.threshold = threshold;
  }];
  STAssertNotNil(prop, @"animatable property %@ should exist", name);
  STAssertEqualsWithAccuracy(threshold, prop.threshold, epsilon, @"property threshold %f should equal %f", prop.threshold, threshold);
}

- (void)testClassCluster
{
  POPAnimatableProperty *instance1 = [[POPAnimatableProperty alloc] init];
  POPAnimatableProperty *instance2 = [[POPAnimatableProperty alloc] init];
  STAssertTrue(instance1 == instance2, @"instance1:%@ instance2:%@", instance1, instance2);

  for (NSString *property in properties) {
    STAssertNoThrow([instance1 valueForKey:property], @"exception on %@", property);
  }
}

- (void)testCopying
{
  // instance
  POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:kPOPLayerBounds];

  // instance copy
  POPAnimatableProperty *propCopy = [prop copy];

  // test equality
  assertPropertyEqual(self, prop, propCopy);
}

- (void)testMutableCopying
{
  // instance
  POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:kPOPLayerBounds];

  // instance copy
  POPAnimatableProperty *propCopy = [prop mutableCopy];

  // test equality
  assertPropertyEqual(self, prop, propCopy);
}

@end
