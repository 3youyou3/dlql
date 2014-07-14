local Component = import("framework.cc.components.Component")
local ActionComponent = class("ActionComponent", Component)

function ActionComponent:ctor()
    ActionComponent.super.ctor(self, "ActionComponent")
end

function ActionComponent:onBind_(target)
end

function ActionComponent:onUnbind_(target)

end

return ActionComponent