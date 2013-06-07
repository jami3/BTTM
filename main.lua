require("globals")

gameStarted = false;
-- hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- include the Corona "storyboard" module
local storyboard = require"storyboard"
-- load menu screen
storyboard.gotoScene("menu")

local function Update()
	if (gameStarted) then
		storyboard.Update()
	end
end

Runtime:addEventListener("Update", Update)