local storyboard = require("storyboard")
local scene = storyboard.newScene()

local widget = require"widget"
local scrollSpeed = 32
local SNAP = true
local loaded = false
-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth * 0.5
local data = {}
local items = {}
local selectedItem = {}
local level1Btn, level2Btn, upBtn, dwnBtn, currentItem, itemBg
local numItems = 0
local group
local screenY = 0

local function removeButtons()
	if level1Btn then
		level1Btn:removeSelf()
		level1Btn = nil
	end

	if level2Btn then
		level2Btn:removeSelf()
		level2Btn = nil
	end
end

local function snapToTile(x, y)
	x = x - (x % 32)
	y = y - (y % 32)

	return x, y
end


local displayItemMenu = function(item)

end


local function placeItem(event)
	if (selectedItem)and  (event.phase == "ended") then
		local x, y
		if (SNAP) then
			x, y = snapToTile(event.x, event.y)
		else
			x, y = event.x, event.y
		end
		y = y - screenY

		if (x > halfW) then
			items[numItems] = display.newImage(selectedItem.right)
		else
			items[numItems] = display.newImage(selectedItem.left)
		end

		items[numItems].x, items[numItems].y = x, y
		items[numItems].name = selectedItem.name

		group:insert(items[numItems])

		numItems = numItems + 1
	end
end

local changeItem = function(item)

	if (item == "crow") then
		selectedItem = { name = "crow", left = "img/CROW.png", right = "img/CROW_FACE_LEFT.png" }
	elseif (item == "fan") then
		selectedItem = { name = "fan", left = "img/FAN_V1_LEFT", right = "img/FAN_V1.png" }
	elseif (item == "pigeon") then
		selectedItem = { name = "pigeon", left = "img/PIGEON_64X64.png", right = "img/PIGEON_64X64_RIGHT.png" }
	elseif (item == "coin") then
		selectedItem = { name = "coin", left = "img/COIN_32x32_V1.png", right = "img/COIN_32x32_V1.png" }
	end

	if (currentItem) then
		currentItem:removeSelf()
		currentItem = nil
		itemBg:removeSelf()
		itemBg = nil
	end

	itemBg = display.newImageRect("img/gui/iconBg.png", 32, 32)
	itemBg.x = 300
	itemBg.y = -16
	currentItem = display.newImageRect(selectedItem.left, 32, 32)
	currentItem.x = 300
	currentItem.y = -16
	currentItem:addEventListener("touch", displayItemMenu)
end

local function moveCamera(dir)
	if (dir == "up") then
		group.y = group.y + scrollSpeed
		screenY = screenY + scrollSpeed
	elseif (dir == "down") then
		group.y = group.y - scrollSpeed
		screenY = screenY - scrollSpeed
	end
end


local loadLevel = function(level)

	removeButtons()
	changeItem("crow")


	Runtime:addEventListener("touch", placeItem)

	local function scrollUp()
		moveCamera("up")
	end

	local function scrollDown()
		moveCamera("down")
	end

	upBtn = widget.newButton{
		id = "upBtn",
		defaultFile = "img/gui/uparrow.png",
		emboss = true,
		onRelease = scrollUp
	}

	downBtn = widget.newButton{
		id = "downBtn",
		defaultFile = "img/gui/downarrow.png",
		emboss = true,
		onRelease = scrollDown
	}

	upBtn.x, upBtn.y = (upBtn.width / 2) + 5, -upBtn.height / 2
	downBtn.x, downBtn.y = (upBtn.width / 2) + 5, (-upBtn.height / 2) + upBtn.height + 5
end

local loadLevel1 = function(event)
	loadLevel()
end

local loadLevel2 = function(event)
	loadLevel()
end



function scene:createScene(event)

	group = self.view
	display.setDefault("background", 120, 185, 237)

	level1Btn = widget.newButton{
		id = "level1Btn",
		defaultFile = "img/gui/buttonBlue.png",
		label = "LEVEL 1",
		emboss = true,
		onRelease = loadLevel1,
	}

	level2Btn = widget.newButton{
		id = "level2Btn",
		defaultFile = "img/gui/buttonBlue.png",
		label = "LEVEL 2",
		emboss = true,
		onRelease = loadLevel2
	}

	level1Btn.x = 10 + (level1Btn.width / 2)
	level1Btn.y = 0
	level2Btn.x = 10 + (level1Btn.width / 2)
	level2Btn.y = level1Btn.height * 1
end


function scene:enterScene(event) -- Called immediately after scene has moved onscreen:

	local group = self.view
end

-- Called when scene is about to move off-screen:
function scene:exitScene(event)
	local group = self.view
	removeButtons()
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene(event)
	local group = self.view
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene