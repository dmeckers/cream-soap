#!/usr/bin/liquidsoap

# output.icecast(id=radioChannelOneAACId, %fdkaac(
#   samplerate=44100,
#   channels=2,
#   bitrate=128,
#   afterburner=true,
#   aot="mpeg4_aac_lc",
#   sbr_mode=true
# ),
#   mount="#{radioChannelOneAACMount}",
#   name="#{masterChannelName} aac",
#   host="#{radioHost}",
#   port=radioPort,
#   password="#{radioPassword}",
#   genre="#{radioChannelOneGenre}",
#   url="#{radioChannelOneUrl}",
#   description="#{radioChannelOneDescription}",
#   encoding="UTF-8",
#   icy_metadata="true",
#   public=true,
#   channel1Stream
# )

masterChannelStream=mksafe(
  pipe(
    restart_on_error=true,
    "/usr/bin/ffmpeg -i /mnt/music/cream.mp3 -f s16le -ar 44100 -ac 2 -"
    )
  )

output.icecast(id=radioChannelOneMP3Id, %mp3(
  samplerate=44100,
  stereo=true,
  bitrate=320,
  id3v2=true
),
  mount="#{masterChannelMP3Mount}",
  name="#{masterChannelName} mp3",
  host="#{radioHost}",
  port=radioPort,
  password="#{radioPassword}",
  genre="#{masterChannelGenres}",
  url="#{radioChannelOneUrl}",
  description="#{radioChannelOneDescription}",
  encoding="UTF-8",
  icy_metadata="true",
  public=true,
  channel1Stream
)

# output.icecast(id=radioChannelMixAACId, %fdkaac(
#   samplerate=44100,
#   channels=2,
#   bitrate=128,
#   afterburner=true,
#   aot="mpeg4_aac_lc",
#   sbr_mode=true
# ),
#   mount="#{radioChannelMixAACMount}",
#   name="#{radioChannelMixTitle} aac",
#   host="#{radioHost}",
#   port=radioPort,
#   password="#{radioPassword}",
#   genre="#{radioChannelMixGenre}",
#   url="#{radioChannelMixUrl}",
#   description="#{radioChannelMixDescription}",
#   encoding="UTF-8",
#   icy_metadata="true",
#   public=true,
#   channel2Stream
# )


