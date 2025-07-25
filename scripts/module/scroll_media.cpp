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

int utf8_char_length(const string& str, size_t pos) {
    if (pos >= str.length()) return 0;
    
    unsigned char c = str[pos];
    if (c < 0x80) return 1;         // ASCII
    else if (c < 0xE0) return 2;    // 2-byte UTF-8
    else if (c < 0xF0) return 3;    // 3-byte UTF-8
    else return 4;                  // 4-byte UTF-8
}

// Function to extract UTF-8 characters from string
vector<string> utf8_split(const string& str) {
    vector<string> chars;
    size_t pos = 0;
    
    while (pos < str.length()) {
        int len = utf8_char_length(str, pos);
        if (len > 0 && pos + len <= str.length()) {
            chars.push_back(str.substr(pos, len));
            pos += len;
        } else {
            // Handle invalid UTF-8 by taking single byte
            chars.push_back(str.substr(pos, 1));
            pos++;
        }
    }
    return chars;
}

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
    unsigned int interval = 400; //millisecond
    
    for (size_t i = 0; i < args.size(); ++i) {
        if (args[i] == "-l" && i + 1 < args.size()) {
            max_string_length = stoi(args[++i]);
            // cout << "string length : " << string_length << endl;
        }
        else if (args[i] == "-t" && i + 1 < args.size()) {
            interval = stoi(args[++i]) * 100000;
            // cout << "time interval : " << interval <<endl;
        }
    }
    
    string old_media = "?";
    string scroll_media = "";
    int index = 0;
    vector<string> media_chars; // Store UTF-8 characters
    
    while (true){
        string media = get_media_name("~/.config/eww/scripts/media/spotify_status.sh");
        media.pop_back();
        media += " [/] ";
        
        if (media != old_media){
            old_media = media;
            media_chars = utf8_split(media); // Split into UTF-8 characters
            scroll_media = media;
            index = 0;
        }
        else{
            if (index >= (int)media_chars.size()) index = 0;
            int rolling_index = index;
            scroll_media = "";
            
            // Build the scrolled string using complete utf8 characters
            for (int i = 0; i < max_string_length && i < (int)media_chars.size(); i++){
                if (rolling_index >= (int)media_chars.size()) rolling_index = 0;
                scroll_media += media_chars[rolling_index];
                rolling_index++;
            }
            
            // pause
            usleep(interval);
            // system("clear");
            cout << "\u00A0" << scroll_media << "\u00A0" << endl;
            cout.flush();
            index++;
        }
    }
}