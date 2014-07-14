
local PhysicsWorld = class("PhysicsWorld", function()
    return display.newScene("PhysicsWorld")
end)

function PhysicsWorld:cotr(gravity)
    self.inner = CCPhysicsWorld:create(0, gravity)
    self:addChild(self.inner)

    dump(self)
end

return PhysicsWorld