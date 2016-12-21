-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Go to menu screen
composer.gotoScene( "menu" )

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

-- Set Global variable to be used on other scene
composer.setVariable( "objSheet", objectSheet )
