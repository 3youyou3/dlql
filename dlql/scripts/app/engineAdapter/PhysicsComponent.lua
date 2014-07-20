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
    self.body:setInertia(INFINITY)
    self.body:setCollisionType(phy.collisionType)

    self.body:bind(target)

end


function PhysicsComponent:setPos(x, y)
	self.body:setPosition(x, y)
	return self.target_
end

function PhysicsComponent:getPos()
	local pos = {}
	pos.x = self.body:getPositionX()
	pos.y = self.body:getPositionY()

	return pos
end

function PhysicsComponent:setRotation(r)
	self.body:setRotation(r)
	return self.target_
end

function PhysicsComponent:getRotation()
	return self.body:getRotation()
end

function PhysicsComponent:setVelocityX(x)
	self:setVelocity(x, nil)
end

function PhysicsComponent:setVelocityY(y)
	self:setVelocity(nil, y)
end

function PhysicsComponent:setVelocity(x, y)
	local velocity = self:getVelocity()

	if x ~= nil then
		velocity.x = x
	end

	if y ~= nil then
		velocity.y = y
	end

	self.target_.phy__.body:setVelocity(velocity.x, velocity.y)
end

function PhysicsComponent:getVelocity()
	return self.body:getVelocity()
end

function PhysicsComponent:onBind_(target)
	local s = target:getContentSize()
	self:size(s.width, s.height)

	self:exportMethods_({"setPos", "getPos", "setRotation", "getRotation", "setVelocityX", "setVelocityY", "setVelocity", "getVelocity"})
end

function PhysicsComponent:onUnbind_(target)
	self:clear()
end

return PhysicsComponent