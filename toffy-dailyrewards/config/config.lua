Config = {}

-- Framework Settings
Config.Framework = "qbx" -- "qbx" or "qbcore"
Config.Inventory = "ox"  -- "ox" (ox_inventory for Qbox/QB-Core) or "qb" (qb-inventory / default QB-Core inventory)

-- Localization Settings
Config.Language = "en" -- "tr" (Turkish) or "en" (English) for server-side notifications


-- Theme Colors (Easy to customize!)
Config.Theme = {
    Primary = "#be2edd",          -- Ana renk (mor)
    Success = "#2ecc71",          -- Başarı rengi (yeşil)
    Danger = "#e74c3c",           -- Hata rengi (kırmızı)
    Gold = "#f1c40f",             -- Premium rengi (altın)
    BackgroundDark = "#0a0b0d",   -- Arka plan koyu
    PanelBackground = "#101115",  -- Panel arka plan
    CardBackground = "#14151a"    -- Kart arka plan
}


Config.InventoryImagePath = "nui://ox_inventory/web/images/"


Config.OpenCommand = "dailyrewards"
Config.OpenKey = "F10" -- Keyboard button 


Config.Cooldown = 86400      -- 24 Hours: Wait time before next claim is available
Config.StreakExpiry = 172800 -- 48 Hours: Maximum time allowed to claim the next day before the streak resets back to Day 1


Config.RedeemCodes = {
    ["TOFFYPREMIUM"] = true,
    ["DAILYMOR"] = true,
    ["PREMIUMCODE"] = true,
    ["QBOXDAILY"] = true,
}


