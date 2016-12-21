
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoMenu()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local backGroup
local mainGroup
local uiGroup

local background

local sheetOptions = {
	width = 320,
	height = 160,
	numFrames = 8
}

local sheet_runningCat
local runningCat

-- Sequences table
local sequences_runningCat = {
	-- Consecutive frames sequences
	{
		name = "normalRun",
		start = 1,
		count = 8,
		time = 800,
		loopCount = 5,
		loopDirection = "forward"
	},
	-- Non-consecutive frames sequences
	{
		name = "fastRun",
		frames = { 1, 3, 5, 7 },
		time = 400,
		loopCount = 0,
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

	background = display.newImageRect( sceneGroup, "background.png", 320, 480)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	sheet_runningCat = graphics.newImageSheet( "sprites-cat-running_small.png", sheetOptions )

	runningCat = display.newSprite( sheet_runningCat, sequences_runningCat )

	runningCat.x = display.contentCenterX
	runningCat.y = display.contentCenterY
	runningCat:addEventListener( "sprite", spriteListener )

	local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 450, native.systemFont, 25 )
	menuButton:setFillColor( 0.82, 0.86, 1 )

	menuButton:addEventListener( "tap", gotoMenu )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		runningCat:play()
	end

end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		runningCat:pause()
		display.remove( runningCat )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
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
