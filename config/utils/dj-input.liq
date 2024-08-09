#!/usr/bin/liquidsoap

# utilsUrl = getenv("UTILS_URL")
# apiToken = getenv("API_TOKEN")

# djId = ref(0)
# djSource = ref(blank())

# headers = [
#     ("Content-Type","application/json"),
#     ("Accept","application/json"),
#     # ("Authorization","Bearer #{apiToken}")
# ]

# def postDjIsAuth(params)
#     url = "#{utilsUrl}api/djs/auth"
#     j = json()
#     j.add("username", params.user)
#     j.add("password", params.password)
#     postData=json.stringify(j)
#     print("API #{url}")
#     try
#         response = http.post(headers=headers, url, data=postData)
#         print("API #{url} - Response (#{response.status_code}): #{response}")
#         {success = response.status_code == 200, result = "#{response}"}
#     catch err do
#         print("API #{url} - Error: #{error.kind(err)} - #{error.message(err)}")
#         {success = false, result = ""}
#     end
# end

# def checkDjIsAuth(params)
#     response = postDjIsAuth(params)
#     canConnect = ref(false)
#     if (response.success != true) or (response.result == "") or (string.match(pattern="Error", response.result)) then
#         canConnect := false
#     else
#         result = response.result

#         let json.parse ({
#           id,
#           can_connect,
#         } : {
#           id: int,
#           can_connect: bool,
#         }) = result

#         djId := id
#         canConnect := can_connect
#     end
#     print("checkDjIsAuth can connect " ^ string_of(!canConnect))
#     !canConnect
# end

# def patchDj(postData)
#     url = "#{utilsUrl}api/djs/#{!djId}"
#     print("API #{url}")
#     try
#         response = http.post(headers=headers, url, data=postData)
#         print("API #{url} - Response (#{response.status_code}): #{response}")
#         {success = response.status_code == 200, result = "#{response}"}
#     catch err do
#         print("API #{url} - Error: #{error.kind(err)} - #{error.message(err)}")
#         {success = false, result = ""}
#     end
# end

# def record()
#     output.file(fallible=true, %mp3(samplerate=44100, bitrate=320), "content/archive/%Y-%m-%d-%H-%M-%S.mp3", !djSource)
#     {}
# end

# def startRecord()
#     thread.run((fun() -> begin record() end))
# end

# def currentDateTime()
#     timeStamp = time.local()
#     year = string_of(timeStamp.year)
#     month = string_of(timeStamp.month)
#     day = string_of(timeStamp.day)
#     hour = string_of(timeStamp.hour)
#     min = string_of(timeStamp.min)
#     sec = string_of(timeStamp.sec)

#     "#{year}-#{month}-#{day} #{hour}:#{min}:#{sec}"
# end

# def onConnect(headers)
#     startRecord()
#     j = json()
#     postData=json.stringify(j)
#     j.add("is_live", true)
#     j.add("is_recording", true)
#     j.add("connect_count", 1)
#     j.add("last_connected_at", currentDateTime())
#     postData=json.stringify(j)
#     patchDj(postData)
#     print("DJ connected!")
# end

# def onDisconnect()
#     j = json()
#     postData=json.stringify(j)
#     j.add("is_live", false)
#     j.add("is_recording", false)
#     j.add("last_disconnected_at", currentDateTime())
#     postData=json.stringify(j)
#     patchDj(postData)
#     print("DJ disconnected!")
# end

# try
#     djSource := input.harbor(id="inputDjSource", auth=checkDjIsAuth, on_connect=onConnect, on_disconnect=onDisconnect, password="hackme", port=8005, "dj")
# catch err do
#     print("Error with input.harbor - Error: #{error.kind(err)} - #{error.message(err)}")
# end
