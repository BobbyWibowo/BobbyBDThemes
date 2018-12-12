# Bobby's BD Themes

Bobby's personal collection of BD themes (or more like "tweaks").

## Installation (BMT's Tweaks)

### BetterDiscord theme

Full version: [Download](https://blog.fiery.me/BobbyBDThemes/build/Bobby-bmt.theme.css)

Remote version: [Download](https://blog.fiery.me/BobbyBDThemes/build/Bobby-bmt.remote.theme.css)

Full version contain all the tweaks in a single file, but you will have to redownload the file whenever you want to update.

Remote version will remotely load them from this repo, so you will not have to manually update the theme (restarting Discord should load the newest version available).

### import()

You can use this line to import the theme from your Custom CSS menu:

```css
@import url(https://blog.fiery.me/BobbyBDThemes/build/Bobby-bmt.css);
```

That's pretty much what the remote version does, by the way.

## Build

Mark `build.sh` as executable by doing `chmod o+x build.sh`, then you can run it with `./build.sh`.

Options:

`-c` copy BD themes to `~/.config/BetterDiscord/themes`.

`-r` build remote version of the themes.

`-q` disable all output messages.

## Watch

To watch changes and rebuild the themes automatically, use `/.watch.sh` (don't forget to mark it as executable).

This needs `inotifywait`, in Debian/Ubuntu it's available as `inotify-tools`:

```shell
sudo apt install inotify-tools -y
```
