# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
# Copyright (c) 2020 Jesper Armouti-Hansen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from subprocess import Popen, check_output
import os
from typing import List  # noqa: F401
import psutil

try:
    import xrp
except ImportError:
    xrp = None

from libqtile.config import Screen, Group, EzDrag, EzClick, EzKey
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook, extension
import libqtile

from custom.widgets.wttr import wttr
from custom.widgets.GPU import GPU

# ##### STANDARD APPS ######
MyTerm = os.environ["TERMINAL"]
MyBrowser = os.environ["BROWSER"]
MyEditor = MyTerm + ' -e ' + os.environ["EDITOR"]
MyReader = MyTerm + ' -e ' + os.environ["READER"]
MyFileManager = MyTerm + ' -e ranger'
MyEmacs = "emacsclient -c -a ''"
MyEmail = MyTerm + ' -e neomutt'
MyVolume = MyTerm + ' -e pamixer'
MyCalender = MyTerm + ' -e calcurse'
MyContacts = MyTerm + ' -e abooklaunch'
MyNewsReader = MyTerm + ' -e newsboat'


# ##### COLORS AND FONTS #####
if xrp:
    xr = xrp.parse_file(os.environ['XDG_CONFIG_HOME']+'/Xresources', 'utf-8')
    colors = [xr.resources['*.color{}'.format(i)] for i in range(9)]
    fonts = xr.resources['*.font']
    font, fontsize = fonts.split(':')[0], int(fonts.split('=')[-1])
    dmenu_fontsize = fontsize
    try:
        dpi = int(xr.resources['Xft.dpi'])
        fontsize = int(dpi*1.2/96 * fontsize)
    except KeyError:
        dpi = None
else:
    colors = [["#292d3e", "#292d3e"],  # panel background
              ["#f07178", "#f07178"],
              ["#c3e88d", "#c3e88d"],
              ["#ffcb6b", "#ffcb6b"],
              ["#82aaff", "#82aaff"],
              ["#c792ea", "#c792ea"],
              ["#89ddff", "#89ddff"],
              ["#d0d0d0", "#d0d0d0"]]
    font = 'mono'
    fontsize = 14

