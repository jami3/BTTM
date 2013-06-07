require("balloon")
require("crow")

local storyboard = require("storyboard")
local scene = storyboard.newScene()
local m_balloon, crowA -- GAME ENTITIES

debugDraw = true
require("physics")
physics.start(); physics.pause()

--CLOUD STUFF
local clouds = {}
local total_clouds = 100 -- TOTAL AMOUNT OF CLOUDS
local starting_y = 480 -- BOTTOM POSITION OF SCREEN
local max_clouds_visible = 4 -- CLOUDS VISIBLE PER SCREEN
local screen_height = 400 -- I HAVE MADE THIS LESS THAN SCREEN HEIGHT SO THERE IS A BIT OF OVERLAP. THERE WERE LARGE GAPS VERTICALLY

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth * 0.5

-- Called when the scene's view does not exist:
function scene:createScene(event)
	-- SET THE VIEW
	--physics.setDrawMode( "debug" )
	local group = self.view
	display.setDefault("background", 120, 185, 237)

	-- CREATE CLOUDS
	for i = 1, total_clouds do
		if (i % max_clouds_visible == 0) then -- EVERY MAX CLOUDS MOVE ON A SCREEN OR SO
			starting_y = starting_y - screen_height -- DEDUCT THE SCREEN HEIGHT FROM STARTING POSITION e.g. -DIRECTION IS UP
		end

		clouds[i] = display.newImageRect("img/CLOUD_1_LEFT_93x65.png", 93, 65)
		clouds[i].x = math.random(0, 320) -- SCREEN WIDTH
		clouds[i].y = starting_y - math.random(0, 480) -- SCREEN HEIGHT FROM STARTING POSITION + RANDOM BETWEEN
		clouds[i].speed = math.random(0, 10) / 10
		group:insert(clouds[i])
	end

	local grass = display.newImageRect("img/grass.png", screenW, 82)
	grass:setReferencePoint(display.BottomLeftReferencePoint)
	grass.x, grass.y = 0, display.contentHeight


	local grassShape = { -halfW, -34, halfW, -34, halfW, 34, -halfW, 34 }
	physics.addBody(grass, "static", { friction = 0.3, shape = grassShape })

	--group:insert( background )
	group:insert(grass)

	crowA = crow:new(group, 50, 400)
	m_balloon = balloon:new(group)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
	local group = self.view

	physics.start()
end

function scene:enterFrame(event)
	local group = self.view
end

-- Called when scene is about to move offscreen:
function scene:exitScene(event)
	local group = self.view
	physics.stop()
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene(event)
	local group = self.view

	package.loaded[physics] = nil
	physics = nil
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)


-- Camera
local function moveCamera()
	local group = scene.view
	group.y = -m_balloon.y + 340
end

local function update()
	moveCamera()

	for i = 1, total_clouds do
		clouds[i].x = clouds[i].x + clouds[i].speed
		print()
		if (clouds[i].x > screenW + clouds[i].width) then
			clouds[i].x = -clouds[i].width
		end
	end
end

local function keyInput(key)
	print(key)
end

Runtime:addEventListener("enterFrame", update)
Runtime:addEventListener("key", keyInput)

return scene

