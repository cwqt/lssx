# zephyr
A Box2D-focused engine for lssx.

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

## Object
```moon
Object(customHash)
```
* __customHash__: Define a custom hash for the object in `lssx.objects`, `string`

## PhysicsObject
```moon
PhysicsObject(world, x, y, bodyType, customHash)
```
* __world__: Box2D world
* __x__: x position of physics object, `number`
* __y__: y position of physics object, `number`
* __bodyType__: the type of body, `string`
  - `"static"`: Static bodies do not move.
  - `"dynamic"`: Dynamic bodies collide with all bodies.
  - `"kinematic"`: Kinematic bodies only collide with dynamic bodies.

## PolygonPhysicsShape
```moon
PolygonPhysicsShape(points, density, world, x, y, bodyType, customHash)
```
* __points__: Table listing vertices (`numbers`), `table`
* __density__: Density of fixture, `number`

## CirclePhysicsShape
```moon
PolygonPhysicsShape(radius, density, world, x, y, bodyType, customHash)
```
* __radius__: radius of circle, `number`

## Ship
```moon
Ship(points, density, world, x, y, bodyType, customHash)
```

## Projectile
```moon
Projectile(x, y, points, lifetime)
Projectile(lifetime, points, density, world, x, y, bodyType, customHash)
```
* __lifetime__: time in seconds object should live for, `number`

## Entity
```moon
Entity(hp, customHash)
```
* __hp__: Entity health, `number`

## Emitter

## Asteroid
Asteroid is proceeduarlly generated in the file, thus many arguements are pre-set.
```moon
Asteroid(x, y, _, _, _, _, _, _, customHash)
Asteroid(10, 20, "customAsteroid")
```
* __x__: General x position
* __y__: General y position
