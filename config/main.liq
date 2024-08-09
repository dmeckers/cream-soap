#!/usr/bin/liquidsoap

settings.request.metadata_decoders.set(["FFMPEG"])
settings.request.metadata_decoders.duration.set(false)
log("Duration metadata decoding disabled")

settings.server.telnet.set(true)
settings.server.timeout.set(-1.0)
settings.server.telnet.bind_addr.set("0.0.0.0")
settings.harbor.bind_addrs.set(["0.0.0.0"])

settings.log.level.set(1)
settings.server.log.level.set(1)
settings.log.stdout.set(true)

settings.ffmpeg.log.level.set(1)
settings.ffmpeg.log.verbosity.set("warning")

enable_replaygain_metadata()

server.harbor()
interactive.harbor()

# Create a source that streams MP3 data from the URL
radio = mksafe(input.http("https://cream-api/api/trecks"))

# Output the stream to Icecast
output.icecast(
  %mp3,
  host = "cream-cast",
  port = 8004,
  password = "icecast_source_password",
  mount = "cream.mp3",
  name = "CREAM mp3",
  description = "Cash rules everything around me C.R.E.A.M. get da money dolla dolla bill yooo",
  genre = "Hip-Hop",
  public = true,
  url = "https://cream-cast:8004/cream.mp3",
  radio
)