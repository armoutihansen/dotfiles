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

from custom import tile
from custom.widgets import *
from libqtile import layout, bar, widget, hook, extension
from libqtile.lazy import lazy
from libqtile.config import Screen, Group, EzDrag, EzClick, EzKey, ScratchPad, DropDown
from subprocess import Popen, check_output, run
import subprocess
import os
from typing import List  # noqa: F401
import psutil
import time
import numpy as np
np.add_newdoc

try:
    import xrp
except ImportError:
    xrp = None

# import libqtile

# ##### STANDARD APPS ######
MyTerm = os.environ["TERMINAL"]
MyBrowser = os.environ["BROWSER"]
MyEditor = MyTerm + ' -e ' + os.environ["EDITOR"]
MyReader = MyTerm + ' -e ' + os.environ["READER"]
MyFileManager = MyTerm + ' -e lf'
MyEmacs = "emacsclient -c -a ''"
MyDired = "emacsclient -c -a '' --eval '(dired nil)'"
MyEmail = MyTerm + ' -e neomutt'
MyVolume = MyTerm + ' -e pamixer'
MyCalender = MyTerm + ' -e calcurse'
MyContacts = MyTerm + ' -e abooklaunch'
MyNewsReader = MyTerm + ' -e newsboat'


@lazy.function
def tog_full(qtile):
    if qtile.current_layout.name != 'max':
        qtile.cmd_hide_show_bar()
        qtile.cmd_to_layout_index(1)
    else:
        qtile.cmd_hide_show_bar()
        qtile.cmd_to_layout_index(0)


@lazy.function
def tog_max(qtile):
    if qtile.current_layout.name != 'max':
        qtile.cmd_to_layout_index(1)
    else:
        qtile.cmd_to_layout_index(0)

# @lazy.function
# def make_sticky(qtile, *args):
#     window = qtile.current_window
#     screen = qtile.current_screen.index
#     window.static(
#         screen,
#         window.x,
#         window.y,
#         window.width,
#         window.height
#     )


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

Sep = widget.TextBox(text="  ", background=colors[0])

