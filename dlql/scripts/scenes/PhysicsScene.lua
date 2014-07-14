local PhysicsScene = class("PhysicsScene", function()
	return display.newPhysicsScene("PhysicsScene")
end)

function PhysicsScene:ctor(gravity)
	-- 设置全局物理世界
	g_physicsWorld = self:getPhysicsWorld()
    g_physicsWorld:setGravity(cc.p(0, GRAVITY))

    self:getPhysicsWorld():setDebugDrawMask(
        true and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)
end

function PhysicsScene:enableWorldBounds(enable)
	if enable then
		self.ground = self:createDefaultSegment(0,0, display.width,0, 1)
	else
		if self.ground ~= nil then
			self:removeChild(self.ground, true)
		end
	end
end

function PhysicsScene:createDefaultSegment(x1, y1, x2, y2, thickness)
	local node = cc.Node:create()
	print(cc.Vec2)
	local body = cc.PhysicsBody:createEdgeSegment(cc.p(x1,y1), cc.p(x2,y2))
	node:setPhysicsBody(body)

	self:addChild(node)

	return node
end

function PhysicsScene:onEnter()
	g_physicsWorld:start()
end

function PhysicsScene:onExit()
	-- 移除全局物理世界
	self.removeChild(g_physicsWorld)
	g_physicsWorld = nil
end

return PhysicsScene;