# ##### KEYBINDINGS ###########
keys = [
    # Basics
    EzKey("M-q", lazy.window.kill(), desc="jj"),
    EzKey("M-S-q", lazy.spawn('xkill')),
    EzKey("M-<Tab>", lazy.next_layout()),
    EzKey("M-C-r", lazy.restart()),
    EzKey("M-C-q", lazy.shutdown()),
    EzKey("M-b", lazy.hide_show_bar()),
    EzKey("M-f", lazy.window.toggle_maximize()),
    EzKey("M-S-f", lazy.window.toggle_floating()),

    # Switch between windows
    EzKey("M-j", lazy.layout.up()),
    EzKey("M-k", lazy.layout.down()),

    # Move windows
    EzKey("M-S-j", lazy.layout.shuffle_up()),
    EzKey("M-S-k", lazy.layout.shuffle_down()),

    # Flip windows
    EzKey("M-A-j", lazy.layout.flip_up()),
    EzKey("M-A-k", lazy.layout.flip_down()),

    # Increase window size
    EzKey("M-h", lazy.layout.grow()),
    EzKey("M-l", lazy.layout.shrink()),

    # Volume control
    EzKey("M-<Up>", lazy.spawn("pamixer -i 5")),
    EzKey("M-<Down>", lazy.spawn("pamixer -d 5")),
    EzKey("<XF86AudioRaiseVolume>", lazy.spawn("pamixer -i 5")),
    EzKey("<XF86AudioLowerVolume>", lazy.spawn("pamixer -d 5")),
    EzKey("M-S-m", lazy.spawn("pamixer -t")),
    EzKey("<XF86AudioMute>", lazy.spawn("pamixer -t")),

    # Applications
    EzKey("M-<Return>", lazy.spawn(MyTerm)),
    EzKey("M-e", lazy.spawn(MyEmail)),
    EzKey("M-S-e", lazy.spawn(MyContacts)),
    EzKey("M-r", lazy.spawn(MyFileManager)),
    EzKey("M-w", lazy.spawn(MyBrowser)),
    EzKey("M-c", lazy.spawn(MyCalender + ' -D /home/jah/.config/calcurse')),
    EzKey("M-S-r", lazy.spawn(MyTerm + ' -e htop')),
    EzKey("M-S-w", lazy.spawn(MyTerm + ' -e sudo nmtui')),
    EzKey("M-v", lazy.spawn(MyEditor)),
    EzKey("M-S-v", lazy.spawn(MyEmacs)),
    EzKey("M-n", lazy.spawn(MyEditor + ' -c VimwikiIndex')),
    EzKey("M-S-n", lazy.spawn(MyNewsReader)),
    EzKey("M-m", lazy.spawn(MyTerm + ' -e ncmpcpp')),

    # Clipboard
    EzKey('<Insert>', lazy.function(lambda qtile: Popen(['notify-send "📋 Clipboard contents:" "$(xclip -o -selection clipboard)"'], shell=True))),


    # MPC
    EzKey("<XF86AudioPrev>", lazy.spawn("mpc prev")),
    EzKey("<XF86AudioNext>", lazy.spawn("mpc next")),
    EzKey("<XF86AudioPlay>", lazy.spawn("mpc toggle")),
    EzKey("<XF86AudioPause>", lazy.spawn("mpc pause")),
    EzKey("<XF86AudioStop>", lazy.spawn("mpc stop")),
    EzKey("M-S-s", lazy.spawn("mpc stop")),
    EzKey("<XF86AudioRewind>", lazy.spawn("mpc seek -10")),
    EzKey("<XF86AudioForward>", lazy.spawn("mpc seek +10")),

    # Brightness
    EzKey("<XF86MonBrightnessUp>", lazy.spawn("xbacklight -inc 5")),
    EzKey("<XF86MonBrightnessDown>", lazy.spawn("xbacklight -dec 5")),

    # Screenshots
    EzKey("<Print>", lazy.run_extension(extension.CommandSet(
        commands={
            'a selected area': 'maim -s pic-selected-"$(date "+%y%m%d-%H%M-%S").png"',
            'current window': 'maim -i "$(xdotool getactivewindow)" pic-window-"$(date "+%y%m%d-%H%M-%S").png"',
            'full screen': 'maim pic-full-"$(date "+%y%m%d-%H%M-%S").png"',
            'a selected area (copy)': 'maim -s | xclip -selection clipboard -t image/png',
            'current window (copy)': 'maim i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png',
            'full screen (copy)': 'maim | xclip -selection clipboard -t image/png',
        },
        dmenu_prompt="Take screenshot"))),


    EzKey("M-l", lazy.function(lambda qtile: Popen(['groff -mom /usr/local/share/dwm/larbs.mom -Tpdf | zathura -'], shell=True))),

    # dmenu scripts
    EzKey("M-d", lazy.run_extension(extension.DmenuRun(
        dmenu_prompt="Run: ",
    ))),
    EzKey("M-A-w", lazy.run_extension(extension.WindowList(
        item_format="{group}: {window}")),
        desc='window list'),
    EzKey("M-<BackSpace>", lazy.run_extension(extension.CommandSet(
        commands={
            ' lock': 'slock',
            ' suspend': 'systemctl suspend && slock',
            ' restart': 'reboot',
            ' shutdown': 'systemctl poweroff',
            ' logout': 'qtile-cmd -o cmd -f shutdown',
            ' reload': 'qtile-cmd -o cmd -f restart',
        }))),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        EzKey("M-%s" % i.name, lazy.group[i.name].toscreen(toggle=True)),
        EzKey("M-S-%s" % i.name, lazy.window.togroup(i.name, switch_group=True)),
    ])

##### DEFAULT THEME SETTINGS FOR LAYOUTS #####
layout_theme = {"border_width": 2,
                "margin": 15,
                "border_focus": "d0d0d0",
                "border_normal": "292d3e"
                }


