
local GAME_WIDTH = 512  -- 16:9 aspect ratio that fits nicely
local GAME_HEIGHT = 288 -- within the default Castle window size

function love.conf(t)
  local scale=3
  -- The window width (number)
  t.window.width = GAME_WIDTH*scale
  -- The window height (number)
  t.window.height = GAME_HEIGHT*scale
  -- Remove all border visuals from t
  t.window.borderless = false
end