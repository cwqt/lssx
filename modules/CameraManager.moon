CameraManager = {}

CameraManager.load = (x, y) ->
  lssx.camera = Camera(x, y) -- , lssx.WIDTH, lssx.HEIGHT
  lssx.camera\setFollowLerp(0.05)
  lssx.camera\setFollowLead(20)
  lssx.camera\setFollowStyle('TOPDOWN_TIGHT')
  Debugger.log("CameraManager created")
  lssx.camera\setBounds(-300, -200, 2600, 2400) --x,y,w,h

CameraManager.update = (dt) ->
  lssx.camera\update(dt)
  if lssx.objects[CameraManager.lockTarget] != nil
    if not lssx.world\isLocked()
      cx, cy = lssx.objects[CameraManager.lockTarget].ship.body\getPosition()
      v = lssx.objects[CameraManager.lockTarget].ship.body\getLinearVelocity()
      lssx.camera\follow(cx, cy)
      lssx.camera.scale = lssx.CAMERA_ZOOM-math.clamp(0, math.abs(v/1000), 0.5)

CameraManager.attach = () ->
  lssx.camera\attach()

CameraManager.detach = () ->
  lssx.camera\detach()
  lssx.camera\draw()

CameraManager.setLockTarget = (object) ->
  CameraManager.lockTarget = object.hash
  Debugger.log("Camera setLockTarget -> " .. object.hash)

CameraManager.shake = (intensity, duration, frequency) ->
  frequency = frequency or 60
  lssx.camera\shake(intensity, duration, frequency)

return CameraManager