layouts = [
    layout.MonadTall(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.Tile(shift_windows=True, **layout_theme),
    layout.Max(**layout_theme),
    layout.TreeTab(
        font="mono",
        fontsize=10,
        sections=["FIRST", "SECOND"],
        section_fontsize=11,
        bg_color="141414",
        active_bg="90C435",
        active_fg="000000",
        inactive_bg="384323",
        inactive_fg="a0a0a0",
        padding_y=5,
        section_top=10,
        panel_width=320
    ),
   layout.Floating(**layout_theme),
]



widget_defaults = dict(
    font=font,
    fontsize=fontsize,
    padding=2,
    background=colors[0],
    foreground=colors[7]
)
if dpi:
    bar_height = int((30*dpi/96)/1.5)
else:
    bar_height = 30

extension_defaults = dict(
    dmenu_height=bar_height,
    dmenu_font=font + '-' + str(dmenu_fontsize))

def mynewsboat():
    unread = os.popen('newsboat -x print-unread').read().split()[0]
    if int(unread) > 0:
        # subprocess.check_output(
            # ['notify-send "📰 Newsboat" "{} unread articles"'.format(unread)], shell=True)
        string = '📰 ' + unread + ' |'
    else:
        string = ""
    return string

def myinternet():
    internet = os.popen('cat /sys/class/net/w*/operstate 2>/dev/null').read().split('\n')[0]
    if internet == 'up':
        string="🌍 "
    else:
        string="❎ "
    return string

# check whether gpu in use: >>> subprocess.check_output(['cat /proc/acpi/bbswitch'], shell=True).decode().split('\n')[0].split(' ')[1]

spacer = widget.Sep(
        linewidth=0,
        padding=5
        )

def init_widgets():
    widgets = [
                widget.TextBox(
                    text="",
                    padding=10,
                    mouse_callbacks={
                        'Button1': lambda qtile: qtile.cmd_spawn('xmenu.sh')
                    }
                ),
                widget.GroupBox(
                    block_highlight_text_color=colors[0],
                    highlight_method='block',
                    rounded=False,
                    padding=5,
                    this_current_screen_border=colors[4],
                    hide_unused=True
                ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[
                        os.path.expanduser("~/.config/qtile/layout-icons")],
                    scale=0.7,
                    padding=5,
                ),
                widget.Prompt(),  # ! Do something
                widget.WindowName(
                    background=colors[4],
                    foreground=colors[0],
                    padding=10
                ),
                widget.Sep(
                    linewidth=0,
                    padding=15,
                ),
                widget.Mpd2(
                    idle_format="",
                    status_format='{play_status} {artist}/{title} [{repeat}{random}{single}{consume}{updating_db}] |'
                    ),
                spacer,
                widget.Maildir(
                    maildir_path='~/.local/share/mail/',
                    sub_folders=[
                        {"path": "armouti-hansen/INBOX", "label": '📫'},
                        {"path": "uni/INBOX", "label": '2'},
                        {"path": "jesper/INBOX", "label": '3'},
                        {"path": "jeshan49/INBOX", "label": '4'}],
                    subfolder_fmt='{label} {value} |',
                    total=True,
                    update_interval=180,
                    hide_when_empty=True,
                    mouse_callbacks={
                        'Button1': lambda qtile: qtile.cmd_spawn(MyEmail),
                        'Button2': lambda qtile: qtile.widgets_map['maildir'].tick(),
                        'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  Mail module" "\n\- Shows unread email\n\- Left click opens neomutt\n\-Middle click sync mail"')},
                ),
                spacer,
                widget.CheckUpdates(
                    distro='Arch_yay',
                    display_format='📦 {updates} |',
                    execute=MyTerm + ' -e yay -Syu',
                    update_interval=3600,
                    mouse_callbacks={
                        'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  Upgrade module" "\n📦: number of upgradable packages \n- Left click to upgrade packages \n- Middle click to show upgradable packages"'),
                        'Button2': lambda qtile: check_output(['notify-send "$(/usr/bin/pacman -Qu)"'], shell=True)
                        # 'Button2': ns('notify-send "$(/usr/bin/pacman -Qu)"')
                    },
                ),
                spacer,
                widget.GenPollText(
                    name="Newsboat",
                    func=mynewsboat,
                    update_interval=3600,
                    mouse_callbacks={
                        'Button1': lambda qtile: qtile.cmd_spawn(MyNewsReader),
                        'Button2': lambda qtile: qtile.widgets_map['newsboat'].tick(),
                        'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  News module" "\n\- Click to open newsboat\n\- Middle click to update feed"')},
                ),
                spacer,
                wttr(
                    format='⛅ {Temp} {Temp_measure} 🌧 {Rain} {Rain_measure}|{Rain_chance} 🍃 {Wind} {Wind_measure} |',
                    mouse_callbacks={
                        'Button1': lambda qtile: qtile.cmd_spawn(MyTerm + ' -e less -Srf /home/jah/.local/share/weatherreport'),
                        'Button2': lambda qtile: qtile.widget_map['wttr'].tick(),
                        'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  Weather module" "\- Left click for full forecast.\n\- Middle click to update forecast.\n\n⛅: Current temperaure\n🌧: Amount and chance of rain\n🍃: Wind."')
                    },
                ),
                spacer,
                widget.DF(
                    format='🏠 {f}{m}|{r:.0f}% |',
                    visible_on_warn=False,
                    update_interval=300,
                    mouse_callbacks={
                        'Button1': lambda qtile: Popen(['notify-send "Disk space " "$(df -h --output=target,used,size)"'], shell=True),
                        'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  Disk module" "\n\- Click to check usage"')
                        }
                ),
                # widget.Sep(
                #     linewidth=0,
                #     padding=5,
                # ),
                # widget.DF(
                #     partition='/data',
                #     format='{p}: {f}{m}|{r:.0f}%',
                #     visible_on_warn=False
                # ),
                # widget.Sep(
                    # linewidth=0,
                    # padding=15,
                # ),
                spacer,
                widget.CPU(
                    format='💻 {freq_current}GHz|{load_percent}% - ',
                    update_interval=10.0,
                    mouse_callbacks={
                        'Button1': lambda qtile: check_output(['notify-send "  CPU hogs" "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head)"'], shell=True),
                        'Button2': lambda qtile: qtile.cmd_spawn(MyTerm + ' -e htop'),
                        'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  CPU module" "\n\- Shows CPU fequency, load percentage and temperature\n\- Left click to show CPU hogs\n\- Middle click to open htop"')
                    }
                ),
                # widget.TextBox(
                #     text="🌡",
                #     padding=-3
                # ),
                widget.ThermalSensor(
                    foreground=colors[7],
                    update_interval=10,
                    fmt='{} |'
                ),
                spacer,
                widget.Memory(
                        update_interval=10,
                        format='🧠 {MemUsed}M/{MemTotal}M |',
                    mouse_callbacks={
                        'Button1': lambda qtile: check_output(['notify-send "  Memory hogs" "$(ps axch -o cmd:15,%mem --sort=-%mem | head)"'], shell=True),
                        'Button2': lambda qtile: qtile.cmd_spawn(MyTerm + ' -e htop'),
                        'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  Memory module" "\n\- Shows Memory Used/Total.\n\- Click to show memory hogs\n\- Middle click to open htop"')},
                ),
                spacer,
                widget.PulseVolume(
                    get_volume_command="pamixer --get-volume-human",
                    volume_up_command="pamixer -i 5",
                    volume_down_command="pamixer -d 5",
                    mute_command="pamixer -t",
                    emoji=True,
                    fmt="{}"
                ),
                widget.PulseVolume(
                    fmt="{} |"
                ),
                spacer,
                widget.Backlight(
                        backlight_name='intel_backlight',
                        change_command = 'xbacklight -set {0}',
                        format = '☀{percent: 2.0%} |'
                        ),
                spacer,
                widget.KeyboardLayout(
                    configured_keyboards=['de', 'dk'],
                    display_map={'de': '  de |', 'dk': '  dk |'},
                    options='compose:rctrl'
                ),
                spacer,
                widget.Battery(
                        discharge_char="🔋",
                        charge_char="🔌",
                        full_char="⚡",
                        unknown_char="🔌",
                        notify_below=0.2,
                        format='{char}{percent:2.0%}|{hour:d}:{min:02d} |',
                        show_short_text = False,
                        mouse_callbacks={
                            'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  Battery moule" "\n🔋: discharging\n🔌: charging\n⚡: fully charged"')
                            }
                        ),
                spacer,
                widget.Clock(
                        format='📅 %a %d/%m 🕛 %H:%M |',
                        mouse_callbacks={
                                 'Button1': lambda qtile: Popen(['notify-send "This Month" "$(cal -m)" && notify-send "Appointments" "$(calcurse -D /home/jah/.config/calcurse -d3)"'], shell=True),
                                 'Button2': lambda qtile: qtile.cmd_spawn(MyCalender + ' -D /home/jah/.config/calcurse'),
                                 'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  Time/date module" "\- Left click to show upcoming appointments and calender for the month.\n\- Middle click opens calcurse"')
                                 },
                        padding=15,
                        update_interval=60.0
                             ),
                widget.GenPollText(
                    name="Internet",
                    func=myinternet,
                    mouse_callbacks={
                        'Button1': lambda qtile: qtile.cmd_spawn(MyTerm + ' -e nmtui'),
                        'Button3': lambda qtile: qtile.cmd_spawn('notify-send "  Internet module" "\- Click to connect"')
                        }
                    ),
                widget.Systray(),
            ]
    if check_output(['cat /proc/acpi/bbswitch'], shell=True).decode().split('\n')[0].split(' ')[1] == 'ON':
        widgets.insert(-12, GPU(
                    format='🎮 {MemUsed}M/{MemTotal}M - {Temp}°C |',
                    mouse_callbacks={
                        'Button1': lambda qtile: qtile.cmd_spawn('st -e nvtop'),
                        # 'Button2': lambda qtile: qtile.cmd_run_external('/home/jah/.config/qtile/not.py')
                        'Button2': lambda qtile: qtile.cmd_spawn('/home/jah/.config/qtile/not')
                    },
                    padding=15
                ))
        widgets.insert(-12, spacer)
    return widgets

