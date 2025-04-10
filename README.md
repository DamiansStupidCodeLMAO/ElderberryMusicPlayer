# Elderberry Music Player
 A bare bones music player for low resolution devices, made in Love2D!<br>
<img src="https://github.com/user-attachments/assets/5448be9c-e915-4f95-a5fc-afff8cba8d01" width="256px" height="256px" style="image-rendering: crisp-edges;">
## About
This is just a simple music player, featuring queued playback, file navigation, navigable playback and more. This is just a hobby project, so it won't be perfect.
## Usage
This program requires the use of LOVE2D. I may make a standalone release soon.
Upon opening the program, you'll (most likely) be prompted with a popup telling you to add some music to a given folder. Once you add music, if it's [supported by LOVE2D](https://love2d.org/wiki/Audio_Formats), it will show up in the list after restarting the program. While hovering over a song, you can press left and right to switch between Play Now and Queue mode (indicated by icons on the left.) To start your queue, start any other song.<br>
![Elderberry Music Player prompting to add music](https://github.com/user-attachments/assets/16ecc2a7-1e69-49a0-b7f8-2a240854d05c) ![Elderberry Music Player after adding music](https://github.com/user-attachments/assets/42b2be55-d234-419f-8fac-9599148d3878) ![Elderberry Music Player music playback screen](https://github.com/user-attachments/assets/00be5b03-8a3a-4d14-9699-c501af4e41c2) <br>
You can also add custom album art to any song by making a file called `/path/to/song_with.extension.imageextension`, supporting [these image file extensions](https://love2d.org/wiki/Image_Formats) as of 0.2. For example, `/music/test.mp3.png` will add album art in .png format to the song `test.mp3`.<br>
![Paths to both a song and it's album art](https://github.com/user-attachments/assets/eacd5d9e-4a6f-4b9e-8f53-e3eb7ddbc7c7)<br>
![Song with album art](https://github.com/user-attachments/assets/148e715b-13b0-47ac-8c94-c9e3ec71e240)
### The Queue
You can also queue songs to play in Elderberry Music Player. To do this, hit the ≡ button to send it to queue. As of 0.2, to view and edit the queue, hit the ≡ button in the top right. (As of right now, editing the queue only allows for deleting songs. I may make them rearrangeable in the next update!)
![Queue with deletable entries, as seen in EMP 0.2](https://github.com/user-attachments/assets/9508ec1a-c03e-434e-bb6d-d01cecd15ddb)

### Settings
Elderberry Music Player also has settings you can access! To change settings, open the cog menu in the top right. **As of 0.2, this only allows for toggling Pixel-Perfect scaling.**
![image](https://github.com/user-attachments/assets/9cf307d1-1255-4b9a-86ec-30a82f391967)

### Keyboard Input
| Keyboard | Function                             |
|----------|--------------------------------------|
| ↑ ↓ → ←  | Navigate menus                       |
| Enter    | Select menu item                     |
| Esc      | Return to the root (`music/`) folder |
| F11      | Toggle Fullscreen                    |
| Space    | (While Playing) Pause Music          |
## Other notes
Just some other stuff about Elderberry Music Player I thought i'd clear up:
### Why "Elderberry"?
This music player isnt actually it's own singular project. Rather, it's a music player I made with another project in mind. Said project is called Elderberry for multiple reasons, the main two being because A: small, B: chaotic mess of branches (a.k.a. wires)
### Can I use this for my own project?
Absolutely!!!! No questions asked!!! Have fun!!! Hell, send me photos!!! @damian-is-silly.xyz on Bluesky!!!!!!
### I have a feature reque-
# GET OUT!!!!
### I made a custom feature for this myself! Can you add it?
First of all, congratulations on managing to navigate my spaghetti code.
Secondly, sure! Make a pull request and I'll take a look.
