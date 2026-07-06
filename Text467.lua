--// WEAPON SETTINGS TOGGLE

_G.WeaponHook = not _G.WeaponHook

if not _G.WeaponHook then
    getgenv().WeaponSettingsEnabled = false
    return
end

getgenv().WeaponSettingsEnabled = true

getgenv().WeaponSettings = getgenv().WeaponSettings or {}

local s = getgenv().WeaponSettings

-- Daño
s.DefaultDamage = s.DefaultDamage or 13
s.Damage = s.Damage or 13
s.BlockDamage = s.BlockDamage or 0

-- Fuerza
s.Force = s.Force or 20

-- Cooldowns
s.ReloadTime = s.ReloadTime or 0
s.SpecialCooldown = s.SpecialCooldown or 5
s.SpecialBuildup = s.SpecialBuildup or 6

-- Proyectiles
s.BulletSpeed = s.BulletSpeed or 100

-- Habilidades
if s.PassiveAbility == nil then
    s.PassiveAbility = true
end
s.PassiveChance = s.PassiveChance or 5

-- Extras
s.Radius = s.Radius or 10
s.Knockback = s.Knockback or 15
s.Range = s.Range or 50
s.Spread = s.Spread or 0

if s.Pierce == nil then
    s.Pierce = false
end

s.CriticalChance = s.CriticalChance or 0
s.CriticalDamage = s.CriticalDamage or 2

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
                local newValue = getgenv()[key]

if newValue == nil and getgenv().WeaponSettings then
    newValue = getgenv().WeaponSettings[key]
                end
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
