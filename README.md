# Dynamic Heist Job Script

## Welcome to the Dynamic Heist Job Script! This script is designed to provide an exhilarating and immersive experience for players looking to take on high-stakes missions. Arm yourself, defeat the guards, loot them, and collect your payout. And, if you need a quick getaway, we've got you covered with a spawnable vehicle!

# Features

* Start and Stop Jobs: Players can initiate and halt jobs, with monetary transactions ensuring commitment.

* Guard Interaction: Guard AI is strategically neutral towards each other but hostile towards the player.

* Looting Mechanics: Only after all guards are defeated can players loot them for guaranteed and chance-based rewards.

* Dynamic Vehicle Spawning: Need a quick exit? Spawn a Glendale for a price, and receive the keys immediately!

* Job Completion Rewards: Once the job is done, collect your well-deserved payout.

# Configuration

All settings can be easily adjusted in the config.lua file:


 Config = {}

Config.PedLocation = vector4(0.0, 0.0, 0.0, 0.0)
Config.Waypoint1 = vector4(0.0, 0.0, 0.0, 0.0)
Config.GuardLocations = {
    vector4(0.0, 0.0, 0.0, 0.0),
    vector4(0.0, 0.0, 0.0, 0.0),
    vector4(0.0, 0.0, 0.0, 0.0),
    vector4(0.0, 0.0, 0.0, 0.0)
}
Config.SecondPedLocation = vector4(0.0, 0.0, 0.0, 0.0)
Config.VehicleSpawnLocation = vector4(0.0, 0.0, 0.0, 0.0)
Config.GuardModel = `s_m_m_security_01`
Config.JobPedModel = `a_m_y_business_01`
Config.GuardWeapon = GetHashKey("WEAPON_SMG")
Config.GuardHealth = 200
Config.GuardArmour = 100
Config.RewardItem = 'your_item'
Config.RewardChance = 50 -- 50% chance to get the item
Config.Payout = 500

Config.GuaranteedItem = 'guaranteed_item' -- Replace with your guaranteed item
Config.GuaranteedItemCount = 1 -- Number of guaranteed items to give 

# Installation

## Clone or Download the Repository:

bash
git clone https://github.com/yourusername/dynamic-heist-job-script.git
Add to Your Server: Place the script folder into your resources directory and ensure it's included in your server.cfg:


ensure dynamic-heist-job-script

Edit Configuration: Adjust the config.lua file to suit your server's needs.



# Client-Side Events

* startJob: Starts the heist job.

* stopJob: Stops the job and removes any spawned entities.

* spawnCar: Spawns a Glendale vehicle and gives the player the keys.

* lootGuard: Allows the player to loot a defeated guard.

* completeJob: Completes the job and sets a waypoint for payout collection.

* collectPayout: Collects the payout once the job is complete.

# Future Enhancements

* Additional Guard Types: Introduce variety in guard models and behaviors.

* Dynamic Missions: More mission types and objectives for enhanced replayability.

* Custom Rewards: More reward types and customization options for players.

# Contributing

* We welcome contributions to improve this script! Feel free to submit pull requests or open issues.

# License

* This project is licensed under the MIT License. See the LICENSE file for more details.

# Acknowledgments

* A huge shoutout to the amazing community of developers and modders who continuously push the boundaries of gaming!
