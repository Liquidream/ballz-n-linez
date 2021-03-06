-- Welcome to your new Castle project!
-- https://castle.games/get-started
-- Castle uses Love2D 11.1 for rendering and input: https://love2d.org/
-- See here for some useful Love2D documentation:
-- https://love2d-community.github.io/love-api/

-- helper function
function fromRGB(red, green, blue) -- alpha?
  return {red/255, green/255, blue/255}
end

--
-- Constants
--
local GAME_WIDTH = 512  -- 16:9 aspect ratio that fits nicely
local GAME_HEIGHT = 288 -- within the default Castle window size
-- Screen dimensions are hardware-based (what's the size of the display device)
local SCREEN_WIDTH
local SCREEN_HEIGHT
-- Render dimenisions reflect how the game should be drawn to the canvas
local RENDER_SCALE
local RENDER_WIDTH
local RENDER_HEIGHT
local RENDER_X
local RENDER_Y
-- Other
local COL = fromRGB(22,232,244)
local NUM = 128
local MAX_SPEED = 1
--
-- Fields
--
local total_time_elapsed = 0
local ballz={}


function initScene()  
  -- Generate ballz/dots
  for i = 0,NUM do
    -- Create new ball
    local ball = {
      x = love.math.random(GAME_WIDTH),
      y = love.math.random(GAME_HEIGHT),
      dx = love.math.random()*MAX_SPEED-MAX_SPEED/2,
      dy = love.math.random()*MAX_SPEED-MAX_SPEED/2,
      lum = love.math.random(2)==1 and 0.25 or 0.5
    }
    -- Add to list
    ballz[i] = ball
  end
end

function drawScene()  
  love.graphics.clear()
  -- Default to muted colour brightness
  

  -- Draw all the ballz+linez
  for i = 0,NUM do
    -- Get the next ball...
    local ball = ballz[i]
    
    -- Update ball
    -- (Normally wouldn't do this in draw code, 
    --  but we need pos info on surrounding ballz)
    
    -- Move ball (+ wrap to screen bounds)
    ball.x = (ball.x + ball.dx) % GAME_WIDTH
    ball.y = (ball.y + ball.dy) % GAME_HEIGHT

    -- Now compare current ball to others
    for j=i,NUM do
      local otherBall = ballz[j]
      local diffX = ball.x - otherBall.x
      local diffY = ball.y - otherBall.y
      local dist = math.sqrt( diffX*diffX + diffY*diffY )
      if (dist < 50) then
        COL[4] = 1-dist/50
        love.graphics.setColor(COL)
        love.graphics.line(ball.x, ball.y, otherBall.x, otherBall.y)
      end
    end

    -- Finally, draw the ball/dot
    COL[4] = ball.lum
    love.graphics.setColor(COL)
    love.graphics.circle("fill", ball.x, ball.y, 1)
  end
end

function updateScene()  
 -- (All in draw code...)
end


-- Recalibrate the render display, based on current display dimensions
-- (e.g. after change to/from Fullscreen)
local function updateDisplay()
  -- Screen dimensions are hardware-based (what's the size of the display device)
  local width, height = love.graphics.getDimensions()
  SCREEN_WIDTH = width
  SCREEN_HEIGHT = height
  -- Create new canvas for drawing on
  RENDER_CANVAS = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)
  RENDER_CANVAS:setFilter("nearest", "nearest")
  RENDER_SCALE = math.floor(math.min(SCREEN_WIDTH / GAME_WIDTH, SCREEN_HEIGHT / GAME_HEIGHT))
  RENDER_WIDTH = RENDER_SCALE * GAME_WIDTH
  RENDER_HEIGHT = RENDER_SCALE * GAME_HEIGHT
  RENDER_X = math.floor((SCREEN_WIDTH - RENDER_WIDTH) / 2)
  RENDER_Y = math.floor((SCREEN_HEIGHT - RENDER_HEIGHT) / 2)
end


function love.load()
  -- Test for Nikki
  local width, height = love.graphics.getDimensions()
  print(">>>> Nikki: "..width..","..height)
  
  -- initialise and update the gfx display
  updateDisplay()
  -- initilise the scene
  initScene()
end

function love.draw()
  --This sets the draw target to the canvas
  love.graphics.setCanvas(RENDER_CANVAS)
  -- Set "Point/Non-AA" Filters for...
  love.graphics.setDefaultFilter('nearest', 'nearest') -- Sprites (Quads)
  love.graphics.setLineStyle("rough")                  -- Shapes (Circles, Lines...)

  -- Draw our actual scene
  drawScene()

  -- Draw the canvas, scaled, to screen
  love.graphics.setCanvas() --This sets the target back to the screen
  -- Center everything within Castle window
  love.graphics.push()
    -- Apply "Center to Window" transformations
    love.graphics.translate(RENDER_X, RENDER_Y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(RENDER_CANVAS, 0, 0, 0, RENDER_SCALE, RENDER_SCALE)
  -- Pop centering within Castle window
  love.graphics.pop()
end

function love.update(dt)
  total_time_elapsed = total_time_elapsed + dt
end

-- Force recalc of render dimensions on resize
-- (especially on Fullscreen switch)
function love.resize(w,h)
  updateDisplay()
 end

