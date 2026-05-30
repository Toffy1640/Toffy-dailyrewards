
# Toffy Daily Rewards

Simple and customizable daily rewards script!

**Framework Support:**
- Qbox
- QBCore
<img width="1672" height="941" alt="TOFFY" src="https://github.com/user-attachments/assets/124536ca-d5fa-409f-a60f-bff603b69ac5" />
**Inventory Support:**
- ox_inventory
- qb-inventory 

**Features:**
- Easy theme customization from config
- Basic and Premium reward tiers
- 30-day reward system
- Modern design

## Installation
1. Download the script
2. Drag & drop `toffy-dailyrewards` folder into your `resources` directory
3. Add `ensure toffy-dailyrewards`
4. Restart your server!

## Customization
### Theme Colors (config.lua)
You can change all colors from the `Config.Theme` section:
- `Primary`: Main color (buttons, highlights)
- `Success`: Success message color
- `Danger`: Error message color
- `Gold`: Premium status color
- `BackgroundDark`: Main background color
- `PanelBackground`: Panel background color
- `CardBackground`: Card background color

**Supported color formats:**
- Standard hex: `#be2edd`
- ARGB: `FFC41B08` (FiveM format)

### Other Settings
- `Config.OpenCommand`: Open menu with command
- `Config.OpenKey`: Open menu with key
- `Config.Cooldown`: Wait time for next reward (in seconds)
- `Config.RedeemCodes`: Premium activation codes

## Usage
In-game:
- Use the `/dailyrewards` command or press your configured key (default: F10)!
