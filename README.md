# Bobby's BD Themes

Bobby's personal collection of BD themes (or more like "tweaks").

## Installation (BMT's Tweaks)

This is a compilaton of tweaks for [Beard's Material Theme](https://github.com/BeardDesign1/Material-design-theme-ressources).

As this contains only tweaks, of course this needs to be loaded alongside BMT itself. If possible, make sure it's loaded *after* BMT.

### BetterDiscord theme

Full version: [Download](https://blog.fiery.me/BobbyBDThemes/build/Bobby-bmt.theme.css)
> This contain all the tweaks in a single file, but you will have to redownload the file to update.

Remote version: [Download](https://blog.fiery.me/BobbyBDThemes/build/Bobby-bmt.remote.theme.css)
> This will remotely load the tweaks from this repo, so you will not have to manually update the theme (restarting Discord should generally be enough to update the theme).

### EnhancedDiscord theme

[Download](https://blog.fiery.me/BobbyBDThemes/build/Bobby-bmt.ed.css)
> This contain all the tweaks in a single file, along with some [EnhancedDiscord-exclusive tweaks](https://github.com/BobbyWibowo/BobbyBDThemes/tree/master/assets/bmt-ed/files), but you will have to redownload the file to update.
>
> It uses `build-ed-template.css` as the template, which already includes `@import` lines for BMT itself.

### import()

You can use this line to import the theme:

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

> I tried to make the modules work by themselves, but certain module can only work alongside other modules (e.i. `20-bmt-magane.css` will only work best with `15-bmt-fixes.css` as it contains the necessary fixes for textarea buttons).

## Build

Mark `build.sh` as executable by doing `chmod o+x build.sh`, then you can run it with `./build.sh`.

Options:

`-c` Copy BD themes to `~/.config/BetterDiscord/themes`.

`-e` Build EnhancedDiscord-compatible theme using `build-ed-template.css` as template.
> If used with `-c`, also copy the theme to `~/.config/EnhancedDiscord/plugins`.

`-r` Build remote version of the themes.

`-q` Disable all output messages.

## Watch

There is also a script available to watch changes then rebuild the themes automatically.

It's named `watch.sh`, mark it as executable to use. The script itself will use `build.sh` to build, so make sure that's also executable.

This needs `inotifywait`, in Debian/Ubuntu it's available in `inotify-tools` package:

```shell
sudo apt install inotify-tools -y
```

By default the script will not use `-c` and `-r` options of `build.sh`. To use them, simply run the script with the said options, e.i. `./watch.sh -c` or `./watch.sh -cr`.
