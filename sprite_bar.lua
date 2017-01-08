
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )

local backGroup
local mainGroup
local uiGroup

local background
local scoreBoxText
local score = 0
local lives = 100
local whichBoxText

local sheetOptions = {
	width = 29,
	height = 80,
	numFrames = 4
}

local sheet_bar
local barSprite
local bullet
local laserLoopTimer
-- Sequences table
local sequences_Bar = {
	-- Consecutive frames sequences
	{
		name = "goDown",
		start = 1,
		count = 4,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	-- Non-consecutive frames sequences
	{
		name = "goUp",
		frames = { 4,3,2,1 },
		--start = 1,
		--count = 4,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	}
}

-- Sprite listener function
local function spriteListener( event )

	local thisSprite = event.target -- "event.target" references the sprite

	if ( event.phase == "ended" ) then
		thisSprite:setSequence( "fastRun" )
		thisSprite:play()
		-- display.remove( thisSprite )
	end
end

local barPosition = "UP"

local function playBarSprite()
	if barPosition == "UP" then
		barSprite:setSequence( "goDown" )
		barSprite:play()
		barPosition = "DOWN"
	elseif barPosition == "DOWN" then
		barSprite:setSequence( "goUp" )
		barSprite:play()
		barPosition = "UP"
	end
end

local newLaserTable = {}

local function fireLaser()

  local newLaser = display.newImageRect( mainGroup, "bullet.png", 50, 10 )
	newLaser:scale( 0.6, 0.6 )
  physics.addBody( newLaser, "dynamic", { isSensor=true } )
  newLaser.isBullet = true
  newLaser.myName = "laser"
	table.insert( newLaserTable, newLaser )
  newLaser.x = display.contentCenterX + 100
  newLaser.y = display.contentCenterY
  --newLaser:toBack()
  transition.to ( newLaser, { x=-40, y=display.contentCenterY-30, time=500,
    onComplete = function() display.remove( newLaser ) end
  } )

end

local function removeNewLaser()
	for i=1, #newLaserTable do
		display.remove( newLaserTable[i] )
		table.remove( newLaserTable, i )
	end
end

local function gotoMenu()
	timer.cancel( laserLoopTimer )
	removeNewLaser()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu", { time=400, effect="crossFade" } )
end

local function onCollision( event )

  if ( event.phase == "began" ) then
    local obj1 = event.object1
    local obj2 = event.object2

    if ( ( obj1.myName == "laser" and obj2.myName == "bar" ) or
      ( obj1.myName == "bar" and obj2.myName == "laser" ) ) and barPosition == "UP"
      then
        -- Remove both laser and asteroid
      if obj1.myName == "laser" then display.remove( obj1 )
			elseif obj2.myName == "laser" then display.remove( obj2 )
			end

      -- Increase score
      score = score + 1
      scoreBoxText.text = "Score: " .. score

      -- Update lives
      lives = lives - 1
			print ( lives )
      if ( lives == 0 ) then
				timer.cancel( laserLoopTimer )
				timer.performWithDelay( 500, gotoMenu )
      end
    end
  end
end

local sheetBoxOptions = {
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

local objectBoxSheet = graphics.newImageSheet( "imageObject.png", sheetBoxOptions )

local function whichBoxIsTapped( event )
	whichBoxText.text = event.target.myName
end

local boxTable = {}

local function populateBox()
	local n = 40
	local xPos = 40
	local yPos = 160
	for i=1,10 do
		local newBox = display.newImageRect( mainGroup, objectBoxSheet, 2, 60, 70 )
		newBox:scale( 0.5, 0.5 )
		if i==6 then
			xPos = 40
			yPos = 200
		end
		xPos = xPos + n
		newBox.x = display.contentWidth - xPos
		newBox.y = display.contentHeight - yPos
		if i==8 then
			newBox.myName = "anwserBox"
		else
			newBox.myName = "box"
		end
		newBox:addEventListener( "tap", playBarSprite )
		newBox:addEventListener( "tap", whichBoxIsTapped )
		table.insert( boxTable, newBox )
	end

end

local function removeBox()
	for i=#boxTable,1,-1 do
		display.remove( boxTable[i] )
		table.remove( boxTable, i )
	end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	backGroup = display.newGroup()
	sceneGroup:insert( backGroup )

	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	background = display.newImageRect( backGroup, "background.png", 320, 480)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	scoreBoxText = display.newText( uiGroup, "Score: " .. tostring(score), 90, 30, native.systemFont, 25 )
	whichBoxText = display.newText( uiGroup, "Box No: -", 220, 30, native.systemFont, 25 )

	sheet_bar = graphics.newImageSheet( "bar.png", sheetOptions )

	barSprite = display.newSprite( sheet_bar, sequences_Bar )
	barSprite.myName = "bar"

	barSprite.x = display.contentCenterX - 100
	barSprite.y = display.contentCenterY

	physics.addBody( barSprite, "static", { friction=0.5, bounce=0.3 } )
	-- barSprite:addEventListener( "sprite", spriteListener )
	barSprite:addEventListener( "tap", playBarSprite )

	local menuButton = display.newText( uiGroup, "Menu", display.contentCenterX, 450, native.systemFont, 25 )
	menuButton:setFillColor( 0.82, 0.86, 1 )

	menuButton:addEventListener( "tap", gotoMenu )

	bullet = display.newImageRect( mainGroup, "bullet.png", 50, 10 )
	bullet:scale( 0.5, 0.5 )
	bullet.x = display.contentCenterX + 100
	bullet.y = display.contentCenterY
	bullet:addEventListener( "tap", fireLaser )

	populateBox()

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		-- barSprite:play()
		physics.start()
		laserLoopTimer = timer.performWithDelay( math.random(100, 400), fireLaser, 0 )
		Runtime:addEventListener( "collision", onCollision )
		transition.resume()
	end

end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		barSprite:pause()
		display.remove( barSprite )
		display.remove( bullet )
		--timer.cancel( laserLoopTimer )
		removeNewLaser()
		removeBox()

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
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
