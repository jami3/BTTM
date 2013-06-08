local storyboard = require("storyboard")
local scene = storyboard.newScene()
local widget = require"widget"
local scrollSpeed = 32
local snap = true -- SNAP TO GRID ON/OFF
local loaded, canPlaceItems = false, false

local level1Items = {
	crow = { name = "crow", leftImage = "img/CROW.png", rightImage = "img/CROW_FACE_LEFT.png" },
	fan = { name = "fan", leftImage = "img/FAN_V1_LEFT.png", rightImage = "img/FAN_V1.png" },
	pigeon = { name = "pigeon", leftImage = "img/PIGEON_64X64.png", rightImage = "img/PIGEON_64X64_RIGHT.png" },
	coin = { name = "coin", leftImage = "img/COIN_32x32_V1.png", rightImage = "img/COIN_32x32_V1.png" }
}

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth * 0.5
local data, selectedItem, items, menuItems = {}, {}, {}, {}
local level1Btn, level2Btn, upBtn, dwnBtn, currentItem, itemBg -- BUTTONS
local numItems, screenY = 0, 0
local view, changeItem, hideItemMenu -- FORWARD REFS


-- REMOVE THE LEVEL BUTTONS
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


local function isTileFree(x, y)
	for i = 0, numItems do
		if (items[i]) then
			if (items[i].x == x) and (items[i].y == y) then
				print("Tile already has something on it")
				return false, items[i]
			end
		end
	end

	return true, nil
end

local function placeItem(event)

	if (canPlaceItems) and (selectedItem) and (event.phase == "ended") then
		local x, y
		if (snap) then
			x, y = snapToTile(event.x, event.y)
		else
			x, y = event.x, event.y
		end

		y = y - screenY

		if (isTileFree(x, y)) then

			if (x > halfW) then
				items[numItems] = display.newImage(selectedItem.rightImage)
			else
				items[numItems] = display.newImage(selectedItem.leftImage)
			end

			items[numItems].x, items[numItems].y = x, y
			items[numItems].name = selectedItem.name

			view:insert(items[numItems])

			numItems = numItems + 1
			print("numitems = ", numItems)
		end
	end
end

local newItem = function(self)
	if (self.phase == "began") then
		canPlaceItems = false
	end
	changeItem(self.target)
	if (self.phase == "ended") then
		canPlaceItems = true
	end
end

local displayItemMenu = function(item)
	canPlaceItems = false
	local num = 5

	for i, item in pairs(level1Items) do
		print(level1Items[i].leftImage)
		menuItems[i] = display.newImageRect(level1Items[i].leftImage, 32, 32)
		menuItems[i].name = level1Items[i].name
		menuItems[i].leftImage, menuItems[i].rightImage = level1Items[i].leftImage, level1Items[i].rightImage
		menuItems[i].x, menuItems[i].y = 16, 105 + num
		num = num + 32

		menuItems[i]:addEventListener("touch", newItem)
	end


	print("DISPLAY ITEMS")
end

hideItemMenu = function(item)


	for i, item in pairs(menuItems) do
		menuItems[i]:removeSelf()
		menuItems[i] = nil
	end
end

-- CHANGE THE SELECTED ITEM
changeItem = function(item)
	print("item changed", item.name)
	selectedItem = item

	if (currentItem) then
		currentItem:removeSelf()
		currentItem = nil
		itemBg:removeSelf()
		itemBg = nil
	end

	-- THE ICON SHOWING THE CURRENTLY SELECTED ITEM IMAGE, THIS DOUBLES UP AS A DISPLAY MENU BUTTON
	itemBg = display.newImageRect("img/gui/iconBg.png", 32, 32) -- THE BACKGROUND
	itemBg.x = 300
	itemBg.y = -16
	itemBg:addEventListener("touch", displayItemMenu)

	currentItem = display.newImageRect(selectedItem.leftImage, 32, 32) -- THE SELECTED IMAGE
	currentItem.x = 300
	currentItem.y = -16
	currentItem:addEventListener("touch", displayItemMenu)
	hideItemMenu()
end



local function moveCamera(dir)
	if (dir == "up") then
		view.y = view.y + scrollSpeed
		screenY = screenY + scrollSpeed
	elseif (dir == "down") then
		view.y = view.y - scrollSpeed
		screenY = screenY - scrollSpeed
	end
end

local loadLevel = function(level)

	removeButtons()
	changeItem(level1Items.crow)

	Runtime:addEventListener("touch", placeItem)
	print(screenH)

	-- DRAW BACKGROUND GRID
	local tile = {}
	local num = 0
	for x = -16, screenW + 16, 32 do
		for y = screenH + 48, -48, -32 do
			tile[x * y] = display.newImage("img/gui/grid_tile.png")
			tile[x * y].x, tile[x * y].y = x, y
			tile[x * y].alpha = 0.1
			print(x, y)
		end
	end

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
	canPlaceItems = true
end

local loadLevel1 = function(event)
	loadLevel()
end

local loadLevel2 = function(event)
	loadLevel()
end

local newButton = function(name, label, y, pressFunc, releaseFunc)
	local btn = widget.newButton{
		id = name,
		defaultFile = "img/gui/buttonBlue.png",
		label = label,
		emboss = true,
		onRelease = releaseFunc
	}
	btn.x, btn.y = 10 + (btn.width / 2), y

	return btn
end

function scene:createScene(event)

	view = self.view
	display.setDefault("background", 120, 185, 237)

	level1Btn = newButton("level1Btn", "LEVEL 1", 0, nil, loadLevel1)
	level2Btn = newButton("level2Btn", "LEVEL 2", level1Btn.height, nil, loadLevel1)
end


function scene:enterScene(event) -- Called immediately after scene has moved onscreen:

	local view = self.view
end

-- Called when scene is about to move off-screen:
function scene:exitScene(event)
	local view = self.view
	removeButtons()
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene(event)
	local view = self.view
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene