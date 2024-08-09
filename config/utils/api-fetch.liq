#!/usr/bin/liquidsoap

MEDIA_PROVIDER_API_URL = getenv("MEDIA_PROVIDER_API_URL")
# apiToken = getenv("API_TOKEN")

creamMediaRequest = request.dynamic(id="masterChannel", prefetch=0, retry_delay=5., {null()})

headers = [
    ("Content-Type","application/json"),
    ("Accept","application/json"),
    # ("Authorization","Bearer #{apiToken}")
]

def api_call() =
    url = "#{MEDIA_PROVIDER_API_URL}/api/channels/cream/queue/next"

    print("API Sending GET request to #{url}")
    try
        response = http.get(headers=headers, url)
        print("API #{url} - Response status: #{response.status_code}")
        {success = response.status_code == 200, result = "#{response}"}
    catch err do
        print("API #{url} - Error: #{error.kind(err)} - #{error.message(err)}")
        {success = false, result = ""}
    end
end

def dynamicRequest() =
    response = api_call()
    if (response.success != true) or (response.result == "") or (string.match(pattern="Error", response.result)) then
        null()
    else
        result = response.result

        let json.parse ({ id , path } : { id: int , path : string }) = result

        if path == "" then
            print("Error: Path is empty in the response")
            null()
        else
            fullPath = "annotate:source=\"music\":/mnt/music/#{path}"

            r = request.create(fullPath)
            if request.resolve(r) then
                r
            else
                null()
            end
        end
    end
end



def onStartCream()
  print('custom on start onStartCream')
  req = dynamicRequest()

  if not (null.defined(req) and creamMediaRequest.add(null.get(req))) then
    print('Error while queueing initial request for channel 1!')
  end
end

def onEndCream(a, b)
  print('custom on end onEndCream')
  req = dynamicRequest()

  if not (null.defined(req) and creamMediaRequest.add(null.get(req))) then
    print('Error while queueing next request for ChannelOne!')
  end
end

