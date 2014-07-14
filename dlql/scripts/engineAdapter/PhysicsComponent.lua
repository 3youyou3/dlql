local Component = import("framework.cc.components.Component")
local PhysicsComponent = class("PhysicsComponent", Component)

function PhysicsComponent:ctor()
    PhysicsComponent.super.ctor(self, "PhysicsComponent")
end

function PhysicsComponent:clear()
	if self.body ~= nil then
	    self.target_:setPhysicsBody(nil)
	end
end

function PhysicsComponent:size(width, height)
	self:clear()

	local target = self.target_
	local phy = target.phy_

    self.body = cc.PhysicsBody:createBox(cc.p(width, height))
	self.body:setMass(phy.mass)

	local shape = self.body:getFirstShape()
    shape:setFriction(phy.friction)
    shape:setRestitution(phy.elasticity)

    target:setPhysicsBody(self.body)
end


-- function PhysicsComponent:pos(x, y)
-- 	self.body:setPosition(x, y)
-- end

-- function PhysicsComponent:rotation(r)
-- 	self.body:setRotation(r)
-- end

function PhysicsComponent:onBind_(target)
	self:size(100, 100)
end

function PhysicsComponent:onUnbind_(target)
	self:clear()
end

return PhysicsComponent