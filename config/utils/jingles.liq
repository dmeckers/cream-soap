#!/usr/bin/liquidsoap

jinglesOverSource = playlist(id="jingleOverSource", prefix="annotate:type=\"jingles\":", reload_mode="watch", "~/content/jingles")

playJingleOverRef = ref(false)

def jingleOver()
    print("jingleOver called")
    playJingleOverRef := true
    jingleOverRequest = jinglesOverSource.current()
    print("jinglesOverSource.current() #{jingleOverRequest}")
    if jingleOverRequest != null() then
      jingleOverMetadata = request.metadata(null.get(jingleOverRequest))
      print("------ jingleOver LASTMETADATA jingleOverMetadata ----- #{jingleOverMetadata}")
    end
end

def addRandomJingleCommand(~namespace, ~command)
    server.register(
        namespace=string_of(namespace),
        usage=string_of(command),
        description="Play random jingle over stream",
        command,
        fun(_) -> begin jingleOver() "Done!" end
    )
 end

addRandomJingleCommand(namespace="gradio.one", command="randomJingle")

def jinglesOverOnTrack(_) =
  playJingleOverRef := false
  isJingleOverInteractive.set(false)
end

# Play a jingle when `playJingleOverRef` is set to `true`
jinglesOverSource = switch([({!playJingleOverRef}, jinglesOverSource)])

# Play one jingle at a time by setting `playJingleOverRef` to
# `false` immediately after one starts playing (`switch`
# above is `track_sensitive` so track will keep playing until
# it ends.
jinglesOverSource.on_track(jinglesOverOnTrack)

def checkJingleOver ()
  if isJingleOverInteractive() then
    print("isJingleOverInteractive")
    jingleOver()
  end
end

thread.run(every=1., checkJingleOver)

%include "smooth-add-over.liq"

channel1Source = smooth_add_over(duration=0.1, p=0.2, normal='channel1Source', special=jinglesOverSource, durationSpecial=0.5)

