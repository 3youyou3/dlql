-- init components
g_Components = {
	fsm = "components.behavior.StateMachine",
    ani = "engineAdapter.AnimationComponent",
    act = "engineAdapter.ActionComponent",
    phy = "engineAdapter.PhysicsComponent",
    control = "engineAdapter.ControlComponent",
}

for _, comName in pairs(g_Components) do
	if not cc.Registry.exists(comName) then
		local com = import("." .. comName)
    	cc.Registry.add(com, comName)
    end
end