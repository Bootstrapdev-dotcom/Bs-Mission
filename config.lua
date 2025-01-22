-- config.lua
Config = {}

Config.PedLocation = vector4(515.15, 174.53, 100.68, 249.48)
Config.Waypoint1 = vector4(2130.38, 4806.39, 41.14, 296.06)
Config.GuardLocations = {
    vector4(2137.98, 4786.82, 40.97, 22.2),
    vector4(2126.35, 4785.29, 40.97, 14.9),
    vector4(2140.5, 4787.13, 48.22, 344.68),
    vector4(2182.96, 4827.53, 42.21, 116.38)
}
Config.SecondPedLocation = vector4(2189.6, 5597.89, 53.71, 82.8)
Config.VehicleSpawnLocation = vector4(519.97, 168.72, 99.37, 255.61)
Config.GuardModel = `s_m_m_security_01`
Config.JobPedModel = `a_m_y_business_01`
Config.GuardWeapon = GetHashKey("WEAPON_SMG")
Config.GuardHealth = 200
Config.GuardArmour = 100
Config.RewardItem = 'meth'
Config.RewardChance = 20 -- 50% chance to get the item
Config.Payout = 5000

Config.GuaranteedItem = 'coke_brick' -- Replace with your guaranteed item
Config.GuaranteedItemCount = 1 -- Number of guaranteed items to give
