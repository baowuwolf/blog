# Multiple videos with AVPlayer

I am developing an iOS app for iPad that needs to play videos in some part of the screen. I have several video files that needs to be played after each other in an order that is not given at compile time. It must looks as if it is just one video playing. It is fine that when going from one video to the next that is some delay where the last or first frame of the two videos are shown, but there should be no flickering or white screens with no content. The videos does not contain audio. It is important to take memory usage into account. The videos have a very high resolution and several different video sequences can be played next to each other at the same time.

In order to obtain this I have tried a few solutions for far. They are listed below:

### 1. AVPlayer with AVComposition with all the videos in it
In this solution I have an AVPlayer that will use only on AVPlayerItem made using a AVComposition containing all the videos put in next to each other. When going to specific videos I seek to the time in the composition where the next video start.The issue with this solution is that when seeking the player will quickly show some of the frames that it is seeking by, which is not acceptable. It seems that there is no way to jump directly to a specific time in the composition. I tried solving this by making an image of the last frame in the video that just finished, then show that in front of the AVPLayer while seeking, and finally remove it after seeking was done. I am making the image using AVAssetImageGenerator, but for some reason the quality of the image is not the same as the video, so there is notable changes when showing and hiding the image over the video. Another issue is that the AVPlayer uses a lot of memory because a single AVPlayerItem holds all the videos.

### 2. AVPlayer with multiple AVPlayerItems
This solution uses a AVPlayerItem for each video and the replaces the item of the AVPlayer when switching to a new video. The issue with this is that when switching the item of a AVPlayer it will show a white screen for a short time while loading the new item. To fix this the solution with putting an image in front with the last frame while loading could be used, but still with the issue that the quality of image and video is different and notable.

### 3. Two AVPlayers on top of each other taking turns to play AVPlayerItem
The next solution I tried was having two AVPlayer on top of each other that would take turns playing AVPlayerItems. So When on of the players is done playing it will stay on the last frame of the video. The other AVPlayer will be brought to the front (with its item set to nil, so it is transparent), and the next AVPlayerItem will be inserted in that AVPlayer. As soon as it is loaded it will start playing and the illusion of smooth transaction between the two videos will be intact. The issue with this solution is the memory usage. In some cases I need to play two videos on the screen at the same time, which will result in 4 AVPlayers with a loaded AVPlayerItem at the same time. This is simply too much memory since the videos can be in a very high resolution.

--- 

So the project is now live in the App Store and it is time to come back to this thread and share my findings and reveal what I ended up doing.

### What did not work

The first option where I used on big AVComposition with all the videos in it was not good enough since there was no way to jump to a specific time in the composition without having a small scrubbing glitch. Further I had a problem with pausing the video exactly between two videos in the composition since the API could not provide frame guarantee for pausing.

The third with having two AVPlayers and let them take turns worked great in practice. Exspecially on iPad 4 or iPhone 5. Devices with lower amount of RAM was a problem though since having several videos in memory at the same time consumed too much memory. Especially since I had to deal with videos of very high resolution.

### What I ended up doing

Well, left was option number 2. Creating an AVPlayerItem for a video when needed and feeding it to the AVPlayer. The good thing about this solution was the memory consumption. By lazy creating the AVPlayerItems and throwing them away the moment they were not longer needed in could keep memory consumption to a minimum, which was very important in order to support older devices with limited RAM. The problem with this solution was that when going from one video to the next there a blank screen for at quick moment while the next video was loaded into memory. My idea of fixing this was to put an image behind the AVPlayer that would show when the player was buffering. I knew I needed images that we exactly pixel to pixel perfect with the video, so I captured images that were exact copies of the last and first frame of the videos. This solution worked great in practice.

### The problem with this solution

I had the issue though that the position of the image inside the UIImageView was not the same as the position of the video inside the AVPlayer if the video/image was not its native size or a module 4 scaling of that. Said other words, I had a problem with how half pixels were handled with a UIImageView and a AVPlayer. It did not seem to be the same way.

### How I fixed it

I tried a lot of stuff since I my application was using the videos in interactive way where shown in different sizes. I tried changed the magnificationfilter and minificationFilter of AVPlayerLayer and CALayer to use the same algorithm but did not really change anything. In the end I ended up creating an iPad app that automatically could take screenshots of the videos in all the sizes I needed and then use the right image when the video was scaled to a certain size. This gave images that were pixel perfect in all of the sizes I was showing a specific video. Not a perfect toolchain, but the result was perfect.

### Final reflection

The main reason why this position problem was very visible for me (and therefore very important to solve), was because the video content my app is playing is drawn animations, where a lot the content is in a fixed position and only a part of the picture is moving. If all the content is moved just one pixel it gives a very visible and ugly glitch. At WWDC this year I discussed this problem with an Apple engineer that is an expert in AVFoundation. When I introduced the problem to him his suggestion basically was to go with option 3, but I explained to him that that was not possible because memory consumption and that I already tried that solution out. In that light he said that I choose the right solution and asked me to file a bug report for the UIImage/AVPlayer positioning when video is scaled.



