# banshy!
Banshy is a multimedia player inspired by the ol' good Banshee. This project is a humble attempt to emulate the functionality of the long time ago abandoned app.  Developed in Ruby, utilizing the GTK3 library for the user interface and GStreamer for multimedia playback. With this application, users can enjoy their favorite audio and video files with ease. It allows to store, organize your media files into playlists and easily switch from video to audio files. It's compatible with Gnome Desktop.

[Screencast from 31-03-2024 01:46:06.webm](https://github.com/robertobermudez/banshy/assets/1206729/179074a3-3f9a-4245-8f41-03c190e5520e)


### Prerequisites

Ruby: Make sure you have Ruby installed on your system. You can download it from https://www.ruby-lang.org.
GTK3: Ensure that GTK3 is installed. If not, you can install it using your system's package manager. For example, on Ubuntu, you can install it with the following command:
    
```bash
sudo apt-get install libgtk-3-dev sqlite3 ruby-dev libgirepository1.0-dev libgtk-3-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev ruby-full ruby-bundler
```
GStreamer: Install GStreamer, which is used for multimedia playback. Again, you can use your system's package manager to install it. For example, on Ubuntu:
```bash
sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-libav
```

Clone into your home folder

```bash
git clone https://github.com/robertobermudez/banshy.git
```

```bash
cd banshy
./install.sh
```

Please note that this app is in a very early stage of development. Any feedback or comment is more than welcome!

### Skeleton of the project
.
├── application
│   ├── lib
│   ├── models
│   └── ui
│       └── banshy
│
├── resources
│   ├── gresources.xml
│   └── ui
│       
└── test
