#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofBackground(255);
	ofSetOrientation(OF_ORIENTATION_90_RIGHT);
	
	ofxCocosDenshion * soundManager = ofxCocosDenshion::getInstance();
	soundManager->setup();
	
	synth = soundManager->addSoundEffect("sounds/synth.mp3", 0.75);
	beats = soundManager->addSoundEffect("sounds/1085.caf", 0.75);
	vocals = soundManager->addSoundEffect("sounds/Violet.wav", 0.5);
	
	soundManager->loadAllAudio();
	
	font.loadFont("fonts/Sudbury_Basin_3D.ttf", 18);
}

//--------------------------------------------------------------
void ofApp::update(){
	//
}

//--------------------------------------------------------------
void ofApp::draw(){
    
	char tempStr[255];
	
	float sectionWidth = ofGetWidth() / 3.0f;

    // draw the background colors:
	ofSetHexColor(0xeeeeee);
	ofRect(0, 0, sectionWidth, ofGetHeight());
	ofSetHexColor(0xffffff);
	ofRect(sectionWidth, 0, sectionWidth, ofGetHeight());
	ofSetHexColor(0xdddddd);
	ofRect(sectionWidth * 2, 0, sectionWidth, ofGetHeight());
    
	//---------------------------------- synth:
	if(ofxCocosDenshion::getInstance()->isSoundPlaying(synth)) {
        ofSetHexColor(0xFF0000);
    } else {
        ofSetHexColor(0x000000);
    }
	font.drawString("synth !!", 10,50);
	
	ofSetColor(0);
	//sprintf(tempStr, "click to play\nposition: %f\nspeed: %f\npan: %f", synth.getPosition(),  synth.getSpeed(), synth.getPan());
	ofDrawBitmapString(tempStr, 10, ofGetHeight() - 50);
    
	//---------------------------------- beats:
	if (ofxCocosDenshion::getInstance()->isSoundPlaying(beats)) {
        ofSetHexColor(0xFF0000);
    } else {
        ofSetHexColor(0x000000);
    }
	font.drawString("beats !!", sectionWidth + 10, 50);
    
	ofSetHexColor(0x000000);
	//sprintf(tempStr, "click to play\nposition: %f\nspeed: %f\npan: %f", beats.getPosition(),  beats.getSpeed(), beats.getPan());
	ofDrawBitmapString(tempStr, sectionWidth + 10, ofGetHeight() - 50);
    
	//---------------------------------- vocals:
	if (ofxCocosDenshion::getInstance()->isSoundPlaying(vocals)) {
        ofSetHexColor(0xFF0000);
    } else {
        ofSetHexColor(0x000000);
    }
	font.drawString("vocals !!", sectionWidth * 2 + 10, 50);
    
	ofSetHexColor(0x000000);
	//sprintf(tempStr, "click to play\nposition: %f\nspeed: %f\npan: %f", [vocals position],  [vocals speed], [vocals pan]);
	ofDrawBitmapString(tempStr, sectionWidth * 2 + 10, ofGetHeight() - 50);
}

//--------------------------------------------------------------
void ofApp::exit(){
//    [vocals release];
//    vocals = nil;
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
	if( touch.id != 0 ){
        return;
    }
		
    float sectionWidth = ofGetWidth() / 3.0f;
    float speed = ofMap(touch.y, ofGetHeight(), 0, 0.5, 2.0, true);
    float pan = 0;
    
    if (touch.x < sectionWidth){
        pan = ofMap(touch.x, 0, sectionWidth, -1.0, 1.0, true);
        
		ofxCocosDenshion::getInstance()->playSound(synth);
		ofxCocosDenshion::getInstance()->setSoundPan(synth, pan);
        
    } else if(touch.x < sectionWidth * 2) {
        pan = ofMap(touch.x, sectionWidth, sectionWidth * 2, -1.0, 1.0, true);
        ofxCocosDenshion::getInstance()->playSound(beats);
		ofxCocosDenshion::getInstance()->setSoundPan(beats, pan);
        
    } else if(touch.x < sectionWidth * 3) {
        pan = ofMap(touch.x, sectionWidth * 2, sectionWidth * 3, -1.0, 1.0, true);
       ofxCocosDenshion::getInstance()->playSound(vocals);
		ofxCocosDenshion::getInstance()->playSound(vocals);
		ofxCocosDenshion::getInstance()->setSoundPan(vocals, pan);
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
	if( touch.id != 0 ){
        return;
    }
    
    float sectionWidth = ofGetWidth() / 3.0f;
    float speed = ofMap(touch.y, ofGetHeight(), 0, 0.5, 2.0, true);
    float pan = 0;

    if (touch.x < sectionWidth){
        pan = ofMap(touch.x, 0, sectionWidth, -1.0, 1.0, true);
        
        ofxCocosDenshion::getInstance()->setSoundPan(synth, pan);

    } else if(touch.x < sectionWidth * 2) {
        pan = ofMap(touch.x, sectionWidth, sectionWidth * 2, -1.0, 1.0, true);
        
        ofxCocosDenshion::getInstance()->setSoundPan(beats, pan);

    } else if(touch.x < sectionWidth * 3) {
        pan = ofMap(touch.x, sectionWidth * 2, sectionWidth * 3, -1.0, 1.0, true);
        
       ofxCocosDenshion::getInstance()->setSoundPan(vocals, pan);
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    
}
