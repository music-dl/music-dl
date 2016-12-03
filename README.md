## Installation
#### Required part
Install missing gems with

`bundle install`

Copy yaml file for credentials and fill it in with your keys

`cp secrets.yml.sample secrets.yml`

To use this tool you must add **youtube api key** to `secrets.yml` file. Youtube google api key can be created here https://console.developers.google.com/

#### Optional part
To download songs from spotify playlists you must add spotify api credentials (top 10 works without credentials).
**Spotify** **client id** and **client secret** can be created here https://developer.spotify.com/my-applications. Add them to `secrets.yml` file.

## Usage

##### Download one track
`ruby main.rb -t 'r you mine'`

##### Download artist's top 10 tracks
`ruby main.rb -a 'arctic monkeys'`

##### Download tracks from file
```bash
$ cat songs.txt
оксимирон imperial
soad toxicity
маршрутка
```
`ruby main.rb -f 'songs.txt'`

##### Download tracks from spotify playlist
`ruby main.rb -p 'https://open.spotify.com/user/1249251980/playlist/3SC5B4DyGykKQIcNA7uemX'`

##### See full list of options
`ruby main.rb --help`

## For developers
You can find documentation about youtube api here
https://developers.google.com/youtube/v3/docs/search/list