my_widgets = init_widgets()

screens = [
    Screen(
        top=bar.Bar(my_widgets, bar_height,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    EzDrag("M-1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    EzDrag("M-3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    EzClick("M-2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"


# Window swallowing
@ hook.subscribe.client_new
def _swallow(window):
    pid = window.window.get_net_wm_pid()
    ppid = psutil.Process(pid).ppid()
    cpids = {c.window.get_net_wm_pid(): wid for wid,
             c in window.qtile.windows_map.items()}
    for i in range(5):
        if not ppid:
            return
        if ppid in cpids:
            parent = window.qtile.windows_map.get(cpids[ppid])
            parent.minimized = True
            window.parent = parent
            return
        ppid = psutil.Process(ppid).ppid()


@ hook.subscribe.client_killed
def _unswallow(window):
    if hasattr(window, 'parent'):
        window.parent.minimized = False


@ hook.subscribe.client_killed
def client_killed(c):
    if c.name == "neomutt":
        libqtile.qtile.widgets_map['maildir'].tick()
    elif c.name == "newsboat":
        libqtile.qtile.widgets_map['Newsboat'].tick()
    elif c.name == "yay":
        libqtile.qtile.widgets_map['CheckUpdates'].tick()
    elif c.name == "nmtui":
        libqtile.qtile.windows_map['Internet'].tick()

def up_mail():
    libqtile.qtile.widgets_map['maildir'].tick()



# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "qtile"
