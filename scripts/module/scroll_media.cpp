#include <iostream>
#include <unistd.h>
#include <cstdio>
#include <memory>
#include <array>
#include <string.h>
#include <vector>
#include <cstdlib>
#include <thread>
#include <chrono>
#include <iomanip>
using namespace std;

string get_media_name(const char* cmd) {
    char buffer[128];
    string result = "";
    FILE* pipe = popen(cmd, "r");
    if (!pipe) throw runtime_error("popen() failed!");
    try {
        while (fgets(buffer, sizeof buffer, pipe) != NULL) {
            result += buffer;
        }
    } catch (...) {
        pclose(pipe);
        throw;
    }
    pclose(pipe);
    return result;
    // i love stackoverflow lol, source : https://stackoverflow.com/questions/478898/how-do-i-execute-a-command-and-get-the-output-of-the-command-within-c-using-po
}

int main(int argc, char* argv[]){

    vector<string> args(argv + 1, argv + argc);

    // default config
    int max_string_length = 30; 
    unsigned int interval = 400; //milisecond


    for (size_t i = 0; i < args.size(); ++i) {
        if (args[i] == "-l" && i + 1 < args.size()) {
            max_string_length = stoi(args[++i]);
            // cout << "string length : " << string_length << endl;
        }
        else if (args[i] == "-t" && i + 1 < args.size()) {
            interval =  stoi(args[++i])*100000;
            // cout << "time interval : " << interval <<endl;
        }
    }
    
    string old_media = "?";
    string scroll_media = "";
    int index = 0;
    while (true){
        
        string media = get_media_name("~/.config/eww/scripts/spotify_status.sh");
        media.pop_back();
        media += " [/] ";
        if (media != old_media){
            old_media = media;
            scroll_media = media;
            index = 0;
        }
        else{
            if (index == media.length()) index = 0;
            int rolling_index = index;
            scroll_media = "";
            for (int i=0; i<=max_string_length; i++){
                if (rolling_index==media.length()-1)  rolling_index = 0; else rolling_index ++;
                scroll_media += media.at(rolling_index);  
            };
            // pause
            usleep(interval);
            // system("clear");
            cout  << "\u00A0" << scroll_media << "\u00A0" << endl;
            cout.flush();
            index++;
        }
        
    }

}
