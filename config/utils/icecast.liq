# #!/usr/bin/liquidsoap

# # helper function to format metadata
# def formatMetadata(metadata, radioTitle)
#     artist = metadata["artist"]
#     title = metadata["title"]
#     if title != "" then
#       if artist != "" then
#         "#{artist} - #{title} - #{radioTitle}"
#       else
#         "#{title} - #{radioTitle}"
#       end
#     else
#       "#{radioTitle}"
#     end
#   end

#   def updateIcecastMetaDataOnChannelOne(metadata)
#       icy_data = [("song", formatMetadata(metadata, masterChannelName))]
#       icy.update_metadata(
#           host="#{radioHost}",
#           port=radioPort,
#           mount="#{radioChannelOneAACMount}",
#           password="#{radioPassword}",
#           icy_data
#       )

#       icy.update_metadata(
#           host="#{radioHost}",
#           port=radioPort,
#           mount="#{radioChannelOneMP3Mount}",
#           password="#{radioPassword}",
#           icy_data
#       )
#   end

#   def updateIcecastMetaDataOnChannelMix(metadata)
#       icy_data = [("song", formatMetadata(metadata, radioChannelMixTitle))]
#       icy.update_metadata(
#           host="#{radioHost}",
#           port=radioPort,
#           mount="#{radioChannelMixAACMount}",
#           password="#{radioPassword}",
#           icy_data
#       )

#       icy.update_metadata(
#           host="#{radioHost}",
#           port=radioPort,
#           mount="#{radioChannelMixMP3Mount}",
#           password="#{radioPassword}",
#           icy_data
#       )
#   end

#   channel1Stream.on_metadata(updateIcecastMetaDataOnChannelOne)
#   channel2Stream.on_metadata(updateIcecastMetaDataOnChannelMix)
