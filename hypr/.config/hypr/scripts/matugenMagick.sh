#!/usr/bin/env bash
#  ┳┳┓┏┓┏┳┓┳┳┏┓┏┓┳┓  ┳┳┓┏┓┏┓┳┏┓┓┏┓
#  ┃┃┃┣┫ ┃ ┃┃┃┓┣ ┃┃━━┃┃┃┣┫┃┓┃┃ ┃┫ 
#  ┛ ┗┛┗ ┻ ┗┛┗┛┗┛┛┗  ┛ ┗┛┗┗┛┻┗┛┛┗┛
#                                 




# utility vars
cache_dir="$HOME/.cache/swww/"
current_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
cache_file="$cache_dir$current_monitor"
wallpaper_path=$(grep -v 'Lanczos3' "$cache_file" | head -n 1)

if [ "$1" == "--light" ]; then
  matugen image "$wallpaper_path" -m "light"
else
  matugen image "$wallpaper_path" -m "dark"
fi 

gsettings set org.gnome.desktop.interface gtk-theme ""
gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3

# imagemagick
wait $!

# rofi bg, blurred
 magick "$wallpaper_path" -strip -resize 1000 -gravity center -extent 1000 -blur "30x30" -quality 90 $HOME/.config/rofi/images/currentWalBlur.thumb

# rofi bg, no blur
magick "$wallpaper_path" -strip -resize 1000 -gravity center -extent 1000 -quality 90 $HOME/.config/rofi/images/currentWal.thumb

# square version
magick "$wallpaper_path" -strip -thumbnail 500x500^ -gravity center -extent 500x500 $HOME/.config/rofi/images/currentWal.sqre

# square + polygon
magick $HOME/.config/rofi/images/currentWal.sqre \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" -fill black -draw "polygon 500,500 500,0 450,500" \) -alpha Off -compose CopyOpacity -composite $HOME/.config/rofi/images/currentWalQuad.png && mv $HOME/.config/rofi/images/currentWalQuad.png $HOME/.config/rofi/images/currentWalQuad.quad


wait $!
ln -sf "$wallpaper_path" "$HOME/.local/share/bg"

wait $!
notify-send -e -h string:x-canonical-private-synchronous:matugen_notif "MatugenMagick" "Matugen & ImageMagick has completed its job" -i $HOME/.local/share/bg
