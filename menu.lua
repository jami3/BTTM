local storyboard = require("storyboard")
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require"widget"

--------------------------------------------
-- forward declarations and other locals
local function startGame(event)

	if (not gameStarted) then
		gameStarted = true;
		storyboard.gotoScene("level1", "fade", 500)
	end
end



local function startLevelEditor(event)

	if (not gameStarted) then
		gameStarted = true;
		storyboard.gotoScene("levelEditor", "fade", 500)

	end
end

local startBtnRelease = function(event)
	startGame()
end

local editorButtonRelease = function(event)
	startLevelEditor()
end

local startButton, editorButton
-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:

function scene:createScene(event)

	local group = self.view
	local background = display.newImageRect("img/HOME_PAGE_BALLOON_V3.png", display.contentWidth, display.contentHeight)
	background:setReferencePoint(display.TopLeftReferencePoint)
	background.x, background.y = 0, 0
	background:addEventListener("touch", startGame)
	group:insert(background)

	startButton = widget.newButton{
		id = "startButton",
		defaultFile = "img/gui/buttonBlue.png",
		label = "START GAME",
		emboss = true,
		onRelease = startBtnRelease,
	}

	editorButton = widget.newButton{
		id = "editorButton",
		defaultFile = "img/gui/buttonBlue.png",
		label = "LEVEL EDITOR",
		emboss = true,
		onRelease = editorButtonRelease
	}

	startButton.x = 10 + (startButton.width / 2)
	startButton.y = 200
	editorButton.x = 10 + (editorButton.width / 2)
	editorButton.y = 260
end

function scene:enterScene(event) -- Called immediately after scene has moved onscreen:

	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
end

-- Called when scene is about to move offscreen:
function scene:exitScene(event)

	local group = self.view

	if editorButton then
		editorButton:removeSelf() -- widgets must be manually removed
		editorButton = nil
	end

	if startButton then
		startButton:removeSelf() -- widgets must be manually removed
		startButton = nil
	end
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene(event)
	local group = self.view
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)


-----------------------------------------------------------------------------------------

return scene