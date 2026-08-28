-- https://wiki.hypr.land/Configuration/Basics/Autostart/
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- qs -c signal-rail")
  hl.exec_cmd("uwsm app -- hyprpaper")
  hl.exec_cmd("uwsm app -- walker --gapplication-service")
  hl.exec_cmd("uwsm app -- swayosd-server")

  -- GTK Theme
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Dark-Dracula'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name 'MesloLGSDZ Nerd Font Mono 12'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Colloid-Dracula-Dark'")
end)
