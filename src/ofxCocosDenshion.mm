//
//  ofxCocosDenshion.cpp
//  ofxiOSCocosDenshionExample
//
//  Created by Daniel Rosser on 21/02/2014.
//
//

#include "ofxCocosDenshion.h"


ofxCocosDenshion * ofxCocosDenshion :: _instance = NULL;

//--------------------------------------------------
ofxCocosDenshion::ofxCocosDenshion() {
	aSyncronous = true;
	managerMode = kAMM_FxPlusMusicIfNoOtherAudio; // default
	backgroundMusicChannel = kASC_Left;
	soundEffectsChannel = kASC_Right;
	
}

//--------------------------------------------------
ofxCocosDenshion::~ofxCocosDenshion() {
	destroy();

}

//--------------------------------------------------
void ofxCocosDenshion::destroy() {
	if(sounds.size() != 0) {
		int howManySounds = sounds.size()-1;
		for(int i=0;i<=howManySounds;i++) {
			if(sounds[i] != NULL) {
				SoundEffect * delsound = sounds[i];
				delete delsound;
				delsound = NULL;
			}
		}
	}
    sounds.clear();
}

//--------------------------------------------------
void ofxCocosDenshion::setSetupASyncronous(bool isAsync) {
	aSyncronous = isAsync;
}

//--------------------------------------------------
void ofxCocosDenshion::setBackgroundMusicChannel(int channel) {
	/**
	 0 = kASC_Left,
	 1 = kASC_Right
	 */
	if(channel <= 0 || channel > 1) {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::setBackgroundMusicChannel: Failed to set Channel. Wrong id. Check Function");
	} else {
		backgroundMusicChannel = (tAudioSourceChannel)channel;
		if(soundEffectsChannel == backgroundMusicChannel) {
			ofLog(OF_LOG_NOTICE, "ofxCocosDenshion::setBackgroundMusicChannel:: changing sound effect channel to alternative");
			if(soundEffectsChannel == kASC_Left) {
				soundEffectsChannel = kASC_Right;
			} else {
				soundEffectsChannel = kASC_Left;
			}
		}
	}
}

//--------------------------------------------------
bool ofxCocosDenshion::isSoundPlaying(int sourceId) {
	CDSoundSource * src = [ofxCocosDenshionSoundManager soundSourceForSound:sourceId sourceGroupId:soundEffectsChannel];
	if(src) {
		if([src isPlaying] == YES) {
			return true;
		} else {
			return false;
		}
	} else {
		return false;
	}
}

//--------------------------------------------------
bool ofxCocosDenshion::isSoundPlaying(string name) {
	int uid = getSoundEffectID(name);
	if(uid != -1) {
		return isSoundPlaying(uid);
	} else {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::isSoundPlaying:: Can't find " + name);
		return false;
	}
}


//--------------------------------------------------
void ofxCocosDenshion::setSoundPan(int sourceId, float pan) {
	if(pan > 1.0) {
		ofClamp(pan, 0.0f, 1.0f);
	}
	CDSoundSource * src = [ofxCocosDenshionSoundManager soundSourceForSound:sourceId sourceGroupId:soundEffectsChannel];
	if(src != NULL) {
		if([src isPlaying] == YES) {
			[src setPan:pan];
		} else {
			//
		}
	}
	SoundEffect * snd = getSoundEffect(sourceId);
	if(snd) {
		snd->setPan(pan);
	}
}

//--------------------------------------------------
void ofxCocosDenshion::setSoundPan(string name, float pan) {
	int uid = getSoundEffectID(name);
	if(uid != -1) {
		setSoundVolume(uid, pan);
	} else {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::setSoundPan:: Can't find " + name);
	}
}

//--------------------------------------------------
void ofxCocosDenshion::setSoundVolume(int sourceId, float volume) {
	if(volume > 1.0) {
		ofClamp(volume, 0.0f, 1.0f);
	}
	CDSoundSource * src = [ofxCocosDenshionSoundManager soundSourceForSound:sourceId sourceGroupId:soundEffectsChannel];
	if(src != NULL) {
		if([src isPlaying] == YES) {
			[src setGain:volume];
		} else {
			//
		}
	}
	SoundEffect * snd = getSoundEffect(sourceId);
	if(snd) {
		snd->setVolume(volume);
	}
}

//--------------------------------------------------
void ofxCocosDenshion::setSoundVolume(string name, float volume) {
	int uid = getSoundEffectID(name);
	if(uid != -1) {
		setSoundVolume(uid, volume);
	} else {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::setSoundVolume:: Can't find " + name);
	}
}

