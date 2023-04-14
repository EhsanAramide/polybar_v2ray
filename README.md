## V2ray Polybar plugin
Simple and easy to use plugin for lazy v2ray VPN clients who use polybar.

### Installation

#### Requirements
- v2ray
- systemd (btw you can change from source code, you are lazy but it is easy)
- dunst notification daemon
- rofi

First of all copy `v2ray.service` to `~/.config/systemd/user/` directory. (if you use another service manager, write the service and copy it to any directory which is built for user services)

Then be neat and copy the plugin directory in `~/.config/polybar/plugins/` directory.

To register the plugin in your bar you can use `polybar_module.ini` sample.

You must keep your configs in `/etc/v2ray/configs/` directory, because plugin searches there.

I'm waiting for your contributions and ideas. Have fun. =)
