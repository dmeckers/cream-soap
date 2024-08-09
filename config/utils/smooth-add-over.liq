# base taken from https://github.com/savonet/liquidsoap/blob/v2.0.0/libs/fades.liq#L405
# Mixes two streams, with faded transitions between the state when only the
# normal stream is available and when the special stream gets added on top of
# it.
# @category Source / Track Processing
# @flag extra
# @param ~duration Duration of the fade in seconds.
# @param ~p       Portion of amplitude of the normal source in the mix.
# @param ~normal  The normal source, which could be called the carrier too.
# @param ~special The special source.
# @param ~durationSpecial Duration of the fade in seconds.
def smooth_add_over(~duration=0.1, ~p=getter(0.2), ~normal, ~special, ~durationSpecial=0.5)
    p = getter.function(p)
    last_p = ref(p())

    def c(fn,s) =
      def v() =
        fn = !fn
        fn()
      end
      fade.scale(v,s)
    end

    special_volume = ref(fun () -> 0.)
    special = c(special_volume,special)

    normal_volume = ref(fun () -> 1.)
    normal = c(normal_volume,normal)

    def to_special(_,special) =
      last_p := p()
      q = 1. - !last_p
      normal_volume := mkfade(start=1.,stop=!last_p,duration=duration,normal)
      special_volume := mkfade(stop=q,duration=duration,special)
      special
    end

    def to_blank(special,b)
      normal_volume := mkfade(start=!last_p,duration=durationSpecial,normal)
      special_volume := mkfade(start=1.-!last_p,duration=durationSpecial,special)
      sequence([special,b])
    end

    special = fallback(track_sensitive=false,
                 transitions=[to_special,to_blank],
                 [special,blank()])

    add(normalize=false,[normal,special])
  end
