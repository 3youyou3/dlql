local PhysicsScene = class("PhysicsScene", function()
	return display.newScene("PhysicsScene")
end)

kTagGroundCollisionType = 0
kTagActorCollisionType = 1

function PhysicsScene:ctor(gravity)
	-- 设置全局物理世界
	g_physicsWorld = CCPhysicsWorld:create(0, gravity)
	self:addChild(g_physicsWorld)

	g_physicsWorld.worldDebug = g_physicsWorld:createDebugNode()
    g_physicsWorld:addChild(g_physicsWorld.worldDebug)

end

function PhysicsScene:enableWorldBounds(enable)
	if enable then
		self.ground = self:createDefaultSegment(0,0, display.width,0, 1)
		self.ground:setCollisionType(kTagGroundCollisionType)
	else
		if self.ground ~= nil then
			g_physicsWorld:removeBody(self.ground, true)
		end
	end
end

function PhysicsScene:createDefaultSegment(x1, y1, x2, y2, thickness)
	local body = CCPhysicsBody:defaultStaticBody(g_physicsWorld)
	local shape = body:addSegmentShape(CCPoint(x1,y1), CCPoint(x2,y2), thickness)

	g_physicsWorld:addBody(body)

	return body
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