local Component = import("framework.cc.components.Component")
local AnimationComponent = class("AnimationComponent", Component)

Animation = {}
Animation.Idle = "idle"
Animation.Walk = "walk"
Animation.Run  = "run"
Animation.Dump = "dump"

function AnimationComponent:ctor()
    AnimationComponent.super.ctor(self, "AnimationComponent")
end

function AnimationComponent:onBind_(target)
	if target.ani_ ~= nil then
		local manager = CCArmatureDataManager:sharedArmatureDataManager()
    	manager:addArmatureFileInfo(target.ani_..".png", target.ani_..".plist", target.ani_..".xml")
		self.inner = CCArmature:create(target.ani_)
		self.inner:setAnchorPoint(0.5,0.5)
		target:addChild(self.inner)
		target:setContentSize(self.inner:getContentSize())

		target:addEventListener(Control.MovingLeft,  handler(self, self.onMoving_))
		target:addEventListener(Control.MovingRight, handler(self, self.onMoving_))
	    target:addEventListener(Control.Idle,        handler(self, self.onIdle_))
	end
end

function AnimationComponent:onUnbind_(target)

end

function AnimationComponent:play(name)
	self.inner:getAnimation():play(name)
end

function AnimationComponent:onMoving_(event)
	self:play(Animation.Walk)
end

function AnimationComponent:onIdle_(event)
	self:play(Animation.Idle)
end

return AnimationComponent