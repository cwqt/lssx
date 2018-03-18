# zephyr
Source code for __lssx__, __zephyr__ is the physics wrapper for it, except I just continued development of it in this repo because laziness.
<https://ttxi.gq/blog/lssx-and-lessons-learned>

A Box2D wrapper for lssx.

```moon
Physics.beginContact = (a, b, coll) ->
  -- a handles collision with b
  lssx.objects[a\getBody()\getUserData().hash]\beginContact(b)
  -- b handles collision with a
  lssx.objects[b\getBody()\getUserData().hash]\beginContact(a)
```
And then say, in object A:
```moon
beginContact: (other) =>
  collObj = lssx.objects[other\getBody()\getUserData().hash]
  switch collObj.__class
    when 'coin'
      collObj\Pickup()
      collObj\Destroy()
    when 'spikes'
      @Die()
``` 

Documentation included in whitepaper (to be released.)
