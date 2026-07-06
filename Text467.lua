getgenv().WeaponSettings = {
    -- Daño
    DefaultDamage = 13,
    Damage = 13,
    BlockDamage = 0,

    -- Fuerza
    Force = 20,

    -- Cooldowns
    ReloadTime = 0,
    SpecialCooldown = 5,
    SpecialBuildup = 6,

    -- Proyectiles
    BulletSpeed = 100,

    -- Habilidades
    PassiveAbility = true,
    PassiveChance = 5,

    -- Puedes seguir agregando más
    Radius = 10,
    Knockback = 15,
    Range = 50,
    Spread = 0,
    Pierce = false,
    CriticalChance = 0,
    CriticalDamage = 2
}
local function ModifyTable(tbl)
    for key, value in pairs(tbl) do
        if typeof(value) == "table" then
            ModifyTable(value)
        else
            local newValue = getgenv().WeaponSettings[key]
            if newValue ~= nil then
    if key == "Damage" then
        -- No modificar si el remoto tiene Damage = 0
        if value ~= 0 then
            -- Si tú pones Damage = 0, enviar 0.1
            tbl[key] = (newValue == 0 and 0.1 or newValue)
        end

    elseif key == "Force" then
        -- No modificar si el remoto tiene Force mayor a 100000
        if value <= 100000 then
            tbl[key] = newValue
        end

    else
        tbl[key] = newValue
    end
end
        end
    end
end

local mt = getrawmetatable(game)
setreadonly(mt, false)

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}

    if getnamecallmethod() == "FireServer" then
        for _, arg in ipairs(args) do
            if typeof(arg) == "table" then
                ModifyTable(arg)
            end
        end
    end

    return old(self, unpack(args))
end)

setreadonly(mt, true)
