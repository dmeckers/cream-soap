#!/usr/bin/liquidsoap

def onStartHandler()
    print("onStartHandler")
    # process.run("/home/liquidsoap/config/gradio/onStart.sh")
    {}
end

def onBlankHandler()
    print("onBlankHandler")
    shutdown()
    # process.run("/home/liquidsoap/config/gradio/onBlank.sh")
    {}
end
