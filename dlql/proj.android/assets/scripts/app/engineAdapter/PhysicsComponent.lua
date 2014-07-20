local Component = import("framework.cc.components.Component")
local PhysicsComponent = class("PhysicsComponent", Component)

function PhysicsComponent:ctor()
    PhysicsComponent.super.ctor(self, "PhysicsComponent")
end

function PhysicsComponent:clear()
	if self.body ~= nil then
		g_physicsWorld:removeBody(self.body, true)
	end
end

function PhysicsComponent:size(width, height)
	self:clear()

	local target = self.target_
	local phy = target.phy_

	self.body = g_physicsWorld:createBoxBody(phy.mass, width, height)
    self.body:setFriction(phy.friction)
    self.body:setElasticity(phy.elasticity)
    self.body:bind(target)
end


function PhysicsComponent:pos(x, y)
	self.body:setPosition(x, y)
end

function PhysicsComponent:getPos()
	local pos = {}
	pos.x = self.body:getPositionX()
	pos.y = self.body:getPositionY()

	return pos
end

function PhysicsComponent:rotation(r)
	self.body:setRotation(r)
end

function PhysicsComponent:getRotation()
	return self.body:getRotation()
end

function PhysicsComponent:onBind_(target)
	local s = target:getContentSize()
	self:size(s.width, s.height)
end

function PhysicsComponent:onUnbind_(target)
	self:clear()
end

return PhysicsComponent