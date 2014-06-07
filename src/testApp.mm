#include "testApp.h"

#include "ofxRegex.h"

//--------------------------------------------------------------
void testApp::setup(){	
	
	ofSetFrameRate(60);
	
	ofSetOrientation(OF_ORIENTATION_90_LEFT); //Set iOS to Orientation Landscape Right
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
	sourceURL = "http://slyphon.es/poznan/";
	
	string files = ofLoadURL(sourceURL).data.getText();
	cout << files << endl;
	vector<string> matches = ofSplitString(files, "<a href=\"");
	
	cout << "Matched " << matches.size() << endl;
	
	imageIndex = -1;
	loadingIndex = 0;
	
	for(int i = 0; i < matches.size(); i++){
		vector<string> matches2 = ofSplitString(matches[i], "\">");
		if(matches2.size() > 0){
			if(ofToLower(matches2[0]).find("jpg") != string::npos){
				finds.push_back(matches2[0]);
			}
		}
	}
	
	ofDirectory slyDir(ofxiOSGetDocumentsDirectory() + "slyphone/");
	if(!slyDir.exists()){
		slyDir.create();
	}


	if(finds.size() == 0){
		//TODO: load all old images
		slyDir.allowExt("jpg");
		slyDir.allowExt("JPG");
		slyDir.listDir();
		
		cout << "Loading from cache " << slyDir.numFiles() << endl;
		
		for(int i = 0; i < slyDir.numFiles(); i++){
			slyPhotos.push_back( ofPixels() );
			if(!ofLoadImage(slyPhotos[i], slyDir.getPath(i))){
				ofLogError() << "Failed to load " << slyDir.getPath(i) << endl;
			}
		}
	}
	else{
		//clear the cache
		slyDir.remove(true);
		//load finds in a asynchronous loop
		loadingIndex = 0;
	}
	
}

//--------------------------------------------------------------
void testApp::update(){
	ofBackground(255,255,255);
	
	ofRectangle screenRect(0,0,ofGetWidth(),ofGetHeight());
//	for(int i = 0; i < finds.size(); i++){
//	}
	
	if(loadingIndex < finds.size()){
		cout << "LOADING: " << finds[loadingIndex] << endl;
		slyPhotos.push_back( ofPixels() );
		ofLoadImage(slyPhotos[loadingIndex], sourceURL + finds[loadingIndex] );
		ofRectangle imageRect(0, 0,
							  slyPhotos[loadingIndex].getWidth(),
							  slyPhotos[loadingIndex].getHeight() );
		imageRect.scaleTo(screenRect, OF_ASPECT_RATIO_KEEP_BY_EXPANDING);
		slyPhotos[loadingIndex].resize(imageRect.getWidth(), imageRect.getHeight());
		ofSaveImage(slyPhotos[loadingIndex], ofxiOSGetDocumentsDirectory() + "slyphone/" + finds[loadingIndex] );
		loadingIndex++;
		return;
	}
	
	if(slyPhotos.size() > 0) {
		int frame = int(ofGetElapsedTimef() / 10.) % slyPhotos.size();
		if(imageIndex != frame){
			img.setFromPixels( slyPhotos[frame] );
			imageIndex = frame;
		}
	}
	else{
		ofDrawBitmapString("NO PHOTOS", 20,20);
	}
}

//--------------------------------------------------------------
void testApp::draw(){
	ofBackground(0);
	if(loadingIndex < finds.size()){
		ofSetColor(255);
		ofDrawBitmapString("LOADING " + ofToString(loadingIndex) + " / " + ofToString(finds.size()) + " " + finds[loadingIndex], 20,20);
	}
	else if( img.isAllocated() ){
		ofRectangle imageRect(0, 0, img.getWidth(), img.getHeight() );
		ofRectangle screenRect(0,0,ofGetWidth(),ofGetHeight());
		imageRect.scaleTo(screenRect, OF_ASPECT_RATIO_KEEP_BY_EXPANDING);
		img.draw(imageRect);
	}
	
}

//--------------------------------------------------------------
void testApp::exit(){
    
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    
}


