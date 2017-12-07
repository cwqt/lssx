CameraManager = {}

CameraManager.load = (x, y) ->
  lssx.camera = Camera(x, y) -- , lssx.WIDTH, lssx.HEIGHT
  lssx.camera\setFollowLerp(0.1)
  lssx.camera\setFollowLead(20)
  lssx.camera\setFollowStyle('LOCKON')
  -- lssx.camera.x, lssx.camera.y = x, y
  Debugger.log("Camera started, looking at " .. x .. ", " .. y)

CameraManager.update = (dt) ->
  lssx.camera\update(dt)
  if CameraManager.lockTarget != nil
    cx, cy = CameraManager.lockTarget.ship.body\getPosition()
    lssx.camera\follow(cx, cy)
    lssx.camera.scale = lssx.CAMERA_ZOOM-math.clamp(0, math.abs(CameraManager.lockTarget.ship.body\getLinearVelocity()/1000), 0.5)

CameraManager.attach = () ->
  lssx.camera\attach()

CameraManager.detach = () ->
  lssx.camera\detach()
  lssx.camera\draw()

CameraManager.setLockTarget = (object) ->
  CameraManager.lockTarget = object
  Debugger.log("Changed camera lock target")

return CameraManager
