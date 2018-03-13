class GlitchText extends Object
  new: (@content, @time, @x, @y, ...) =>
    super(...)

    @k = 0
    @t = {}

    @content = @content or "ERR"

    --Split prior string into letters
    for a=1, #@content do
      @t[#@t+1] = @content\sub(a, a)
      
    @Timer = Timer.new()

    @Timer\after 1, ->
      @Timer\every 0.015, ->
        random_characters = '!@#$%&*()-=+[]^~/;?><.,|ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        for i, character in ipairs(@t) do
          if love.math.random(1, 20) <= 1 then
            r = love.math.random(1, #random_characters)
            @t[i] = random_characters\sub(r,r)
            @content = table.concat(@t)
            @k = @k + 1
            -- Randomize 10 times,
            if @k > 3
              @Timer\clear()
              super\remove()

  update: (dt) =>
    @Timer\update(dt)

  draw: () =>
    PushRotateScale(@x, @y, 0, 0.5, 0.5)
    -- love.graphics.setColor(255,100,100)
    love.graphics.setFont(lssx.TITLEF)
    love.graphics.print(@content, @x, @y)
    love.graphics.setColor(255,255,255)
    love.graphics.setFont(lssx.TEXTF)
    love.graphics.pop()