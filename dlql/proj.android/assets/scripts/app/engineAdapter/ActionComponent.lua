local Component = import("framework.cc.components.Component")
local ActionComponent = class("ActionComponent", Component)


function ActionComponent:ctor()
    ActionComponent.super.ctor(self, "ActionComponent")
end

function ActionComponent:onBind_(target)
	target:addEventListener(Control.MovingLeft,  handler(self, self.MoveLeft))
	target:addEventListener(Control.MovingRight, handler(self, self.MoveRight))
	target:addEventListener(Control.Jump,        handler(self, self.Jump))
	target:addEventListener(Control.Idle,        handler(self, self.Idle))

	target:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.tick))
    target:scheduleUpdate_()

    self.velocity = 0
end

function ActionComponent:onUnbind_(target)
end

function ActionComponent:tick(dt)

	-- if self.velocity ~= 0  then
	-- 	local p = self.target_:getPos()
	-- 	p.x = p.x + self.velocity

	-- 	self.target_:pos(p.x, p.y)
	-- end

end

function ActionComponent:MoveLeft()
	self.velocity = -self.target_.velocity_
	self.target_:setScaleX(-1)

	self.target_.phy__.body:setVelocity(-200, 0)
end

function ActionComponent:MoveRight()
	self.velocity = self.target_.velocity_
	self.target_:setScaleX(1)

	self.target_.phy__.body:setVelocity(200, 0)

end

function ActionComponent:Jump()
	self.target_.phy__.body:setVelocity(0, 200)
end

function ActionComponent:Idle()
	self.velocity = 0

	self.target_.phy__.body:setVelocity(0, 0)

end

return ActionComponent