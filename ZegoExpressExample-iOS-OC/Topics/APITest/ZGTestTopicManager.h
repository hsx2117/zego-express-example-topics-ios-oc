//
//  ZGTestTopicManager.h
//  ZegoExpressExample-iOS-OC
//
//  Created by Patrick Fu on 2019/10/24.
//  Copyright © 2019 Zego. All rights reserved.
//

#ifdef _Module_Test

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ZegoExpressEngine/ZegoExpressEngine.h>
#import <ZegoExpressEngine/ZegoExpressEngine+IM.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZGTestDataSource <NSObject>

@required

- (void)onPublisherQualityUpdate:(ZegoPublishStreamQuality *)quality;

- (void)onPlayerQualityUpdate:(ZegoPlayStreamQuality *)quality;

- (void)onActionLog:(NSString *)logInfo;

@end


@interface ZGTestTopicManager : NSObject

- (void)setZGTestDataSource:(id<ZGTestDataSource>)dataSource;

#pragma mark - Engine

- (void)createEngineWithAppID:(unsigned int)appID appSign:(NSString *)appSign isTestEnv:(BOOL)isTestEnv scenario:(ZegoScenario)scenario;


- (void)destroyEngine;


- (NSString *)getVersion;


- (void)uploadLog;


- (void)setDebugVerbose:(BOOL)enable language:(ZegoLanguage)language;


#pragma mark - Room

- (void)loginRoom:(NSString *)roomID userID:(NSString *)userID;


- (void)logoutRoom:(NSString *)roomID;


#pragma mark - Publish

- (void)startPublishing:(NSString *)streamID;


- (void)stopPublishing;


- (void)startPreview:(ZegoCanvas *)canvas;


- (void)stopPreview;


- (void)setVideoConfig:(ZegoVideoConfig *)videoConfig;


- (void)setVideoMirrorMode:(ZegoVideoMirrorMode)mirrorMode;


- (void)setCaptureOrientation:(UIInterfaceOrientation)orientation;


- (void)setLatencyMode:(ZegoLatencyMode)latencyMode;


- (void)setAudioBitrate:(int)bitrate;


- (void)mutePublishStreamAudio:(BOOL)mute;


- (void)mutePublishStreamVideo:(BOOL)mute;


- (void)setCaptureVolume:(int)volume;


- (void)addPublishCDNURL:(NSString *)targetURL stream:(NSString *)streamID callback:(nullable ZegoPublisherUpdateCDNURLCallback)callback;


- (void)removePublishCDNURL:(NSString *)targetURL stream:(NSString *)streamID callback:(nullable ZegoPublisherUpdateCDNURLCallback)callback;


- (void)enableHardwareEncoder:(BOOL)enable;


#pragma mark - Player

- (void)startPlayingStream:(NSString *)streamID canvas:(ZegoCanvas *)canvas;


- (void)stopPlayingStream:(NSString *)streamID;


- (void)setPlayVolume:(int)volume stream:(NSString *)streamID;


- (void)mutePlayStreamAudio:(BOOL)mute stream:(NSString *)streamID;


- (void)mutePlayStreamVideo:(BOOL)mute stream:(NSString *)streamID;


- (void)enableHarewareDecoder:(BOOL)enable;


#pragma mark - PreProcess

- (void)enableAEC:(BOOL)enable;


- (void)setAECMode:(ZegoAECMode)mode;


- (void)enableAGC:(BOOL)enable;


- (void)enableANS:(BOOL)enable;


- (void)enableBeautify:(int)feature;


- (void)setBeautifyOption:(ZegoBeautifyOption *)option;


#pragma mark - Device

- (void)enableMicrophone:(BOOL)enable;


- (void)muteAudioOutput:(BOOL)mute;


- (void)enableCamera:(BOOL)enable;


- (void)useFrontCamera:(BOOL)enable;


- (void)enableAudioCaptureDevice:(BOOL)enable;


#pragma mark - Mixer


- (void)startMixerTask:(ZegoMixerTask *)task;


- (void)stopMixerTask:(NSString *)taskID;


#pragma mark - IM


- (void)sendBroadcastMessage:(NSString *)message roomID:(NSString *)roomID;


- (void)sendCustomCommand:(NSString *)command toUserList:(nullable NSArray<ZegoUser *> *)toUserList roomID:(NSString *)roomID;


@end

NS_ASSUME_NONNULL_END

#endif