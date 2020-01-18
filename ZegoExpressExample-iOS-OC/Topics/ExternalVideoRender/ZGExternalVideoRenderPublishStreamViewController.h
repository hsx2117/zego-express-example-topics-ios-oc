//
//  ZGExternalVideoRenderPublishStreamViewController.h
//  ZegoExpressExample-iOS-OC
//
//  Created by Patrick Fu on 2020/1/1.
//  Copyright © 2020 Zego. All rights reserved.
//

#ifdef _Module_ExternalVideoRender

#import <UIKit/UIKit.h>
#import <ZegoExpressEngine/ZegoExpressEngine.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGExternalVideoRenderPublishStreamViewController : UIViewController

@property (nonatomic, copy) NSString *roomID;

@property (nonatomic, copy) NSString *streamID;

@property (nonatomic, assign) ZegoVideoBufferType bufferType;

@property (nonatomic, assign) ZegoVideoFrameFormatSeries frameFormatSeries;

@property (nonatomic, assign) BOOL enableInternalRender;

@end

NS_ASSUME_NONNULL_END

#endif