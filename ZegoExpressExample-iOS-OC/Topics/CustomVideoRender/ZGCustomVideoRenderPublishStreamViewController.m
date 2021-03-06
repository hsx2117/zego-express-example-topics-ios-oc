//
//  ZGCustomVideoRenderPublishStreamViewController.m
//  ZegoExpressExample-iOS-OC
//
//  Created by Patrick Fu on 2020/1/1.
//  Copyright © 2020 Zego. All rights reserved.
//

#ifdef _Module_CustomVideoRender

#import "ZGCustomVideoRenderPublishStreamViewController.h"
#import "ZGAppGlobalConfigManager.h"
#import "ZGUserIDHelper.h"

@interface ZGCustomVideoRenderPublishStreamViewController () <ZegoEventHandler, ZegoCustomVideoRenderHandler>

@property (nonatomic, strong) ZegoExpressEngine *engine;

@property (weak, nonatomic) IBOutlet UIImageView *customRenderPreviewView;

@property (weak, nonatomic) IBOutlet UIView *engineRenderPreviewView;

@end

@implementation ZGCustomVideoRenderPublishStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Publish";
    
    [self createEngine];
    [self startLive];
}

- (void)createEngine {
    // Set render config
    ZegoCustomVideoRenderConfig *renderConfig = [[ZegoCustomVideoRenderConfig alloc] init];
    renderConfig.bufferType = self.bufferType;
    renderConfig.frameFormatSeries = self.frameFormatSeries;
    renderConfig.enableEngineRender = self.enableEngineRender;
    
    ZegoEngineConfig *engineConfig = [[ZegoEngineConfig alloc] init];
    [engineConfig setCustomVideoRenderConfig:renderConfig];
    
    // Set engine config, must be called before create engine
    [ZegoExpressEngine setEngineConfig:engineConfig];
    
    ZGAppGlobalConfig *appConfig = [[ZGAppGlobalConfigManager sharedManager] globalConfig];
    
    ZGLogInfo(@" 🚀 Create ZegoExpressEngine");
    
    self.engine = [ZegoExpressEngine createEngineWithAppID:(unsigned int)appConfig.appID appSign:appConfig.appSign isTestEnv:appConfig.isTestEnv scenario:appConfig.scenario eventHandler:self];
    
    // Set custom video render handler
    [self.engine setCustomVideoRenderHandler:self];
}

- (void)startLive {
    // Login Room
    ZegoUser *user = [ZegoUser userWithUserID:[ZGUserIDHelper userID] userName:[ZGUserIDHelper userName]];
    ZGLogInfo(@" 🚪 Login room. roomID: %@", self.roomID);
    [self.engine loginRoom:self.roomID user:user config:[ZegoRoomConfig defaultConfig]];
    
    [self.engine setVideoConfig:[ZegoVideoConfig configWithResolution:ZegoResolution1080x1920]];
    
    // Start preview
    ZegoCanvas *previewCanvas = [ZegoCanvas canvasWithView:self.engineRenderPreviewView];
    ZGLogInfo(@" 🔌 Start preview");
    [self.engine startPreview:previewCanvas];
    
    // Start publishing
    ZGLogInfo(@" 📤 Start publishing stream. streamID: %@", self.streamID);
    [self.engine startPublishing:self.streamID];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (self.isBeingDismissed || self.isMovingFromParentViewController
        || (self.navigationController && self.navigationController.isBeingDismissed)) {
        ZGLogInfo(@" 🏳️ Destroy ZegoExpressEngine");
        [ZegoExpressEngine destroyEngine];
    }
    [super viewDidDisappear:animated];
}

#pragma mark - ZegoCustomVideoRenderHandler

/// When `ZegoCustomVideoRenderConfig.bufferType` is set to `ZegoVideoBufferTypeRawData`, the video frame raw data will be called back from this function
- (void)onCapturedVideoFrameRawData:(unsigned char * _Nonnull *)data dataLength:(unsigned int *)dataLength param:(ZegoVideoFrameParam *)param flipMode:(ZegoVideoFlipMode)flipMode {
    NSLog(@"raw data video frame callback. format:%d, width:%f, height:%f, isNeedFlip:%d", (int)param.format, param.size.width, param.size.height, (int)flipMode);
    
    if (param.format == ZegoVideoFrameFormatBGRA32) {
        // Reverse color
        unsigned char *bgra32 = data[0];
        for (int i = 0; i < dataLength[0]; i += 4) {
            unsigned char b = bgra32[i];
            unsigned char g = bgra32[i + 1];
            unsigned char r = bgra32[i + 2];
            bgra32[i] = 255 - b;
            bgra32[i + 1] = 255 - g;
            bgra32[i + 2] = 255 - r;
        }
    } else if (param.format == ZegoVideoFrameFormatI420) {
        // Grayscale
        unsigned char *uPlanar = data[1];
        unsigned char *vPlanar = data[1];
        memset(uPlanar, 0x80, sizeof(char) * dataLength[1]);
        memset(vPlanar, 0x80, sizeof(char) * dataLength[2]);
    }
}

/// When `ZegoCustomVideoRenderConfig.bufferType` is set to `ZegoVideoBufferTypeCVPixelBuffer`, the video frame CVPixelBuffer will be called back from this function
- (void)onCapturedVideoFrameCVPixelBuffer:(CVPixelBufferRef)buffer param:(ZegoVideoFrameParam *)param flipMode:(ZegoVideoFlipMode)flipMode {
    NSLog(@"pixel buffer video frame callback. format:%d, width:%f, height:%f, isNeedFlip:%d", (int)param.format, param.size.width, param.size.height, (int)flipMode);
    [self renderWithCVPixelBuffer:buffer];
}

#pragma mark - Custom Render Method

- (void)renderWithCVPixelBuffer:(CVPixelBufferRef)buffer {
    CIImage *image = [CIImage imageWithCVPixelBuffer:buffer];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.customRenderPreviewView.image = [UIImage imageWithCIImage:image];
    });
}


@end

#endif
