# dotfiles

My Arch + Hyprland setup. The whole thing is themed from whatever wallpaper Im using: I pick one, [matugen](https://github.com/InioX/matugen) pulls the colours out of it , and everything else follows.

<!-- Add a screenshot here: ![desktop](screenshots/desktop.png) -->

That covers the Quickshell bar, GTK 3/4, Qt (qt5ct, qt6ct, Kvantum), kitty, Neovim, Firefox, Vesktop, Steam (AdwSteamGtk), Walker, OBS, Hyprland, the cursor, and the Papirus folder colours.

Each top-level folder is a [GNU Stow](https://www.gnu.org/software/stow/) package that mirrors `$HOME`, so you can grab just the bits you like.

A few notes before you dive in:

- **Wallpapers aren't included.** Put your own in `~/Pictures/Wallpapers`.
- **This is built for my machine.** Some paths are hardcoded (see [Extra setup](#extra-setup)), expect to tweak a few things.
- It's Arch-only. I haven't tried it anywhere else.
- Feel free to contrubute , id love to make this setup better - afterall im daily driving it.

## Install

You'll need Arch, `git`, and the AUR helper [yay](https://github.com/Jguer/yay).

```bash
git clone https://github.com/deathxknight/dotfiles ~/dotfiles
cd ~/dotfiles

sudo pacman -S --needed - < pkglist.txt
yay -S --needed $(cat aur-pkglist.txt)

stow -R bin firefox firefox-icons gtk hypr kitty matugen matugenfox nvim obs qt quickshell steam systemd vesktop walker zsh
```

Stow won't overwrite real files. If it complains about a conflict, move or delete the file it names and run the command again.

Don't want everything ? Just stow the folders you want , e.g. `stow -R kitty nvim`.

## Extra setup

A few things need your touch..

**Qt config paths.** qt5ct and qt6ct store absolute paths, so point them at your home folder:

```bash
sed -i --follow-symlinks "s|/home/[^/]*/|$HOME/|g" ~/.config/qt5ct/qt5ct.conf ~/.config/qt6ct/qt6ct.conf
```

`--follow-symlinks` keeps the Stow links intact. Saving settings inside qt5ct or qt6ct can swap a link for a real file, so if that happens, run `stow -R qt` again.

**Passwordless sudo for Papirus folders.** The matugen hook needs  `sudo -n papirus-folders` to recolour the icons, so it needs to work without a password:

```bash
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/papirus-folders" | sudo tee /etc/sudoers.d/papirus-folders
sudo chmod 440 /etc/sudoers.d/papirus-folders
sudo visudo -c
```

**Firefox profile.** `matugen/.config/matugen/config.toml` writes to a profile folder called `mnvwbvy5.default-release`, and the `firefox/` package uses the same name. Yours WILL be different. Find it in `~/.config/mozilla/firefox/`, change the name in `config.toml`, and rename the folder inside `firefox/.config/mozilla/firefox/` to match.

**Cursor theme.** `cursor-src` is a clone of [rtgiskard/bibata_cursor](https://github.com/rtgiskard/bibata_cursor) with one small local edit, kept as a patch:

```bash
git clone https://github.com/rtgiskard/bibata_cursor ~/.config/matugen/cursor-src
git -C ~/.config/matugen/cursor-src apply ~/.config/matugen/cursor-src.patch
```

**Key display widget.** `keywatch.py` reads from `/dev/input`, so your username has to be in the `input` group. Log out and back in afterwards: 
NOTE : this is a security risk 

```bash
sudo usermod -aG input "$USER"
```

**Hyprland plugins** (through `hyprpm`):

```bash
hyprpm update
hyprpm add https://github.com/VirtCode/hypr-dynamic-cursors
hyprpm enable dynamic-cursors
```

**Quickshell plugin.** The bar uses a small C++/Qt6 plugin (Blobs). You'll need `cmake`, `ninja`, `qt6-base`, `qt6-declarative` and `qt6-shadertools`, then:

```bash
cmake -S ~/dotfiles/quickshell/plugin -B ~/dotfiles/quickshell/plugin/build -G Ninja
cmake --build ~/dotfiles/quickshell/plugin/build
cmake --install ~/dotfiles/quickshell/plugin/build --prefix ~/.local
```

The bar starts through `quickshell/.config/quickshell/qs.sh`, which adds `~/.local/lib/qml` to `QML_IMPORT_PATH`. That's where quickshell looks for the plugin you just built.

## How it works

Pick a wallpaper with `walset`. That runs matugen, which regenerates every colour file listed in `matugen/.config/matugen/config.toml`, then reloads the apps that need a nudge.

The bar's colours go through `tame-colors` (in `bin/`), which caps the lightness so bright wallpapers don't blind you.

The generated colour files (the Neovim and Vesktop ones) aren't in git. Matugen creates them on its first run.

### Using waywallen

I use [waywallen](https://github.com/waywallen/waywallen) as my wallpaper manager, and it has no "run a command when the wallpaper changes" hook. So I wrote a small watcher: `waywallen-themer` (in `bin/`) checks waywallen's config every couple of seconds, looks up the new wallpaper in its database, and hands the image to `walset-backend`.

- Video, scene and web wallpapers use waywallen's preview image.
- GIFs and animated WebPs use their first frame, since matugen needs a still image.

It needs `sqlite` and `imagemagick` installed. Turn it on with:

```bash
systemctl --user enable --now waywallen-themer.service
```

If theming ever stops working, check what the service says:

```bash
journalctl --user -u waywallen-themer -n 40
```

One thing I learned the hard way: matugen asks you to choose a colour when an image has several strong ones, and under systemd there's no terminal to ask on, so it just fails. `walset-backend` passes `--prefer saturation` so it picks one by itself.

## Terminal colours

Kitty's colours come from [pywal](https://github.com/dylanaraps/pywal), because its palette looks better in a terminal than matugen's. `wal-tune` (in `bin/`) then lifts any colours that are too dim to read, keeping pywal's hues and never touching the background. Matugen still themes everything else.

`cat` doesn't highlight syntax, so I alias it to [bat](https://github.com/sharkdp/bat), which uses the terminal's own colours (add this to your zsh config):

    export BAT_THEME=ansi
    alias cat='bat --style=plain --paging=never'

## Credits

The Blobs plugin in `quickshell/plugin` comes from [Caelestia](https://github.com/caelestia-dots). The cursor recolouring builds on [rtgiskard/bibata_cursor](https://github.com/rtgiskard/bibata_cursor), and none of this would exist without [matugen](https://github.com/InioX/matugen).

Take whatever's useful. If something breaks, open an issue and I'll have a look.