Config.Rewards = {
    [1] = {
        normal = { item = "water", amount = 2, label = "Water", isCash = false },
        premium = { item = "water", amount = 5, label = "Premium Water", isCash = false }
    },
    [2] = {
        normal = { item = "phone", amount = 1, label = "Phone", isCash = false },
        premium = { item = "phone", amount = 2, label = "Dual Phone", isCash = false }
    },
    [3] = {
        normal = { item = "sandwich", amount = 2, label = "Sandwich", isCash = false },
        premium = { item = "burger", amount = 3, label = "Premium Burger", isCash = false }
    },
    [4] = {
        normal = { item = "radio", amount = 1, label = "Radio", isCash = false },
        premium = { item = "radio", amount = 2, label = "Secure Radio", isCash = false }
    },
    [5] = {
        normal = { item = "lockpick", amount = 1, label = "Lockpick", isCash = false },
        premium = { item = "advancedlockpick", amount = 2, label = "Adv Lockpick", isCash = false }
    },
    [6] = {
        normal = { item = "bandage", amount = 2, label = "Bandage", isCash = false },
        premium = { item = "firstaid", amount = 2, label = "First Aid Kit", isCash = false }
    },
    [7] = {
        normal = { item = "WEAPON_KNUCKLE", amount = 1, label = "Knuckles", isCash = false, isWeapon = true },
        premium = { item = "WEAPON_KNUCKLE", amount = 2, label = "Gold Knuckles", isCash = false, isWeapon = true }
    },
    [8] = {
        normal = { item = "firstaid", amount = 2, label = "First Aid Kit", isCash = false },
        premium = { item = "firstaid", amount = 5, label = "Adv First Aid Kits", isCash = false }
    },
    [9] = {
        normal = { item = "bandage", amount = 2, label = "Bandage", isCash = false },
        premium = { item = "bandage", amount = 6, label = "Premium Bandages", isCash = false }
    },
    [10] = {
        normal = { item = "cash", amount = 3000, label = "Cash", isCash = true },
        premium = { item = "cash", amount = 8000, label = "Premium Cash", isCash = true }
    },
    [11] = {
        normal = { item = "lockpick", amount = 2, label = "Lockpick", isCash = false },
        premium = { item = "advancedlockpick", amount = 3, label = "Adv Lockpicks", isCash = false }
    },
    [12] = {
        normal = { item = "armour", amount = 1, label = "Armour Vest", isCash = false },
        premium = { item = "armour", amount = 3, label = "Heavy Armour Vests", isCash = false }
    },
    [13] = {
        normal = { item = "cash", amount = 1000, label = "Cash", isCash = true },
        premium = { item = "cash", amount = 5000, label = "Premium Cash", isCash = true }
    },
    [14] = {
        normal = { item = "ammo-9", amount = 10, label = "9MM Ammo", isCash = false },
        premium = { item = "ammo-9", amount = 40, label = "Adv 9MM Ammo", isCash = false }
    },
    [15] = {
        normal = { item = "water", amount = 4, label = "Water", isCash = false },
        premium = { item = "water", amount = 8, label = "Premium Water", isCash = false }
    },
    [16] = {
        normal = { item = "WEAPON_BAT", amount = 1, label = "Baseball Bat", isCash = false, isWeapon = true },
        premium = { item = "WEAPON_CROWBAR", amount = 1, label = "Crowbar Gold", isCash = false, isWeapon = true }
    },
    [17] = {
        normal = { item = "water", amount = 2, label = "Water", isCash = false },
        premium = { item = "beer", amount = 4, label = "Craft Beer", isCash = false }
    },
    [18] = {
        normal = { item = "phone", amount = 1, label = "Phone", isCash = false },
        premium = { item = "phone", amount = 2, label = "Smart Phone", isCash = false }
    },
    [19] = {
        normal = { item = "radio", amount = 1, label = "Radio", isCash = false },
        premium = { item = "radio", amount = 3, label = "Premium Radio", isCash = false }
    },
    [20] = {
        normal = { item = "lockpick", amount = 2, label = "Lockpick", isCash = false },
        premium = { item = "advancedlockpick", amount = 4, label = "Elite Lockpicks", isCash = false }
    },
    [21] = {
        normal = { item = "WEAPON_KNUCKLE", amount = 3, label = "Knuckles", isCash = false, isWeapon = true },
        premium = { item = "WEAPON_KNIFE", amount = 1, label = "Tactical Knife", isCash = false, isWeapon = true }
    },
    [22] = {
        normal = { item = "firstaid", amount = 3, label = "First Aid Kit", isCash = false },
        premium = { item = "firstaid", amount = 6, label = "Adv First Aid Kits", isCash = false }
    },
    [23] = {
        normal = { item = "bandage", amount = 3, label = "Bandage", isCash = false },
        premium = { item = "bandage", amount = 8, label = "Premium Bandages", isCash = false }
    },
    [24] = {
        normal = { item = "cash", amount = 4000, label = "Cash", isCash = true },
        premium = { item = "cash", amount = 12000, label = "Premium Cash", isCash = true }
    },
    [25] = {
        normal = { item = "sandwich", amount = 2, label = "Sandwich", isCash = false },
        premium = { item = "burger", amount = 5, label = "Premium Burgers", isCash = false }
    },
    [26] = {
        normal = { item = "armour", amount = 1, label = "Armour Vest", isCash = false },
        premium = { item = "armour", amount = 4, label = "Heavy Armour Vests", isCash = false }
    },
    [27] = {
        normal = { item = "cash", amount = 2000, label = "Cash", isCash = true },
        premium = { item = "cash", amount = 10000, label = "Premium Cash", isCash = true }
    },
    [28] = {
        normal = { item = "ammo-9", amount = 20, label = "9MM Ammo", isCash = false },
        premium = { item = "ammo-9", amount = 100, label = "Crate 9MM Ammo", isCash = false }
    },
    [29] = {
        normal = { item = "armour", amount = 2, label = "Armour Vests", isCash = false },
        premium = { item = "armour", amount = 5, label = "Elite Armour Vests", isCash = false }
    },
    [30] = {
        normal = { item = "WEAPON_PISTOL", amount = 1, label = "Glock Pistol", isCash = false, isWeapon = true },
        premium = { item = "WEAPON_SMG", amount = 1, label = "Micro SMG Gold", isCash = false, isWeapon = true }
    }
}
