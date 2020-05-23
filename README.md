# lssx
lssx is an attempt at creating a short yet re-playable experience that simulates the paranoia and anxiety from the Cold War by imposing upon the player an increasingly difficult challenge, to stay alive.


* post: <https://cass.si/posts/lssx-and-lessons-learned>
* paper: <https://ftp.cass.si/==QMwAzN3g.pdf>
* presentation: <https://ftp.cass.si/=czM0YjM0A.pdf>

### zephyr
A Box2D wrapper for lssx with entity management.

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
