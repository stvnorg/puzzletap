
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local combination = {
	{7, 5, 9, 6, 4, 1, 10},
	{9, 5, 8, 1, 3, 6, 10},
	{3, 1, 2, 8, 6, 10, 9},
	{9, 3, 10, 7, 1, 6, 2},
	{2, 9, 7, 3, 4, 10, 6},
	{2, 10, 1, 9, 6, 4, 5},
	{7, 5, 3, 8, 6, 4, 10},
	{2, 3, 7, 4, 1, 10, 8},
	{7, 8, 6, 1, 3, 10, 2},
	{10, 3, 8, 5, 4, 9, 1},
}

local pattern

local objSheet = composer.getVariable( "objSheet" )

local gameLoopTimer

local backGroup
local mainGroup
local uiGroup

local box1
local box2
local box3
local box4
local box5
local box6
local box7
local box8
local box9
local box10

local num1
local num2
local num3
local num4
local num5
local num6
local num7
local num8
local num9
local num10

local position = {}

local splashImage

local function gotoGame()

	composer.removeScene( "game" )
	composer.gotoScene( "game", { time=800, effect="crossFade" } )

end

local cunt = 1

local function splashLoop()

	if cunt > 7 then cunt = 1 end
	splashImage.x = position[pattern[cunt]][1]
	splashImage.y = position[pattern[cunt]][2] - 3
	cunt = cunt + 1

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	pattern = combination[ math.random(1, 10) ]

	backGroup = display.newGroup()
	sceneGroup:insert( backGroup )
	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )
	uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	position = {}

	box1 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box1:scale( 0.5, 0.5 )
	box1.x = 60
	box1.y = 300
	box1.myName = "1"
	num1 = display.newText( mainGroup, "1", 60, 320, native.systemFont, 15 )
	table.insert( position, { box1.x, box1.y } )

	box2 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box2:scale( 0.5, 0.5 )
	box2.x = 110
	box2.y = 300
	box2.myName = "2"
	num2 = display.newText( mainGroup, "2", 110, 320, native.systemFont, 15 )
	table.insert( position, { box2.x, box2.y } )

	box3 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box3:scale( 0.5, 0.5 )
	box3.x = 160
	box3.y = 300
	box3.myName = "3"
	num3 = display.newText( mainGroup, "3", 160, 320, native.systemFont, 15 )
	table.insert( position, { box3.x, box3.y } )

	box4 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box4:scale( 0.5, 0.5 )
	box4.x = 210
	box4.y = 300
	box4.myName = "4"
	num4 = display.newText( mainGroup, "4", 210, 320, native.systemFont, 15 )
	table.insert( position, { box4.x, box4.y } )

	box5 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box5:scale( 0.5, 0.5 )
	box5.x = 260
	box5.y = 300
	box5.myName = "5"
	num5 = display.newText( mainGroup, "5", 260, 320, native.systemFont, 15 )
	table.insert( position, { box5.x, box5.y } )

	box6 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box6:scale( 0.5, 0.5 )
	box6.x = 60
	box6.y = 250
	box6.myName = "6"
	num6 = display.newText( mainGroup, "6", 60, 270, native.systemFont, 15 )
	table.insert( position, { box6.x, box6.y } )

	box7 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box7:scale( 0.5, 0.5 )
	box7.x = 110
	box7.y = 250
	box7.myName = "7"
	num7 = display.newText( mainGroup, "7", 110, 270, native.systemFont, 15 )
	table.insert( position, { box7.x, box7.y } )

	box8 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box8:scale( 0.5, 0.5 )
	box8.x = 160
	box8.y = 250
	box8.myName = "8"
	num8 = display.newText( mainGroup, "8", 160, 270, native.systemFont, 15 )
	table.insert( position, { box8.x, box8.y } )

	box9 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box9:scale( 0.5, 0.5 )
	box9.x = 210
	box9.y = 250
	box9.myName = "9"
	num9 = display.newText( mainGroup, "9", 210, 270, native.systemFont, 15 )
	table.insert( position, { box9.x, box9.y } )

	box10 = display.newImageRect( mainGroup, objSheet, 1, 60, 70 )
	box10:scale( 0.5, 0.5 )
	box10.x = 260
	box10.y = 250
	box10.myName = "10"
	num10 = display.newText( mainGroup, "10", 260, 270, native.systemFont, 15 )
	table.insert( position, { box10.x, box10.y } )

	splashImage = display.newImageRect( mainGroup, "splash1.png", 19, 17 )
	-- splashImage.x = box8.x
	-- splashImage.y = box8.y - 3

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		gameLoopTimer = timer.performWithDelay( 1000, splashLoop, 2*7 )
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