//--------------------------------------------------
void ofxCocosDenshion::setSoundEffectsChannel(int channel) {
	/**
	 0 = kASC_Left,
	 1 = kASC_Right
	 */
	if(channel <= 0 || channel > 1) {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::setSoundEffectsChannel: Failed to set Channel. Wrong id. Check Function");
	} else {
		soundEffectsChannel = (tAudioSourceChannel)channel;
		if(soundEffectsChannel == backgroundMusicChannel) {
			ofLog(OF_LOG_NOTICE, "ofxCocosDenshion::setSoundEffectsChannel:: changing background music channel to alternative");
			if(backgroundMusicChannel == kASC_Left) {
				backgroundMusicChannel = kASC_Right;
			} else {
				backgroundMusicChannel = kASC_Left;
			}
		}
	}
}

//--------------------------------------------------
void ofxCocosDenshion::setManagerMode(int theManagerMode) {
	
	/** Different modes of the engine
	 0 = kAMM_FxOnly,					//!Other apps will be able to play audio
	 1 = kAMM_FxPlusMusic,				//!Only this app will play audio
	 2 = kAMM_FxPlusMusicIfNoOtherAudio,	//!If another app is playing audio at start up then allow it to continue and don't play music
	 3 = kAMM_MediaPlayback,				//!This app takes over audio e.g music player app
	 4 = kAMM_PlayAndRecord				//!App takes over audio and has input and output */
	if(theManagerMode < 0 || theManagerMode > 6) {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::setManagerMode: Failed to set Manager Mode. Wrong id. Check Function");
	} else {
		managerMode = (tAudioManagerMode)theManagerMode;
	}
}


//--------------------------------------------------
void ofxCocosDenshion::setup() {
	CDSoundEngine *sse = [CDAudioManager sharedManager].soundEngine;
	
	/**
	 A source group is another name for a channel
	 Here I have 2 channels, the first index allows for only a single effect... my background music
	 The second channel I have reserved for my sound effects.  This is set to 31 because you can
	 have up to 32 effects at once
	 */
	NSArray *sourceGroups = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:31], nil];
	[sse defineSourceGroups:sourceGroups];
	
	if(aSyncronous) {
		//Initialise audio manager asynchronously as it can take a few seconds
		[CDAudioManager initAsynchronously:managerMode];
	} else {
		//id mg = [CDAudioManager init:managerMode];
	}
}

//--------------------------------------------------
void ofxCocosDenshion::loadAllAudio() {
	
	if(sounds.size() != 0) {
		
		CDSoundEngine *sse = [CDAudioManager sharedManager].soundEngine;
		NSMutableArray *loadRequests = [[[NSMutableArray alloc] init] autorelease];

		/**
		 Here we set up an array of sounds to load
		 Each CDBufferLoadRequest takes an integer as an identifier (to call later)
		 and the file path.  Pretty straightforward here.
		 */
		//[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SND_BG_LOOP filePath:@"bgmusic.mp3"] autorelease]];
			
		int howManySounds = sounds.size()-1;
		for(int i=0;i<=howManySounds;i++) {
			if(sounds[i] != NULL) {
				SoundEffect* toLoad = sounds[i];
				[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:toLoad->getID() filePath:[NSString stringWithUTF8String:toLoad->getPath().c_str()]] autorelease]];
			}
		}
		[sse loadBuffersAsynchronously:loadRequests];
		
	}

}

//--------------------------------------------------
void ofxCocosDenshion::update() {
	
}

//--------------------------------------------------
void ofxCocosDenshion::setMute(bool bMute)  {
	if(sounds.size() != 0) {
		int howManySounds = sounds.size()-1;
		for(int i=0;i<=howManySounds;i++) {
			if(sounds[i] != NULL) {
				SoundEffect* toMute = sounds[i];
				if(bMute) {
					toMute->mute();
				} else {
					toMute->unmute();
				}
			} else {
				ofLog(OF_LOG_FATAL_ERROR, "Sound Not Allocated");
			}
		}
    }
}

//--------------------------------------------------
void ofxCocosDenshion::setIsSoundOn(bool isit)  {
	isSoundOn = isit;
	if(isit == true) {
		setMute(true);
	}
}

//--------------------------------------------------
void ofxCocosDenshion::playSound(int sourceId) {
	SoundEffect* sEffect = getSoundEffect(sourceId);
	if(sEffect) {
		[ofxCocosDenshionSoundManager playSound:sEffect->getID()
									sourceGroupId:soundEffectsChannel
											pitch:sEffect->getPitch()
											  pan:sEffect->getPan()
											 gain:sEffect->getVolume()
											 loop:sEffect->isLooped()];
	}
}

//--------------------------------------------------
void ofxCocosDenshion::playSound(string name) {
	int uid = getSoundEffectID(name);
	if(uid != -1) {
		playSound(uid);
	} else {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::playSound:: Can't find " + name);
	}
}

