
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )

local box1
local box2
local box3
local box4

local gameLoopTimer
local countBox = 0
local countBoxText

local backGroup
local mainGroup
local uiGroup

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

local boxFloatingTable = {}

local wrongTap = 0
local gameLost

local function endGame()
  composer.setVariable( "finalScore", countBox )
  composer.removeScene( "highscores" )
  composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

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
      countBoxText.text = "Score: " .. tostring( countBox )
    else
      wrongTap = wrongTap + 1
      wrongTapText.text = "Missed: " .. tostring( wrongTap )
    end

    if wrongTap == 3 then
      timer.performWithDelay( 2000, endGame )
      for i=#boxFloatingTable, 1, -1 do
        display.remove( boxFloatingTable[i] )
        table.remove( boxFloatingTable, i )
      end
      gameLost = display.newText( uiGroup, "You Lost!", display.contentCenterX, 200, native.systemFont, 40 )
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

-- Table of emitter parameters
local emitterParams = {
    startColorAlpha = 1,
    startParticleSizeVariance = 3.47,
    startColorGreen = 0.3031555,
    yCoordFlipped = -1,
    blendFuncSource = 770,
    rotatePerSecondVariance = 153.95,
    particleLifespan = 0.5237,
    tangentialAcceleration = -144.74,
    finishColorBlue = 0.3699196,
    finishColorGreen = 0.5443883,
    blendFuncDestination = 1,
    startParticleSize = 5.95,
    startColorRed = 0.8373094,
    textureFileName = "splash.png",
    startColorVarianceAlpha = 1,
    maxParticles = 3,
    finishParticleSize = 10,
    duration = -1,
    finishColorRed = 1,
    maxRadiusVariance = 2.63,
    finishParticleSizeVariance = 3,
    gravityy = -1.05,
    speedVariance = 10.79,
    tangentialAccelVariance = -12.11,
    angleVariance = -20.62,
    angle = -24.11
}

local emitter
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()

	backGroup = display.newGroup()
	sceneGroup:insert( backGroup )

	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	countBoxText = display.newText( sceneGroup, "Score: " .. tostring(countBox), 90, 30, native.systemFont, 25 )
  wrongTapText = display.newText( sceneGroup, "Missed: " .. tostring(wrongTap), 225, 30, native.systemFont, 25 )

	local background = display.newImageRect( backGroup, "background.png", 350, 500)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

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

  emitter = display.newEmitter( emitterParams )
  emitter.x = display.contentCenterX
  emitter.y = display.contentCenterY

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		physics.pause()
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
