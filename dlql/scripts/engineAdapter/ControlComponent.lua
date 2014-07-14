local Component = import("framework.cc.components.Component")
local ControlComponent = class("ControlComponent", Component)

function ControlComponent:ctor()
    ControlComponent.super.ctor(self, "ControlComponent")
end

function ControlComponent:onBind_(target)
end

function ControlComponent:onUnbind_(target)
	
end

return ControlComponent