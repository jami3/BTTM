-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
require( "balloon" )

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local m_balloon

debugDraw = true
require ("physics")
physics.start(); physics.pause()
local game = display.newGroup();

game.x = 0
game.y = 0
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-- Called when the scene's view does not exist:
function scene:createScene( event )
        -- SET THE VIEW
        local group = self.view
        display.setDefault("background",120,185,237)

        --local background = display.newImageRect( "img/SKY.png", display.contentWidth, display.contentHeight )
        --background:setReferencePoint( display.TopLeftReferencePoint )
        --background.x, background.y = 0, 0

        -- CREATE CLOUDS
        local clouds = {}
        local starting_y = 480
        local max_clouds_visible = 4
        local total_clouds = 100

        for i=1,total_clouds do
               if(i%max_clouds_visible==0) then
                   starting_y = starting_y - 400 -- TAKE SCREEN HEIGHT AWAY FROM STARTING POSITION -Y IS UP
               end

            clouds[i] = display.newImageRect( "img/CLOUD_1_LEFT_93x65.png", 93, 65 )
            clouds[i].x = math.random(0 ,   320)       -- SCREEN WIDTH
            clouds[i].y = starting_y  - math.random(0,  480)     -- SCREEN HEIGHT FROM STARTING POSITION
            group:insert(  clouds[i])
        end
        -- create a grass object and add physics (with custom shape)
        local grass = display.newImageRect( "img/grass.png", screenW, 82 )
        grass:setReferencePoint( display.BottomLeftReferencePoint )
        grass.x, grass.y = 0, display.contentHeight

        -- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
        local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
        physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )

        --group:insert( background )
        group:insert( grass)

        m_balloon =  balloon:new (group)

    end

    -- Called immediately after scene has moved onscreen:
    function scene:enterScene( event )
        local group = self.view

        physics.start()

    end

    function scene:enterFrame( event )
        local group = self.view

    end

    -- Called when scene is about to move offscreen:
    function scene:exitScene( event )
        local group = self.view
        --physics.stop()
    end

    -- If scene's view is removed, scene:destroyScene() will be called just prior to:
    function scene:destroyScene( event )
        local group = self.view

        package.loaded[physics] = nil
        physics = nil
    end

    scene:addEventListener( "createScene", scene )
    scene:addEventListener( "enterScene", scene )
    scene:addEventListener( "exitScene", scene )
    scene:addEventListener( "destroyScene", scene )


    -- Camera
    local function moveCamera()
        local group =  scene.view
        group.y  = -m_balloon.y+340
    end

    local function update()
        moveCamera()
    end

    local function keyInput(key)
        print(key)
    end

    Runtime:addEventListener( "enterFrame", update )
    Runtime:addEventListener( "key", keyInput )
return scene

