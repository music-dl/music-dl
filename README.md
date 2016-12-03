## Installation
#### Required part
Install third-party tools [youtube-dl](https://rg3.github.io/youtube-dl/) and
[ffmpeg](https://ffmpeg.org/). Generally it's easy.

Mac
```bash
brew install ffmpeg youtube-dl
```

Ubuntu
```bash
sudo apt-get install ffmpeg youtube-dl
```

Install missing gems

```bash
bundle install
```

Copy yaml file with credentials and fill it in with your keys. For testing purposes you can use keys provided in `secrets.yml.public`, but please create your own keys ASAP to allow other people to test this tool, because free usage limits are too low for several users.

```bash
cp secrets.yml.public secrets.yml
```

Please add your own **youtube google api key** to `secrets.yml` file. It can be created here https://console.developers.google.com/

#### Optional part
To download songs from spotify playlists please add spotify api credentials (top 10 works without credentials).
**Spotify** **client id** and **client secret** can be created here https://developer.spotify.com/my-applications. Add them to `secrets.yml` file.

## Usage

##### Download one track
And save it to `~/Music` folder. `-d` option can be used together with any other options. Without it tracks will be saved to `./audio` folder.

```bash
ruby main.rb -t 'r you mine' -d ~/Music
```

##### Download artist's top 10 tracks
```bash
ruby main.rb -a 'arctic monkeys'
```

##### Download tracks from file
```bash
echo 'оксимирон imperial\nsoad toxicity\nмаршрутка' > songs.txt
ruby main.rb -f 'songs.txt'
```

##### Download tracks from spotify playlist
```bash
ruby main.rb -p 'https://open.spotify.com/user/1249251980/playlist/3SC5B4DyGykKQIcNA7uemX'
```

##### See full list of options
```bash
ruby main.rb --help
```

## TODO
1. Syncronize songs (via daemon or runnable script) with folder in filesystem, Dropbox, GoogleDrive etc.
2. Distribution via Rubygems or Traveling Ruby.
3. Web application.

## For developers
You can find documentation about youtube api here
https://developers.google.com/youtube/v3/docs/search/list
