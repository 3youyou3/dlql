local Component = import("framework.cc.components.Component")
local ControlComponent = class("ControlComponent", Component)

-- 定义控制事件
Control = {}
Control.Idle        = "Idle"
Control.MovingRight = "MovingRight"
Control.MovingLeft  = "MovingLeft"
Control.Jump        = "Jump"
Control.JumpSecond  = "JumpSecond"
Control.Squat       = "Squat"
Control.Dead        = "Dead"
Control.Relive      = "Relive"

Control.KeyDown = "keydown"
Control.KeyUp   = "keyup"

-- 定义键盘消息
Keyboard = {}
Keyboard.Right = 124
Keyboard.Left  = 123
Keyboard.Up    = 126
Keyboard.Down  = 125
Keyboard.Space = 49

function ControlComponent:ctor()
    ControlComponent.super.ctor(self, "ControlComponent", {g_Components["fsm"]})
end


-- 初始化

function ControlComponent:onBind_(target)
	
	-- 初始化键盘事件
	self.keyboardControlTag_ = g_ControlLayer:newEventTag();
	g_ControlLayer:addKeyboardListener(true, self.keyboardControlTag_, function(event)
		self:onKeyboard(event)
	end)

	-- 初始化状态机
	if target.fsm__ == nil then
		target.fsm__ = target:getComponent(g_Components["fsm"])
	end

	-- 设定状态机的默认事件
    local defaultEvents = {
        -- 初始化后，角色处于 idle 状态
        {name = "start", from = "none", to = "idle" },
        {name = "do_idle", from = "*", to = "idle"},
        -- 开火
        {name = "do_right", from = "*", to = "right"},
        -- 开火冷却结束
        {name = "do_left", from = "*", to = "left"},
        -- 角色被冰冻
        {name = "do_jump", from = "*", to = "jump"},
        -- 从冰冻状态恢复
        {name = "do_squat", form = "*", to = "squat"},
        -- 角色在正常状态和冰冻状态下都可能被杀死
        {name = "kill",   from = "*", to = "dead"},
        -- 复活
        {name = "relive", from = "dead",    to = "idle"},
    }

    if target.fsm_ ~= nil then
	    -- 如果参数提供了其他事件，则合并
	    table.insertto(defaultEvents, checktable(target.fsm_.events))
	end

	-- 设定状态机的默认回调
    local defaultCallbacks = {
        onchangestate = handler(self, self.onChangeState_),
        onstart       = handler(self, self.onStart_),
        onidle        = handler(self, self.onIdle_),
        onright       = handler(self, self.onRight_),
        onleft        = handler(self, self.onLeft_),
        onjump        = handler(self, self.onJump_),
        onsquat       = handler(self, self.onSquat_),
        ondead        = handler(self, self.onDead_),
        onrelive      = handler(self, self.onRelive_),
    }

    if target.fsm_ ~= nil then
	    -- 如果参数提供了其他回调，则合并
    	table.merge(defaultCallbacks, checktable(target.fsm_.events))
    end

    target.fsm__:setupState({
        events = defaultEvents,
        callbacks = defaultCallbacks
    })

    target.fsm__:doEvent("start") -- 启动状态机

    g_physicsWorld:addCollisionScriptListener(handler(self, self.onTouchGround), kTagGroundCollisionType, kTagActorCollisionType)

end

function ControlComponent:onUnbind_(target)
	g_ControlLayer:addKeyboardListener(false, self.keyboardControlTag_)
end

-- 控制

function ControlComponent:doEvent(name, ...)
	if self.target_.fsm__ ~= nil then
		self.target_.fsm__:doEvent(name, arg)
	end
end

function ControlComponent:onKeyboard(event)
	-- dump(event)

	-- print(self.target_:getVelocity().x.."  "..self.target_:getVelocity().y)

	if event.type == Control.KeyDown then
		if event.key == Keyboard.Right then
			self:doEvent("do_right", arg)
			self.keyRight = true
		elseif event.key == Keyboard.Left then
			self:doEvent("do_left", arg)
			self.keyLeft = true
		elseif event.key == Keyboard.Up  then
			if self.touchGround and not self.keyUp then
				self:doEvent("do_jump", arg)
				self.keyUp = true
				self.touchGround = false;
			end
		elseif event.key == Keyboard.Down then
			self:doEvent("do_squat", arg)
			self.keyDown = true
		end 
	elseif event.type == Control.KeyUp then
		if event.key == Keyboard.Right then
			self.keyRight = false;
		elseif event.key == Keyboard.Left then
			self.keyLeft = false;
		elseif event.key == Keyboard.Up then
			self.keyUp = false;
		elseif event.key == Keyboard.Down then
			self.keyDown = false;
		end 

		if self.keyRight or self.keyLeft or self.keyUp or self.keyDown then
		else
			if self.touchGround then
				self:doEvent("do_idle", arg)
			end
		end
	end
end


function ControlComponent:onTouchGround(name, event)
	if name == "begin" then
		if self.keyRight or self.keyLeft or self.keyUp or self.keyDown then
		else
			self:doEvent("do_idle", arg)
		end

		self.touchGround = true;
		-- print("begin")
	elseif name == "separate" then
		self.touchGround = false;
		-- print("separate")
	end

	return true
end


-- 事件回调并派发出去
function ControlComponent:dispatchEvent(evntName)
	self.target_:dispatchEvent({name = evntName})
end

function ControlComponent:onChangeState_()
end

function ControlComponent:onStart_()

end

function ControlComponent:onIdle_()
	self:dispatchEvent(Control.Idle)
end

function ControlComponent:onRight_()
	self:dispatchEvent(Control.MovingRight)
end

function ControlComponent:onLeft_()
	self:dispatchEvent(Control.MovingLeft)
end

function ControlComponent:onJump_()
	self:dispatchEvent(Control.Jump)
end

function ControlComponent:onSquat_()
	self:dispatchEvent(Control.Squat)
end

function ControlComponent:onDead_()
	self:dispatchEvent(Control.Dead)
end

function ControlComponent:onRelive_()
	self:dispatchEvent(Control.Relive)
end


return ControlComponent