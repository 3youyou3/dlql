local Component = import("framework.cc.components.Component")
local AnimationComponent = class("AnimationComponent", Component)

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
	end
end

function AnimationComponent:onUnbind_(target)

end

function AnimationComponent:play(name)
	self.inner:getAnimation():play(name)
end

return AnimationComponent