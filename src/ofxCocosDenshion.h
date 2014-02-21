//
//  ofxCocosDenshion.h
//  ofxiOSCocosDenshionExample
//
//  Created by Daniel Rosser on 21/02/2014.
//
//

#ifndef __ofxiOSCocosDenshionExample__ofxCocosDenshion__
#define __ofxiOSCocosDenshionExample__ofxCocosDenshion__

/**
Requirements:
- Frameworks: OpenAL, AudioToolbox
*/



//--------------------------------------------------
#include "ofMain.h"

#import "CocosDenshion.h"
#import "CDAudioManager.h"
#import "CDConfig.h"
//--------------------------------------------------


#define ofxCocosDenshionSoundManager [CDAudioManager sharedManager].soundEngine


//--------------------------------------------------
struct SoundEffect {
	SoundEffect(string location, int uid) {
		path = location;
		volume = 0.0f;
		muted = false;
		soundID = uid;
		pitch = 1.0;
		pan = 0.0f;
	}
	
	//----------------------------------------
	void setVolume(float newVolume) {
		volume = newVolume;
	}
	float getVolume() {
		if(muted) {
			return 0.0f;
		} else {
			return volume;
		}
	}
	
	
	//----------------------------------------
	void setPan(float newPan) {
		pan = newPan;
	}
	float getPan() {
		return pan;
	}
	
	//----------------------------------------
	void setPitch(float newPitch) {
		pitch = newPitch;
	}
	float getPitch() {
		return pitch;
	}

	
	//----------------------------------------
	void setLoop(bool bLoop) {
		loop = bLoop;
	}
	bool isLooped() {
		return loop;
	}
	
	//----------------------------------------
	bool isPlaying() {
		return true;
	}
	
	//----------------------------------------
	void mute() {
		muted = true;
	}
	
	void unmute() {
		muted = false;
	}
	
	bool isMuted() {
		return muted;
	}
	
	//----------------------------------------
	string getPath() {
		return path;
	}
	
	//----------------------------------------
	int getID() {
		return soundID;
	}
	
	//----------------------------------------
	
    int soundID;
	bool loop;
	bool muted;
	string path;
	
	
    float volume; // also known as gain
	float pan;
	float pitch;
	
};


static int soundCount;
//------------------------------------------------------------
class ofxCocosDenshion {
public:
	
	static ofxCocosDenshion * getInstance() {
		if(!_instance) {
			_instance = new ofxCocosDenshion();
		}
        return _instance;
	};
	
	ofxCocosDenshion();
	~ofxCocosDenshion();
	
	
	int addSoundEffect(string soundPath, float volume, bool bLoop=false);
	void destroy();
	
    void setup();
	void loadAllAudio();
	void update();
	
	//--------------------------------------------------
    void setMute(bool bMute);
	void setIsSoundOn(bool isit);
	
	//------------------------------ Sound Effects
	
	void playSound(int sourceId);
	void playSound(string name);
	
	void setSoundPan(int sourceId, float pan);
	void setSoundPan(string name, float pan);
	
	void setSoundVolume(int sourceId, float pan);
	void setSoundVolume(string name, float pan);
	
	bool isSoundPlaying(int sourceId);
	bool isSoundPlaying(string name);
	
	/** Stops playing a sound */
	void stopSound(int theID);
	void stopSound(string name);

	/** Stops all playing sounds */
	void stopAllSounds();
	/** Pause a sound */
	void pauseSound(int sourceId);
	void pauseSound(string name);
	/** Pause all sounds */
	void pauseAllSounds();
	/** Resume a sound */
	void resumeSound(int sourceId);
	void resumeSound(string name);
	/** Resume all sounds */
	void resumeAllSounds();
	
	//------------------------------- Background Music
	
	
	
	//--------------------------------------------------
	SoundEffect* getSoundEffect(const int);
	SoundEffect* getSoundEffect(const string pathName);
	int getSoundEffectID(const string pathName);
	void loadSound(string soundPath, float volume, bool bLoop=false);
	
	bool isDeviceMuted();
	
	vector<SoundEffect*> sounds;
	
	//------------------------ (Call these before setup if you want to modify them)
	void setManagerMode(int managerMode);
	void setSetupASyncronous(bool isAsync);
	void setBackgroundMusicChannel(int channel);
	void setSoundEffectsChannel(int channel);
	
private:
	bool isSoundOn;
	static ofxCocosDenshion * _instance;
	
	
	tAudioManagerMode managerMode;
	tAudioSourceChannel backgroundMusicChannel;
	tAudioSourceChannel soundEffectsChannel;
	bool aSyncronous;
	

	
};

//--------------------------------------------------

#endif /* defined(__ofxiOSCocosDenshionExample__ofxCocosDenshion__) */
