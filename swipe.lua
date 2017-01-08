
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

local object
local LEFT = 50
local CENTER = display.contentCenterX
local RIGHT = display.contentWidth - 50
local isTransitioning = false

local function onTransitionComplete( event )
    isTransitioning = false
end

local function handleSwipe( event )
    if ( event.phase == "moved" ) then
        local dX = event.x - event.xStart
        print( event.x, event.xStart, dX )
        if ( dX > 10 ) then
            --swipe right
            local spot = RIGHT
            if ( event.target.x == LEFT ) then
                spot = CENTER
            end
            if isTransitioning then
                 return true
            end
            isTransitioning = true
            transition.to( event.target, { time=300, x=spot, onComplete=onTransitionComplete } )
        elseif ( dX < -10 ) then
            --swipe left
            local spot = LEFT
            if ( event.target.x == RIGHT ) then
                spot = CENTER
            end
            if isTransitioning then
                 return true
            end
            isTransitioning = true
            transition.to( event.target, { time=300, x=spot, onComplete=onTransitionComplete } )
        end
    end
    return true
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

	object = display.newCircle( display.contentCenterX, display.contentCenterY, 25 )
	object:addEventListener( "touch", handleSwipe )

	otherObject = display.newCircle( display.contentCenterX, 400, 20 )
	otherObject:addEventListener( "touch", handleSwipe )

	-- Menu Button
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
	end

end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		display.remove( object )
		display.remove( otherObject )
		
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
