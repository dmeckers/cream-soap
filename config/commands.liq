#!/usr/bin/liquidsoap

# utilsUrl = getenv("UTILS_URL")
# apiToken = getenv("API_TOKEN")

# musicChannelOneRequestBpm = bpm(id="bpm", musicChannelOneRequest)

# isHotTrack = ref(false)
# lastPlayedSongIdOnOneChannel = ref("0")

# headers = [
#     ("Content-Type","application/json"),
#     ("Accept","application/json"),
#     ("Authorization","Bearer #{apiToken}")
# ]

# def postNowPlayingThread(channelId, songId, tuneQueueId)
#     url = "#{utilsUrl}api/channels/#{channelId}/history"
#     print("post request to: " ^ url)
#     j = json()
#     j.add("songId", songId)
#     j.add("tuneQueueId", tuneQueueId)
#     postData=json.stringify(j)
#     print(postData)
#     http.post(headers=headers, url, data=postData)
#     {}
# end

# def postForceQueue(channelId, songId)
#     url = "#{utilsUrl}api/channels/#{channelId}/queue/force"
#     liquidsoapVersion = liquidsoap.version
#     j = json()
#     j.add("songId", songId)
#     j.add("disableReason", "liquidsoap v#{liquidsoapVersion} cannot play")
#     postData=json.stringify(j)
#     print("API #{url}")
#     try
#         response = http.post(headers=headers, url, data=postData)
#         print("API #{url} - Response status: #{response.status_code}")
#         {success = response.status_code == 200, result = "#{response}"}
#     catch err do
#         print("API #{url} - Error: #{error.kind(err)} - #{error.message(err)}")
#         {success = false, result = ""}
#     end
# end

# def startPostNowPlayingThread(channelId, songId, tuneQueueId)
#     thread.run((fun() -> begin postNowPlayingThread(channelId, songId, tuneQueueId) end))
# end

# def startPostForceQueueThread(channelId, songId)
#     thread.run((fun() -> begin postForceQueue(channelId, songId) end))
# end

# def checkHotTrack()
#     print("This is hot track: " ^ string_of(!isHotTrack))
#     if !isHotTrack then
#         thread.run(delay=10.0, jingleOver)
#     end
# end

# def postBpm(songId, bpm)
#     url = "#{utilsUrl}api/tunes/#{songId}/bpm"
#     j = json()
#     j.add("bpm", bpm)
#     postData=json.stringify(j)
#     print("API #{url}")
#     try
#         response = http.post(headers=headers, url, data=postData)
#         print("API #{url} - Response status: #{response.status_code}")
#         {success = response.status_code == 200, result = "#{response}"}
#     catch err do
#         print("API #{url} - Error: #{error.kind(err)} - #{error.message(err)}")
#         {success = false, result = ""}
#     end
# end

# def detectBpm()
#     metadata = musicChannelOneRequest.last_metadata() ?? []
#     title = "#{metadata['artist']} - #{metadata['title']}"
#     print("------ detectBpm LASTMETADATA musicChannelOneRequest ----- #{metadata}")

#     bpm = musicChannelOneRequestBpm.bpm()
#     bpmWithTitle = "BPM: #{string_of(int_of_float(bpm))} #{title}"
#     print(bpmWithTitle)

#     if int_of_float(bpm) > 0 then
#         postBpm(metadata['songId'], bpm)
#     end

#     bpmWithTitle
# end

# def startDetectBpm()
#     thread.run(delay=40.0, (fun() -> begin detectBpm() {} end))
# end

# def addBpmCommand(~namespace, ~command)
#     server.register(
#         namespace=string_of(namespace),
#         usage=string_of(command),
#         description="Get current song BPM (beats per minute).",
#         command,
#         fun(_) -> begin detectBpm() end
#     )
# end

# addBpmCommand(namespace="gradio.one", command="bpm")


# def onMetadataHandler(metadata)
#     print("------ onMetadataHandler #{metadata}")
#     isHotTrack := if int_of_string(metadata["weight"]) > 65 then true else false end

#     channel1SourceLastMetaData = channel1Source.last_metadata() ?? []
#     musicMainLastMetaData = musicChannelOne.last_metadata() ?? []
#     print("------ onMetaData LASTMETADATA channel1Source ----- #{channel1SourceLastMetaData}")
#     print("------ onMetaData LASTMETADATA musicChannelOne ----- #{musicMainLastMetaData}")

#     # at start channel1Source is empty array so it's initial request and we want to skip check
#     if list.length(channel1SourceLastMetaData) != 0 and !lastPlayedSongIdOnOneChannel == musicMainLastMetaData['songId'] then
#        print("------ Duplicate detected turning off songId #{!lastPlayedSongIdOnOneChannel} #{musicMainLastMetaData['artist']} - #{musicMainLastMetaData['title']}")
#        startPostForceQueueThread(musicMainLastMetaData['channelId'], musicMainLastMetaData['songId'])
#     end

#     lastPlayedSongIdOnOneChannel := musicMainLastMetaData['songId']

#     if metadata["source"] == "music" then
#         startPostNowPlayingThread(metadata['channelId'], metadata['songId'], metadata['tuneQueueId'])
#         checkHotTrack()
#         startDetectBpm()
#     end
# end

# def seekTrack(seconds, sourceToSeek)
#     seekSourceMetadata = sourceToSeek.last_metadata() ?? []
#     title = "#{seekSourceMetadata['artist']} - #{seekSourceMetadata['title']}"
#     print("#{title} seeking #{seconds} seconds")
#     sourceToSeek.seek(float_of_string(seconds))
#     seekRemaining = string_of(sourceToSeek.remaining())
#     seekRemainingWithTitle = "remainingTime #{seekRemaining}: #{title}"
#     print(seekRemainingWithTitle)

#     seekRemainingWithTitle
# end

# def addSeekCommand(~namespace, ~command, sourceToSeek)
#     server.register(
#         namespace=string_of(namespace),
#         usage="#{string_of(command)} [<seconds>]",
#         description="Seek by seconds the current song in source.",
#         command,
#         fun(seconds) -> begin seekTrack(seconds, sourceToSeek) end
#     )
# end

# addSeekCommand(namespace="gradio.one", command="seek", musicChannelOne)

# channel1Source.on_metadata(onMetadataHandler)
# channel2Source.on_metadata(onMetadataHandler)

# def skipSource(sourceToSkip)
#    skipSourceLastMetaData = sourceToSkip.last_metadata() ?? []
#    metadata = json.stringify(skipSourceLastMetaData)
#    print("------ skipSource LASTMETADATA skipSourceLastMetaData ----- #{metadata}")
#    source.skip(sourceToSkip)
# end

# # Add a skip function to a source
# def addSkipCommand(~namespace, ~command, sourceToSkip)
#     server.register(
#         namespace=string_of(namespace),
#         usage=string_of(command),
#         description="Skip the current song in source.",
#         command,
#         fun(_) -> begin skipSource(sourceToSkip) "Done!" end
#     )
# end

# # Add a skip command for use via telnet
# addSkipCommand(namespace="gradio.one", command="skip", musicChannelOne)
# addSkipCommand(namespace="gradio.mix", command="skip", channel2Source)
