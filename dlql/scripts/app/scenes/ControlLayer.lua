
local ControlLayer = class("ControlLayer", function()
    return display.newLayer()
end)

function ControlLayer:ctor()

    -- mac和windows平台下开启键盘事件消息
    if device.platform == "mac" or device.platform == "windows" then
        self:setKeyboardEnabled(true)
    end
    
    self.EventTag_ = 0;
end

function ControlLayer:addKeyboardListener(enable, tag, listener)
	if enable then
		self:addNodeEventListener(7, function(event)
	    	listener(event)
	    end, tag)
	else
	    self:removeNodeEventListenersByTag(tag)
	end
end

function ControlLayer:newEventTag()
	return self.EventTag_ + 1;
end

return ControlLayer