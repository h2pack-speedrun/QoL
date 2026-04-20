-- luacheck: globals QoLInternal
local internal = QoLInternal

function internal.RegisterHooks()
    for _, fn in ipairs(internal.hook_fns) do
        fn()
    end
end

return internal
