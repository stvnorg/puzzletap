-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
display.setStatusBar ( display.HiddenStatusBar )

math.randomseed(os.time())

local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local box1
local box2
local box3
local box4

local gameLoopTimer
local countBox = 0
local countBoxText = display.newText( uiGroup, "0", display.contentCenterX, 30, native.systemFont, 36 )

local background = display.newImageRect( backGroup, "background.png", 350, 500)
background.x = display.contentCenterX
background.y = display.contentCenterY

local sheetOptions = {
  frames = {
    {
      -- Box 1
      x = 0,
      y = 0,
      width = 60,
      height = 70,
    },
    {
      -- Box 2
      x = 0,
      y = 70,
      width = 60,
      height = 70,
    },
    {
      -- Box 3
      x = 0,
      y = 140,
      width = 60,
      height = 70,
    },
    {
      -- Box 4
      x = 0,
      y = 210,
      width = 60,
      height = 70,
    },
  }
}

local objectSheet = graphics.newImageSheet( "imageObject.png", sheetOptions )

box1 = display.newImageRect( mainGroup, objectSheet, 1, 60, 70 )
box1.x = display.contentWidth - 200
box1.y = display.contentHeight - 300
box1.myName = "box1"

box2 = display.newImageRect( mainGroup, objectSheet, 2, 60, 70 )
box2.x = display.contentWidth - 120
box2.y = display.contentHeight - 304
box2.myName = "box2"

box3 = display.newImageRect( mainGroup, objectSheet, 3, 60, 70 )
box3.x = display.contentWidth - 200
box3.y = display.contentHeight - 230
box3.myName = "box3"

box4 = display.newImageRect( mainGroup, objectSheet, 4, 60, 70 )
box4.x = display.contentWidth - 120
box4.y = display.contentHeight - 232.5
box4.myName = "box4"

local boxFloatingTable = {}

local function boxFloating()

  local sheetNumber = math.random(4)
  local box = display.newImageRect( mainGroup, objectSheet, sheetNumber, 60, 70 )
  box:scale( 0.5, 0.5 )

  if (sheetNumber == 1 ) then box.myName = "box1"
  elseif (sheetNumber == 2 ) then box.myName = "box2"
  elseif (sheetNumber == 3 ) then box.myName = "box3"
  end

  table.insert( boxFloatingTable, box )
  physics.addBody( box, "dynamic", { radius=30, bounce=0.2 } )

  local function checkBox()
    if ( box.myName == "box1" or box.myName == "box2" or box.myName == "box3" ) then
      countBox = countBox + 1
      countBoxText.text = tostring(countBox)
    end
  end

  box:addEventListener( "tap", checkBox )

  local whereFrom = math.random(3)

  if ( whereFrom == 1 ) then
    box.x = -60
    box.y = math.random( 500 )
    box:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
  elseif ( whereFrom == 2 ) then
    box.x = math.random( display.contentWidth )
    box.y = -60
    box:setLinearVelocity( math.random( -40,40 ), math.random( 40, 120 ) )
  elseif ( whereFrom == 3 ) then
    box.x = display.contentWidth + 60
    box.y = math.random( 500 )
    box:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
  end

  box:applyTorque( math.random( -3, 3 ) )

end

local function gameLoop()

  -- Create new asteroid
  boxFloating()

  -- Remove asteroids which have drifted off screen
  for i = #boxFloatingTable, 1, -1 do
    local thisBox = boxFloatingTable[i]

    if (
        thisBox.x < -100 or
        thisBox.x > display.contentWidth + 100 or
        thisBox.y < -100 or
        thisBox.y > display.contentHeight + 100
      )
    then
      display.remove ( thisBox )
      table.remove( boxFloatingTable, i )
    end
  end
end

gameLoopTimer = timer.performWithDelay( 300, gameLoop, 0)
