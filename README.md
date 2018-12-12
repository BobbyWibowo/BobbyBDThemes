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

### Modular import()

If you only need some parts of the tweaks instead of the whole thing, you can choose to import only some of them.

First head to [/assets/bmt/files](https://github.com/BobbyWibowo/BobbyBDThemes/tree/master/assets/bmt/files) to view all available modules.

For example, to import `20-bmt-magane.css`, its import line will be:

```css
@import url(https://blog.fiery.me/BobbyBDThemes/assets/bmt/files/20-bmt-magane.css);
```

## Build

Mark `build.sh` as executable by doing `chmod o+x build.sh`, then you can run it with `./build.sh`.

Options:

`-c` copy BD themes to `~/.config/BetterDiscord/themes`.

`-r` build remote version of the themes.

`-q` disable all output messages.

## Watch

There is also a script available to watch changes then rebuild the themes automatically.

It's named `watch.sh`, mark it as executable to use. The script itself will use `build.sh` to build, so make sure that's also executable.

This needs `inotifywait`, in Debian/Ubuntu it's available as `inotify-tools`:

```shell
sudo apt install inotify-tools -y
```

By default the script will not use `-c` and `-r` options of `build.sh`. To use them, simply run the script with the said options, e.i. `./watch.sh -c` or `./watch.sh -cr`.
