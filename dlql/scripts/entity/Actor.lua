
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

--[[--

“角色”类

level 是角色的等级，角色的攻击力、防御力、初始 Hp 都和 level 相关

]]

local ModelBase = import(".ModelBase")
local Actor = class("Actor", ModelBase)


-- 定义事件
Actor.CHANGE_STATE_EVENT  = "CHANGE_STATE_EVENT"
Actor.START_EVENT         = "START_EVENT"
Actor.READY_EVENT         = "READY_EVENT"
Actor.FIRE_EVENT          = "FIRE_EVENT"
Actor.FREEZE_EVENT        = "FREEZE_EVENT"
Actor.THAW_EVENT          = "THAW_EVENT"
Actor.KILL_EVENT          = "KILL_EVENT"
Actor.RELIVE_EVENT        = "RELIVE_EVENT"
Actor.HP_CHANGED_EVENT    = "HP_CHANGED_EVENT"
Actor.ATTACK_EVENT        = "ATTACK_EVENT"
Actor.UNDER_ATTACK_EVENT  = "UNDER_ATTACK_EVENT"

-- 定义属性
Actor.schema = clone(ModelBase.schema)
Actor.schema["nickname"] = {"string"} -- 字符串类型，没有默认值
Actor.schema["ani"] = {"string"} -- 字符串类型，没有默认值
Actor.schema["phy"] = {"table"}

Actor.initComponents = clone(ModelBase.initComponents)
Actor.initComponents.fsm = "components.behavior.StateMachine"
Actor.initComponents.ani = "engineAdapter.AnimationComponent"
Actor.initComponents.phy = "engineAdapter.PhysicsComponent"


function Actor:ctor(properties, events, callbacks)
    Actor.super.ctor(self, properties)

    if self.ani__ ~= nil and self.phy__ ~= nil then
        local size = self.ani__.inner:boundingBox().size
        self.phy__:size(size.width, size.height)
    end

    -- self:addComponent("components.behavior.StateMachine")
    -- self:addComponent("engineAdapter.AnimationComponent")
    -- self.fsm__ = self:getComponent("components.behavior.StateMachine")
    -- self.ani__ = self:getComponent("engineAdapter.AnimationComponent")


    -- 设定状态机的默认事件
    -- local defaultEvents = {
    --     -- 初始化后，角色处于 idle 状态
    --     {name = "start",  from = "none",    to = "idle" },
    --     -- 开火
    --     {name = "fire",   from = "idle",    to = "firing"},
    --     -- 开火冷却结束
    --     {name = "ready",  from = "firing",  to = "idle"},
    --     -- 角色被冰冻
    --     {name = "freeze", from = "idle",    to = "frozen"},
    --     -- 从冰冻状态恢复
    --     {name = "thaw",   form = "frozen",  to = "idle"},
    --     -- 角色在正常状态和冰冻状态下都可能被杀死
    --     {name = "kill",   from = {"idle", "frozen"}, to = "dead"},
    --     -- 复活
    --     {name = "relive", from = "dead",    to = "idle"},
    -- }
    -- -- 如果继承类提供了其他事件，则合并
    -- table.insertto(defaultEvents, checktable(events))

    -- -- 设定状态机的默认回调
    -- local defaultCallbacks = {
    --     onchangestate = handler(self, self.onChangeState_),
    --     onstart       = handler(self, self.onStart_),
    --     onfire        = handler(self, self.onFire_),
    --     onready       = handler(self, self.onReady_),
    --     onfreeze      = handler(self, self.onFreeze_),
    --     onthaw        = handler(self, self.onThaw_),
    --     onkill        = handler(self, self.onKill_),
    --     onrelive      = handler(self, self.onRelive_),
    --     onleavefiring = handler(self, self.onLeaveFiring_),
    -- }
    -- -- 如果继承类提供了其他回调，则合并
    -- table.merge(defaultCallbacks, checktable(callbacks))

    -- self.fsm__:setupState({
    --     events = defaultEvents,
    --     callbacks = defaultCallbacks
    -- })

    -- self.fsm__:doEvent("start") -- 启动状态机
end

function Actor:pos(x, y)
    self.phy__:pos(x, y)
    return self
end

function Actor:rotation(r)
    self.phy__:rotation(r)
    return self
end

function Actor:getNickname()
    return self.nickname_
end


function Actor:getState()
    return self.fsm__:getState()
end

function Actor:isDead()
    return self.fsm__:getState() == "dead"
end

function Actor:isFrozen()
    return self.fsm__:getState() == "frozen"
end


---- state callbacks

function Actor:onChangeState_(event)
    printf("actor %s:%s state change from %s to %s", self:getId(), self.nickname_, event.from, event.to)
    event = {name = Actor.CHANGE_STATE_EVENT, from = event.from, to = event.to}
    self:dispatchEvent(event)
end

-- 启动状态机时，设定角色默认 Hp
function Actor:onStart_(event)
    printf("actor %s:%s start", self:getId(), self.nickname_)
    -- self:setFullHp()
    self:dispatchEvent({name = Actor.START_EVENT})
end

function Actor:onReady_(event)
    printf("actor %s:%s ready", self:getId(), self.nickname_)
    self:dispatchEvent({name = Actor.READY_EVENT})
end

function Actor:onFire_(event)
    printf("actor %s:%s fire", self:getId(), self.nickname_)
    self:dispatchEvent({name = Actor.FIRE_EVENT})
end

function Actor:onFreeze_(event)
    printf("actor %s:%s frozen", self:getId(), self.nickname_)
    self:dispatchEvent({name = Actor.FREEZE_EVENT})
end

function Actor:onThaw_(event)
    printf("actor %s:%s thawing", self:getId(), self.nickname_)
    self:dispatchEvent({name = Actor.THAW_EVENT})
end

function Actor:onKill_(event)
    printf("actor %s:%s dead", self:getId(), self.nickname_)
    -- self.hp_ = 0
    self:dispatchEvent({name = Actor.KILL_EVENT})
end

function Actor:onRelive_(event)
    printf("actor %s:%s relive", self:getId(), self.nickname_)
    -- self:setFullHp()
    self:dispatchEvent({name = Actor.RELIVE_EVENT})
end

function Actor:onLeaveFiring_(event)
    -- local cooldown = checknumber(event.args[1])
    -- if cooldown > 0 then
    --     -- 如果开火后的冷却时间大于 0，则需要等待
    --     scheduler.performWithDelayGlobal(function()
    --         event.transition()
    --     end, cooldown)
    --     return "async"
    -- end
end

return Actor
