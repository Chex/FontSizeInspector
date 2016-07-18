//
//  ViewController.m
//  FontSizeInspector
//
//  Created by Sean Chen on 11/5/14.
//  Copyright (c) 2014 Douguo Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.fontWeightLabel.text = [NSString stringWithFormat:@"%0.1f", self.fontWeightStepper.value];
	self.fontSizeLabel.text = [NSString stringWithFormat:@"%0.1f", self.fontSizeSlider.value];
	self.kernLabel.text = [NSString stringWithFormat:@"%0.1f", self.kernSlider.value];
	self.lineSpacingLabel.text = [NSString stringWithFormat:@"%0.1f", self.lineSpacingSlider.value];
	
	[self update];
}

- (void)fontWeightStepperChanged:(UIStepper *)stepper {
	
	self.fontWeightLabel.text = [NSString stringWithFormat:@"%0.1f", self.fontWeightStepper.value];
	
	[self update];
}

- (void)fontSizeSliderSlided:(UISlider *)slider {
	
	self.fontSizeLabel.text = [NSString stringWithFormat:@"%0.1f", self.fontSizeSlider.value];
	
	[self update];
}

- (void)kernSliderSlided:(UISlider *)slider {
	
	self.kernLabel.text = [NSString stringWithFormat:@"%0.1f", self.kernSlider.value];
	
	[self update];
}

- (void)lineSpacingSliderSlided:(UISlider *)slider {
	
	self.lineSpacingLabel.text = [NSString stringWithFormat:@"%0.1f", self.lineSpacingSlider.value];
	
	[self update];
}

#pragma mark - private

- (void)update {
	
	UIFont *font;
	if (![UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
		font = [UIFont systemFontOfSize:self.fontSizeSlider.value];
	} else {
		font = [UIFont systemFontOfSize:self.fontSizeSlider.value weight:self.fontWeightStepper.value];
	}
	
	NSNumber *kern = [NSNumber numberWithFloat:self.kernSlider.value];
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = self.lineSpacingSlider.value;
	
	
	
	CGRect rect = CGRectZero;
	CGRect boundingRect = CGRectZero;
	CGSize constrainedSize = CGSizeMake(self.singleLineLabel.frame.size.width, CGFLOAT_MAX);
	
	
	
	NSDictionary *attributes = @{NSFontAttributeName : font,
								 NSKernAttributeName : kern,
								 NSParagraphStyleAttributeName : paragraphStyle};
	
	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.singleLineLabel.text];
	[attributedText setAttributes:attributes range:NSMakeRange(0, attributedText.length)];
	self.singleLineLabel.attributedText = attributedText;
	
	rect = self.singleLineLabel.frame;
	boundingRect = [self.singleLineLabel.text boundingRectWithSize:constrainedSize
														   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
														attributes:attributes
														   context:nil];
	boundingRect = CGRectIntegral(boundingRect);
	
	rect.size.height = boundingRect.size.height;
	self.singleLineLabel.frame = rect;
	
	self.fontHeightLabel.text = [NSString stringWithFormat:@"single line height: %0.1f", boundingRect.size.height];
	
	
	
	attributedText = [[NSMutableAttributedString alloc] initWithString:self.doubleLinesLabel.text];
	[attributedText setAttributes:attributes range:NSMakeRange(0, attributedText.length)];
	self.doubleLinesLabel.attributedText = attributedText;
	
	rect = self.doubleLinesLabel.frame;
	boundingRect = [self.doubleLinesLabel.text boundingRectWithSize:constrainedSize
															options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
														 attributes:attributes
															context:nil];
	boundingRect = CGRectIntegral(boundingRect);
	
	rect.size.height = boundingRect.size.height;
	self.doubleLinesLabel.frame = rect;
	
	self.doubleLinesLabel.center = self.view.center;
}

@end
