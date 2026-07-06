--// WEAPON SETTINGS TOGGLE

_G.WeaponHook = not _G.WeaponHook

if not _G.WeaponHook then
    getgenv().WeaponSettingsEnabled = false
    return
end

getgenv().WeaponSettingsEnabled = true

getgenv().WeaponSettings = {
    -- Daño
    DefaultDamage = 13,
    Damage = 13,
    BlockDamage = 0,

    -- Fuerza
    Force = 20,

    -- Cooldowns
    ReloadTime = 0.2,
    SpecialCooldown = 5,
    SpecialBuildup = 15,

    -- Proyectiles
    BulletSpeed = 100,

    -- Habilidades
    PassiveAbility = true,
    PassiveChance = 5,

    Radius = 10,
    Knockback = 15,
    Range = 50,
    Spread = 0,
    Pierce = false,
    CriticalChance = 0,
    CriticalDamage = 2
}

if not _G.WeaponHookLoaded then
    _G.WeaponHookLoaded = true

    local function ModifyTable(tbl)
        if not getgenv().WeaponSettingsEnabled then
            return
        end

        for key, value in pairs(tbl) do
            if typeof(value) == "table" then
                ModifyTable(value)
            else
                local newValue = getgenv().WeaponSettings[key]

                if newValue ~= nil then

                    if key == "Damage" then

                        if value ~= 0 then
                            tbl[key] = (newValue == 0 and 0.1 or newValue)
                        end

                    elseif key == "Force" then

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

        if getgenv().WeaponSettingsEnabled
            and getnamecallmethod() == "FireServer" then

            for _, arg in ipairs(args) do
                if typeof(arg) == "table" then
                    ModifyTable(arg)
                end
            end
        end

        return old(self, unpack(args))
    end)

    setreadonly(mt, true)
end
