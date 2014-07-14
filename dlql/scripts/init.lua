-- init components
local components = {
    "engineAdapter.AnimationComponent",
    "engineAdapter.PhysicsComponent"
}

for _, packageName in ipairs(components) do
    cc.Registry.add(import("." .. packageName), packageName)
end