//--------------------------------------------------
void ofxCocosDenshion::stopSound(int theID) {
	[ofxCocosDenshionSoundManager stopSound:theID];
}

//--------------------------------------------------
void ofxCocosDenshion::stopSound(string name) {
	int uid = getSoundEffectID(name);
	if(uid != -1) {
		stopSound(uid);
	} else {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::stopSound:: Can't find " + name);
	}
}

//--------------------------------------------------
void ofxCocosDenshion::stopAllSounds() {
	[ofxCocosDenshionSoundManager stopAllSounds];
}

//--------------------------------------------------
void ofxCocosDenshion::pauseSound(int sourceId) {
	[ofxCocosDenshionSoundManager pauseSound:sourceId];
}

//--------------------------------------------------
void ofxCocosDenshion::pauseSound(string name) {
	int uid = getSoundEffectID(name);
	if(uid != -1) {
		pauseSound(uid);
	} else {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::pauseSound:: Can't find " + name);
	}
}

//--------------------------------------------------
void ofxCocosDenshion::pauseAllSounds() {
	[ofxCocosDenshionSoundManager pauseAllSounds];
}

//--------------------------------------------------
void ofxCocosDenshion::resumeSound(int sourceId) {
	[ofxCocosDenshionSoundManager resumeSound:sourceId];
}

//--------------------------------------------------
void ofxCocosDenshion::resumeSound(string name) {
	int uid = getSoundEffectID(name);
	if(uid != -1) {
		resumeSound(uid);
	} else {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::resumeSound:: Can't find " + name);
	}
}

//--------------------------------------------------
void ofxCocosDenshion::resumeAllSounds() {
	[ofxCocosDenshionSoundManager resumeAllSounds];
}

// playSound:__ID__ sourceGroupId:CGROUP_EFFECTS pitch:1.0f pan:0.0f gain:1.0f loop:NO]


//--------------------------------------------------
SoundEffect* ofxCocosDenshion::getSoundEffect(const string pathName)  {
		if(sounds.size() != 0) {
			int howManySounds = sounds.size()-1;
			for(int i=0;i<=howManySounds;i++) {
				if(sounds[i] != NULL) {
					if(sounds[i]->getPath() == pathName){
						return sounds[i];
					}
				} else {
					ofLog(OF_LOG_FATAL_ERROR, "Sound Not Allocated");
				}
			}
			return NULL; // not found
		} else {
			return NULL;
		}
}

SoundEffect* ofxCocosDenshion::getSoundEffect(const int uid)  {
	if(sounds.size() != 0) {
		int howManySounds = sounds.size()-1;
		for(int i=0;i<=howManySounds;i++) {
			if(sounds[i] != NULL) {
				if(sounds[i]->getID() == uid){
					return sounds[i];
				}
			} else {
				ofLog(OF_LOG_FATAL_ERROR, "Sound Not Allocated");
			}
		}
		return NULL; // not found
	} else {
		return NULL;
	}
}


int ofxCocosDenshion::getSoundEffectID(const string pathName)  {
	if(sounds.size() != 0) {
		int howManySounds = sounds.size()-1;
		for(int i=0;i<=howManySounds;i++) {
			if(sounds[i] != NULL) {
				if(sounds[i]->getPath() == pathName){
					return sounds[i]->getID();
				}
			} else {
				ofLog(OF_LOG_FATAL_ERROR, "Sound Not Allocated");
			}
		}
		return -1; // not found
	} else {
		return -1;
	}
}

//--------------------------------------------------
void ofxCocosDenshion::loadSound(string soundPath, float volume, bool bLoop)  {
	//
}

//--------------------------------------------------
int ofxCocosDenshion::addSoundEffect(string soundPath, float volume, bool bLoop) {
	int uid = soundCount;
	if(uid <= 31) {
		SoundEffect * sEffect = new SoundEffect(soundPath, uid);
		if(sEffect != NULL) {
				sEffect->setVolume(volume);
				sEffect->setLoop(bLoop);
				// do not play this is cached
				sounds.push_back(sEffect);
				soundCount++;
				return sEffect->getID();
			
		} else {
			// ERROR
			ofLog(OF_LOG_ERROR, "loadSound Error for: " + soundPath);
			delete sEffect;
			sEffect = NULL;
			return -1;
		}
	} else {
		ofLog(OF_LOG_ERROR, "ofxCocosDenshion::addSoundEffect:: Maximum Amount of Sounds Already loaded... 31");
		return -1;
	}
}

//--------------------------------------------------
bool ofxCocosDenshion::isDeviceMuted()  {
	return isSoundOn;
}


