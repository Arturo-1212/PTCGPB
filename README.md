*The bot will always be free and I will update it as long as this method is viable. I've spent many hours creating the PTCGPB, and if it’s helped you complete your collection, consider buying me a coffee to keep me going and adding new features!*
https://buymeacoffee.com/aarturoo

*Thanks for your support, and let’s keep those god packs coming!* 😄

If you're having issues check the common issues section after the guide.

# **__Arturo's Pokemon Trading Card Game Pocket Bot v3.3.2__**
-# *Special thanks to azureWox, Flubsthefool, havaak, pifobi for their code contributions* 
-# *Thanks to everyone who has helped test or has contributed their suggestions to make the bot better!*

**__What does this do?__**
- Rerolls accounts to 26 cards in under 3 mins from account creation to deletion stopping an instance if it gets a god pack.
- It can now run behind windows in the background (not minimized) and does not take control of your mouse or keyboard!
- Gif of a bot run: https://i.imgur.com/DfqAp7c.gif

**__What do I need?__**
- [MuMu Player](https://www.mumuplayer.com/)
- [AutoHotkey v1.X](https://www.autohotkey.com/download/ahk-install.exe)
- [PTCGP Bot.zip](https://github.com/Arturo-1212/PTCGPB/archive/refs/tags/v3.3.2.zip)

**__How can I get it working?__**

Step 1: Install the necessary programs
- AutoHotKey
- Global MuMu Player (Leave the default folder install)

Step 2: Set-Up MuMu Player
- Install
- Recommended Settings **(Bold = Must have)**
  - CPU: 2
  - RAM: 2
  - Less resource usage
  - Forced use of discrete graphics
  - **Custom: 540 x 960 220 dpi**
  - **Screen brightness: 50**
  - **Screen style: Common**
  - FPS: 60
  - **Do not turn on the FPS display**
  - Close system sound
  - **Uncheck: Keep running in the background**
  - Exit directly
- Name your instances "1", "2", "3", "4", etc. without the quotes.
  - Make sure there are no other instances named the same even if they aren't running!
- The very first instance in the multi-instance window is incompatible. just name another one 1.

Step 3: Install PTCGP
 - PTCGP Speed Mod [[Old]](https://modsfire.com/y6p37S9f7n2fD38) [[New]](https://modsfire.com/6OIgGK903XQXy6O) ** - *Thanks to nowhere_222 from the platinmods forum.*
- Drag and drop into your MuMu instance
-# **New version has a mod menu to choose from 1x-3x speed. 3x uses more resources especially when running many instances. You can still use the old version on 2x.

Step 4: 
- Download the Bot zip
- Extract it by Right click the zip > extract

Step 5: Windows settings
- **Change scale to 125% in your windows settings.** > Press windows key > Type "display settings" > Look for the scale setting and change it to 125% for all your monitors.
- all windows color filters off
- HDR off

Step 6: 
- Start your instances
- Open PTCGP
- Download initial 600 mb
- Delete account
- Restart and get it to where you select your birthdate and country. 

Step 7: 
- Run PTCGPB.ahk
- If you're using the new speed mod linked above then make sure to click the "PM" logo > cog wheel > save preferences > cog wheel > set speed to the one you will be running at > minimize

Step 8: Input your script settings
- Number of instances you are running
- Pack you want to open
- Delay in between actions
- Time Zone: The time the game "changes date." 1 AM EST so convert that to yours.
- Name: What to name the account
- Instances per row: How many instances per row
- Netease Path: If you didn't change your path upon installation leave it. Otherwise input the path.
- Speed: This is what game speed you want to run at if you have the new speed mod.
  - 2x works with both the old and the new.
  - With the new on be sure to: click the platinmods logo > cog wheel > save preferences > set to 2x speed
- Language: Select your game language. In order to change your language > change language settings in mumu > delete the game account data.
  - English100 is to run it on scale 100 in English.
- Monitor: Select which monitor you'd like it to run on. Try to start the mumu instances in the correct monitor to prevent issues
- Swipe Speed: The duration of the swipe. Increase/decrease it if it's not swiping well on your system.
- God Pack: Whether you want it to pause on a god pack or to close the emulator to save resources.
- False positive prevention: If you are getting to many false positives (stopping on a pack that isn't a god pack) then enable this
- Arrange windows: Arranges the windows in rows/columns
- Discord ID: if you're going to use webhooks to send yourself messages add your discord id so you are pinged. Not your username, but your numerical discord ID.
- Discord Webhook url: your discord's server webhook URL. Create a server in discord > create any channel > click the edit channel cog wheel > integrations > create a webhook > click on the webhook created > copy webhook url. That is what goes here.
- Click Next

Step 9: Click Start
- **Allow adb to run and through the firewall if it asks you**

Step 10: Find god packs
- Your bot should be running

__**GP Test button:**__
This is so you can verify if a god pack is alive or not. Press the button or F8 and the bot will stop after the wonder pick tutorial so you are able to add the god pack account you want to verify. After you manually add and verify it press F8 again and the bot will delete the account data and start over. If you need more attempts then you can press F8 another time for it to stop again.

# Telegram API
If you want to send messages to yourself via a Telegram bot, you need to edit the `Settings.ini` file by entering the required API values for `telegramToken`, `telegramChatID` and `telegramTopicID` variables.

# Common Issues
__Invalid port or failed to launch 1.ahk__
- Your mumu folder path is different from the typical default path so find where it installed. Mine is in: C:\Program Files\Netease and this would be what i would paste there
- Skip using the very first instance in the mumu multi instance window. i think the config file for that one is different so my script cant get its port
- Make sure you don't have other instances of mumu named the same even if they're not running.
- Make sure there are no spaces leading to the bot's directory in the folder path
- Unblock security in the ptcgpb properties: [Image](https://media.discordapp.net/attachments/1316114771568754721/1324170598775132261/image.png?ex=677a7938&is=677927b8&hm=8593d02ca3fada3e8c258f69aec10bb30f21c51d01276b991f4bf0912b24ce4a&=&format=webp&quality=lossless&width=1817&height=897)

__Error 0x800700E8__
- If it happens after already being able to click then one of the terminal windows may have been closed try restarting.
- Your window names might be wrong
- Make sure you allow adb when you run it. If you disallowed it or never got the prompt restart pc and try again
- Make sure there is no spaces leading to the bot's directory in the folder path

__Black bars when switching from scale 100/125__
- Try again/reload the bot and it should fix itself. It sometimes happens on the first try.

__Platin.png__
- Make sure DPI is 220 in mumu
- Make sure the new mod is installed
- Reset the mumu display and font to default
- Untick keep running in background in the mumu app settings.

__One of my AHK is no longer running how do i restart it?__
- bot folder > scripts > double click the one that stopped

__It doesn't do anything/Stuck Arranging windows__
- Make sure you named your instance just the number "1", "2", "3", etc. and not "MuMu Player 1", "MuMu Player 2", etc.
- Make sure you don't have other instances named the same even if they're not running.
- The very first mumu instance in the list with the lock can't be used.

__Clicking top right at "Country or Menu"__
- MuMu's emulator resolution must be 540x960 with 220dpi
- Windows scale needs to be set to 125% in your windows display settings. If you have multiple monitors then all of them need to be set to 125%
- The game needs to be in english
- HDR needs to be off
- Resolution is incorrect in mumu settings
- Don't press MuMu's align window button
- Don't resize the instances manually the script does it
- Mumu screen style setting must be set to common
- Doesn't work if you have a 4k resolution you have to scale it down to 1440p
- You input the incorrect number of instances
- Mumu's brightness needs to be 50
- AMD graphics driver: disable graphics enhancement
- Make sure your instances are named 1, 2, 3, 4 etc. Just the number, counting starting from 1. Nothing else.
- Turn off windows color filters

__"Cannot find source image"__
- You need to extract from the .zip first

__I get stuck at naming or OK__
- Make sure dpi is set at 220 in the mumu settings.

__Having issues swiping packs__
1. If you are having issues swiping on the 2x speed setting you can try switching to 1x/2x or 1x/3x where it will swipe at 1x speed then switch. You need the newest mod version in the set up guide
2. Play around with the new swipe speed setting. This is going to be through trial and error, but you can put in a little work to get it working better for you..
3. People have been reporting better swiping if they match mumu's fps to their monitor's fps.
4. Run fewer instances or try increasing your CPU cores in mumu

__False positive god packs found__
If the second card in your false positive GP is not a common border then there is something that is making your colors different. Double check the following:
- HDR off in windows
- Color filters off in windows
- Common screen style in mumu
- Brightness on 50 in mumu

If all of that is fine then you can set the false positive setting to yes in the bot set up.

Why are false positives happening? Am I missing out on god packs?
- There are 2 reasons this can happen. 1. there is a split second delay between getting to the opening screen and the cards being shown or 2. There is something different somewhere with your color settings so it detects other card borders as common. Changing the false positive setting to yes addresses both of these.
- No, you're not missing out on god packs. This is because the bot detects the common borders to skip the cards. If no common borders are detected then it flags it as a god pack and as a result false negatives should be impossible unless you're running with high image search variation like it was doing in prior versions

If none of this solves your issue then restart your PC and try again.