# ##### KEYBINDINGS ###########
keys = [
    # Basics
    EzKey("M-q", lazy.window.kill(), desc="jj"),
    EzKey("M-S-q", lazy.spawn('xkill')),
    EzKey("M-<Tab>", lazy.next_layout()),
    EzKey("M-C-r", lazy.restart()),
    EzKey("M-C-q", lazy.shutdown()),
    EzKey("M-b", lazy.hide_show_bar()),
    # EzKey("M-f", lazy.window.toggle_fullscreen()),
    EzKey("M-f", tog_full),
    EzKey("M-A-f", lazy.window.toggle_floating()),
    EzKey("M-S-f", tog_max),
    EzKey("M-A-n", lazy.window.toggle_normalize()),

    # Switch between windows
    EzKey("M-j", lazy.layout.down()),
    EzKey("M-k", lazy.layout.up()),
    # EzKey("M-s", make_sticky),

    # Move windows
    EzKey("M-S-j", lazy.layout.shuffle_down()),
    EzKey("M-S-k", lazy.layout.shuffle_up()),

    # Flip windows
    EzKey("M-A-j", lazy.layout.decrease_nmaster()),
    EzKey("M-A-k", lazy.layout.increase_nmaster()),

    # Increase window size
    EzKey("M-h", lazy.layout.decrease_ratio()),
    EzKey("M-l", lazy.layout.increase_ratio()),

    # Volume control
    EzKey(
        "M-<Up>", lazy.function(lambda qtile: qtile.widgets_map['volume'].command_up())),
    EzKey("M-<Down>",
          lazy.function(lambda qtile: qtile.widgets_map['volume'].command_down())),
    EzKey(
        "M-S-m", lazy.function(lambda qtile: qtile.widgets_map['volume'].command_toggle_mute())),
    EzKey("<XF86AudioRaiseVolume>", lazy.function(
        lambda qtile: qtile.widgets_map['volume'].command_up())),
    EzKey("<XF86AudioLowerVolume>", lazy.function(
        lambda qtile: qtile.widgets_map['volume'].command_down())),
    EzKey("<XF86AudioMute>", lazy.function(
        lambda qtile: qtile.widgets_map['volume'].command_toggle_mute())),

    # Applications
    EzKey("M-<Return>", lazy.spawn(MyTerm)),
    EzKey("M-e", lazy.spawn(MyEmail)),
    EzKey("M-S-e", lazy.spawn(MyContacts)),
    EzKey("M-r", lazy.spawn(MyFileManager)),
    EzKey("M-S-r", lazy.spawn(MyDired)),
    EzKey("M-w", lazy.spawn(MyBrowser)),
    EzKey("M-c", lazy.spawn(MyCalender + ' -D /home/jah/.config/calcurse')),
    EzKey("M-A-r", lazy.spawn(MyTerm + ' -e htop')),
    EzKey("M-S-w", lazy.spawn(MyTerm + ' -e sudo nmtui')),
    EzKey("M-v", lazy.spawn(MyEditor)),
    EzKey("M-S-v", lazy.spawn(MyEmacs)),
    EzKey("M-n", lazy.spawn(MyEditor + ' -c VimwikiIndex')),
    EzKey("M-S-n", lazy.spawn(MyNewsReader)),
    EzKey("M-m", lazy.spawn(MyTerm + ' -e ncmpcpp')),
    EzKey("A-S-<space>",
          lazy.function(lambda qtile: qtile.widgets_map['keyboard'].command_toggle())),

    # Clipboard
    EzKey('<Insert>', lazy.function(lambda qtile: Popen(
        ['notify-send "📋 Clipboard contents:" "$(xclip -o -selection clipboard)"'], shell=True))),


    # MPC''''''''''
    EzKey("<XF86AudioPrev>", lazy.spawn("mpc prev"),
          lazy.function(lambda qtile: qtile.widgets_map['Music'].tick())),
    EzKey("<XF86AudioNext>", lazy.spawn("mpc next"),
          lazy.function(lambda qtile: qtile.widgets_map['Music'].tick())),
    EzKey("<XF86AudioPlay>", lazy.spawn("mpc toggle"),
          lazy.function(lambda qtile: qtile.widgets_map['Music'].tick())),
    EzKey("<XF86AudioPause>", lazy.spawn("mpc pause"),
          lazy.function(lambda qtile: qtile.widgets_map['Music'].tick())),
    EzKey("<XF86AudioStop>", lazy.spawn("mpc stop"),
          lazy.function(lambda qtile: qtile.widgets_map['Music'].tick())),
    EzKey("M-S-s", lazy.spawn("mpc stop"),
          lazy.function(lambda qtile: qtile.widgets_map['Music'].tick())),
    EzKey("<XF86AudioRewind>", lazy.spawn("mpc seek -10")),
    EzKey("<XF86AudioForward>", lazy.spawn("mpc seek +10")),

    # Brightness
    EzKey("<XF86MonBrightnessUp>", lazy.function(
        lambda qtile: qtile.widgets_map['brightness'].command_up())),
    EzKey("<XF86MonBrightnessDown>", lazy.function(
        lambda qtile: qtile.widgets_map['brightness'].command_down())),

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


    EzKey("M-A-l", lazy.function(lambda qtile: Popen(
        ['groff -mom /usr/local/share/dwm/larbs.mom -Tpdf | zathura -'], shell=True))),

    # dmenu scripts
    EzKey("M-d", lazy.run_extension(extension.DmenuRun(
        dmenu_prompt="Run: ",
    ))),
    EzKey("M-A-w", lazy.run_extension(extension.WindowList(
        item_format="{group}: {window}",
        dmenu_lines=None)),
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
    EzKey("M-S-<Return>", lazy.group['scratchpad'].dropdown_toggle("term")),
    EzKey("M-A-<Return>", lazy.group['scratchpad'].dropdown_toggle("qshell")),
]

# groups = [Group(i) for i in "123456789"]
scratchpad = [ScratchPad(
    "scratchpad",
    [
        DropDown("term", MyTerm, height=0.6, width=0.6, x=0.2, y=0.2),
        DropDown("qshell", MyTerm + " -e python", opacity=0.8,
                 height=0.6, width=0.6, x=0.2, y=0.2)
    ]
)]
norm_groups = [Group(i) for i in "123456789"]
groups = scratchpad + norm_groups

for i in groups[1:]:
    keys.extend([
        EzKey("M-%s" % i.name, lazy.group[i.name].toscreen(toggle=True)),
        EzKey("M-S-%s" % i.name, lazy.window.togroup(i.name, switch_group=True)),
    ])

##### DEFAULT THEME SETTINGS FOR LAYOUTS #####
layout_theme = {"border_width": 3,
                "margin": 15,
                "border_focus": colors[4],
                "border_normal": colors[0]
                }


layouts = [
    tile.Tile(ratio=0.5, add_on_top=False, add_after_last=True,
              shift_windows=True, single_border_width=0, single_margin=4, **layout_theme),
    layout.Max(**layout_theme),
    layout.TreeTab(
        font=font,
        fontsize=fontsize,
        sections=["1", "2"],
        section_fontsize=12,
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
    foreground=colors[8]
)
if dpi > 96:
    bar_height = int((30*dpi/96)/1.5)
else:
    bar_height = 30

extension_defaults = dict(
    dmenu_height=42,
    dmenu_font=font + '-' + str(dmenu_fontsize))


def myinternet():
    output = check_output('internet', shell=True).decode().replace('\n', '')
    return output


arrow_fontsize = 100


def arrow(background, foreground):
    return widget.TextBox(
        font="FontAwesome",
        text='',
        background=background,
        foreground=foreground,
        padding=0,
        fontsize=arrow_fontsize,
        fontshadow=colors[8]
    )


def ethernet():
    output = check_output('internet', shell=True).decode().strip('\n')
    return output


def init_widgets():
    widgets = [
        widget.TextBox(
            text=" ",
            fontsize=28,
            padding=6,
            background=colors[4],
            foreground=colors[0],
            mouse_callbacks={
                'Button1': lambda qtile: qtile.cmd_spawn('xmenu.sh')
            }
        ),
        widget.TextBox(
            font="FontAwesome",
            text=" ",
            background=colors[0],
            foreground=colors[4],
            padding=0,
            fontsize=50
        ),
        # Sep,
        widget.GroupBox(
            block_highlight_text_color=colors[0],
            highlight_method='block',
            rounded=True,
            padding=3,
            active=colors[4],
            this_current_screen_border=colors[4],
            # this_screen_border=colors[0],
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
            foreground=colors[4],
            padding=10
        ),
        widget.Sep(
            linewidth=0,
            padding=15,
        ),
        # arrow(colors[7], colors[1]),
        mail.Mail(maildir='/home/jah/.local/share/mail',
                  background=colors[0], foreground=colors[1]),
        Sep,
        # arrow(colors[1], colors[2]),
        pacman.Pacman(background=colors[0], foreground=colors[2]),
        Sep,
        # arrow(colors[2], colors[3]),
        newsboat.Newsboat(background=colors[0], foreground=colors[3]),
        Sep,
        # arrow(colors[3], colors[4]),
        wttr.wttr(location="Cologne",
                  background=colors[0], foreground=colors[4]),
        Sep,
        # arrow(colors[4], colors[5]),
        disk.Disk(background=colors[0], foreground=colors[5]),
        cpu.CPU(background=colors[0], foreground=colors[5], padding=10),
        memory.Memory(background=colors[0], foreground=colors[5]),
        Sep,
        # arrow(colors[5], colors[6]),
        volume.Volume(xob='/tmp/xobpipe',
                      background=colors[0], foreground=colors[6]),
        keyboard.Keyboard(
            background=colors[0], foreground=colors[6], padding=10),
        Sep,
        # arrow(colors[6], colors[7]),
        # arrow(colors[7], colors[1]),
        Sep,
        clock.Clock(background=colors[0], foreground=colors[2]),
        Sep,
        widget.TextBox(
            font="FontAwesome",
            text="",
            background=colors[0],
            foreground=colors[4],
            padding=0,
            fontsize=50
        ),
        # arrow(colors[0], colors[4]),
        widget.Systray(icon_size=20, padding=10, background=colors[4]),
        widget.Sep(
            padding=10,
            linewidth=0,
            background=colors[4]
        )
    ]
    if len([i for i in os.listdir('/sys/class/net') if i.startswith('e')]) > 0:
        widgets.insert(-6, widget.GenPollText(
            background=colors[0],
            foreground=colors[6],
            name='Ethernet',
            func=ethernet,
            update_interval=10,
            mouse_callbacks={
                "Button1": lambda qtile: qtile.cmd_spawn(MyTerm + ' -e nmtui'),
                "Button3": lambda qtile: qtile.cmd_spawn('notify-send "Internet module" "\- Click to connect"')
            }
        ))
    else:
        # widgets.insert(-3, Sep)
        widgets.insert(-6, internet.Internet(interface="wlp2s0",
                                             background=colors[0], foreground=colors[1], padding=10))

    if os.path.isdir('/proc/driver/nvidia'):
        widgets.insert(-10,
                       gpumem.GPU(background=colors[0], foreground=colors[5], padding=10))

    if len([i for i in os.listdir('/sys/class/power_supply') if i.startswith('BAT')]) > 0:
        widgets.insert(-8,
                       battery.Battery(background=colors[0], foreground=colors[6]))
    if os.path.isdir('/sys/class/backlight/intel_backlight'):
        widgets.insert(-10, brightness.Brightness(xob='/tmp/xobpipe',
                                                  background=colors[0], foreground=colors[6], padding=10))
    # if check_output(['cat /proc/acpi/bbswitch'], shell=True).decode().split('\n')[0].split(' ')[1] == 'ON':
    #     widgets.insert(-12, GPU(
    #                 format='🎮 {MemUsed}M/{MemTotal}M - {Temp}°C |',
    #                 mouse_callbacks={
    #                     'Button1': lambda qtile: qtile.cmd_spawn('st -e nvtop'),
    #                     # 'Button2': lambda qtile: qtile.cmd_run_external('/home/jah/.config/qtile/not.py')
    #                     'Button2': lambda qtile: qtile.cmd_spawn('/home/jah/.config/qtile/not')
    #                 },
    #                 padding=15
    #             ))
    #     widgets.insert(-12, sep)
    return widgets


my_widgets = init_widgets()

screens = [
    Screen(
        top=bar.Bar(my_widgets, 38,
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
    {'wmclass': 'matplotlib'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

no_swallow = {
    'wmclass': ["matplotlib"],
    'wmname': ["Figure 1"]
}


# Window swallowing
@ hook.subscribe.client_new
def _swallow(window):
    # if window.window.get_wm_class()[0] != "matplotlib":
    if window.window.get_wm_class()[0] not in no_swallow['wmclass'] and window.name not in no_swallow['wmname']:
        pid = window.window.get_net_wm_pid()
        ppid = psutil.Process(pid).ppid()
        if psutil.Process(ppid).name() != "emacs":
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
    # if window.window.get_wm_class()[0] not in no_swallow['wmclass'] and window.name not in no_swallow['wmname']:
    # if window.window.get_wm_class()[0] != "matplotlib":
    if hasattr(window, 'parent'):
        window.parent.minimized = False
        window.parent.focus


@ hook.subscribe.client_killed
def client_killed(c):
    if c.name == "neomutt":
        c.qtile.widgets_map['mail'].tick()
    elif c.name == "newsboat":
        c.qtile.widgets_map['newsboat'].tick()
    elif c.name == "yay":
        c.qtile.widgets_map['pacman'].tick()
        # libqtile.qtile.widgets_map['mail'].tick()
        # libqtile.qtile.widgets_map['newsboat'].tick()
    # elif c.name == "newsboat":
    #     libqtile.qtile.widgets_map['newsboat'].tick()
    # elif c.name == "yay" or "popupgrade":
        # libqtile.qtile.widgets_map['pacman'].tick()
#     elif c.name == "nmtui":
#         libqtile.qtile.windows_map['internet'].tick()


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "qtile"
