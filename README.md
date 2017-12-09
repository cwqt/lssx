# zephyr
A Box2D-focused engine for lssx.

## Object
```moons
Object(customHash)
```
* customHash: Define a custom hash for the object in `lssx.objects`, `string`

## PhysicsObject
```moon
PhysicsObject(world, x, y, bodyType, customHash)
```
* world: Box2D world
* x: x position of physics object, `number`
* y: y position of physics object, `number`
* bodyType: the type of body, `string`
  - `"static"`: Static bodies do not move.
  - `"dynamic"`: Dynamic bodies collide with all bodies.
  - `"kinematic"`: Kinematic bodies only collide with dynamic bodies.

## PolygonPhysicsShape
```moon
PolygonPhysicsShape(points, density, world, x, y, bodyType, customHash)
```
* points: Table listing vertices (`numbers`), `table`
* density: Density of fixture, `number`

## CirclePhysicsShape
```moon
PolygonPhysicsShape(radius, density, world, x, y, bodyType, customHash)
```
* radius: radius of circle, `number`

## Ship
```moon
Ship(points, density, world, x, y, bodyType, customHash)
```

## Projectile
```
Projectile(lifetime, points, density, world, x, y, bodyType, customHash)
```
* lifetime: time in seconds object should live for, `number`

## Entity
```
Entity(hp, customHash)
```
* hp: Entity health, `number`

## Emitter

## Asteroid
Asteroid is proceeduarlly generated in the file, thus many arguements are pre-set.
```
Asteroid(x, y, _, _, _, _, _, _, customHash)
Asteroid(10, 20, "customAsteroid")
```
* x: General x position
* y: General y position