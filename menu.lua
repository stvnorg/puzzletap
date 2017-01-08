
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()

	composer.removeScene( "game" )
	composer.gotoScene( "game", { time=800, effect="crossFade" } )

end

local function gotoHighScores()

	composer.removeScene( "highscores" )
	composer.gotoScene( "highscores",  { time=800, effect="crossFade" } )

end

local function gotoSprite()

	composer.removeScene( "sprite" )
	composer.gotoScene( "sprite", { time=800, effect="crossFade" } )

end

local function gotoLevel1()

	composer.removeScene( "level1" )
	composer.gotoScene( "level1", { time=800, effect="crossFade" } )

end

local function gotoSwipe()

	composer.removeScene( "swipe" )
	composer.gotoScene( "swipe", { time=800, effect="crossFade" } )

end

local function gotoSpriteBar()

	composer.removeScene( "sprite_bar" )
	composer.gotoScene( "sprite_bar", { time=800, effect="crossFade" } )

end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "title.png", 241, 54)
	title.x = display.contentCenterX
	title.y = 40

	-- Play Button
	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 350, native.systemFont, 20 )
	playButton:setFillColor( 0.83, 0.86, 1 )
	playButton:addEventListener( "tap", gotoGame )

	-- Highscores Button
	local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 380, native.systemFont, 20 )
	highScoresButton:setFillColor( 0.75, 0.78, 1 )
	highScoresButton:addEventListener( "tap", gotoHighScores )

	-- Sprite Button
	local spriteButton = display.newText( sceneGroup, "Sprite Image", display.contentCenterX, 410, native.systemFont, 20 )
	spriteButton:setFillColor( 0.75, 0.78, 1 )
	spriteButton:addEventListener( "tap", gotoSprite )

	-- Level 1 Button
	local level1Button = display.newText( sceneGroup, "Level 1", display.contentCenterX, 440, native.systemFont, 20 )
	level1Button:setFillColor( 0.75, 0.78, 1 )
	level1Button:addEventListener( "tap", gotoLevel1 )

	-- Swipe Button
	local swipeButton = display.newText( sceneGroup, "Swipe", display.contentCenterX, 470, native.systemFont, 20 )
	swipeButton:setFillColor( 0.75, 0.75, 1 )
	swipeButton:addEventListener( "tap", gotoSwipe )

	-- Sprite Bar Button
	local spriteBarButton = display.newText( sceneGroup, "Sprite Bar", display.contentCenterX, 500, native.systemFont, 20 )
	spriteBarButton:setFillColor( 0.75, 0.75, 1 )
	spriteBarButton:addEventListener( "tap", gotoSpriteBar )

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
