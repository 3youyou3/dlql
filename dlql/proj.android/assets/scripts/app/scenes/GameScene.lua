local ControlLayer = import(".ControlLayer")
local PhysicsScene = import(".PhysicsScene")

local GameScene = class("GameScene", PhysicsScene)


function GameScene:ctor()
    GameScene.super.ctor(self, GRAVITY)


end

function GameScene:onEnter()
    self.super:onEnter()

    g_ControlLayer = ControlLayer.new()
    self:addChild(g_ControlLayer)

    self:enableWorldBounds(true)


    ui.newTTFLabel({text = "Hello, World", size = 64, align = ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.cy)
        :addTo(self)


    local Actor = import("app.entity.Actor")
    self.actor = Actor.new({
        id = "player",
        nickname = "kele",
        ani = "h2",
        act = {},
        phy = {mass = 1, friction = 0, elasticity = 0},
        control = {}
        })
    self.actor:pos(display.cx, display.cy):addTo(self)
end

function GameScene:onExit()
    self.super:onExit()

    self:removeChild(g_ControlLayer)
    g_ControlLayer = nil

end

return GameScene
