local PhysicsScene = import(".PhysicsScene")
local MainScene = class("MainScene", PhysicsScene)

function MainScene:ctor()
    MainScene.super.ctor(self, GRAVITY)

    self:enableWorldBounds(true)


    ui.newTTFLabel({text = "Hello, World", size = 64, align = ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.cy)
        :addTo(self)

    -- self.model = cc.mvc.ModelBase.new({
    --         id = "player",
    --         nickname = "dualface",
    --         level = 1,
    --     })
    

    -- self.model:addComponent("engineAdapter.AnimationComponent");
    -- self.animation = self.model:getComponent("engineAdapter.AnimationComponent");
    -- dump(self.animation);

    local Actor = import("app.entity.Actor")
    self.actor = Actor.new({
        id = "player",
        nickname = "kele",
        ani = "h2",
        phy = {mass = 100, friction = 0, elasticity = 0}
        })
    self.actor:pos(display.cx, display.cy):addTo(self)
    self.actor.ani__:play("1")
    -- dump(self.actor)
end

function MainScene:onEnter()
    self.super:onEnter()
end

function MainScene:onExit()
    self.super:onExit()
end

return MainScene
