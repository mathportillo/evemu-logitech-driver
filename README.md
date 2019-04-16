# wayland-mouse-mapper
A small script for mapping mouse buttons to keystrokes on Wayland.

I made for myself to use my mouse extra buttons for useful stuff.
It's tested and works with Logitech MX Master 2S on Fedora 27 using Gnome,
and works it on my old Logitech Performance MX too.
It probably works on any Wayland and Any Logitech mouse (or any mouse if you edit mappings)
because no other method (xdotools, xbindkeys, etc.) seemed to work.

It works by reading from `libinput debug-events` and triggering key events using `evemu`
depending on the recognized button from the recognized device.

Feel free to make PRs to make it configurable or to add more mappings

## Buttons
These are just the default settings, you can customize them at the start of the mousemapper.sh script.

- Forward: Move to workspace above  (Super+Page up)
- Back: Move to workspace below  (Super+Page down)

Note, they will still trigger mouse events, to disable those use xmodmap https://unix.stackexchange.com/a/20595/38213

## Prerequisites
The script depends on the following executables being available in your PATH:
- libinput
- evemu

to install those just run the following command (with root privileges):
```
dnf -y install libinput evemu
```

## Usage
Run the following command (with root privileges):
```
./mousemapper.sh
```

## Installation (start at boot)
Run the following commands (with root privileges):
```
cp mousemapper.sh /usr/bin/mousemapper
cp mousemapper.service /usr/lib/systemd/system/
systemctl enable mousemapper.service
```
