#include "ofMain.h"
#include "MapRouteApp.h"

int main(){
    
        ofAppiPhoneWindow *window = new ofAppiPhoneWindow();
        ofSetupOpenGL(ofPtr<ofAppBaseWindow>(window), 1024,768, OF_FULLSCREEN);
        window->enableRetina();
        window->startAppWithDelegate("MyAppDelegate");
}
