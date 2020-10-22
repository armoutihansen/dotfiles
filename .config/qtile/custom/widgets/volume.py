from libqtile.widget import base
from libqtile import bar
from libqtile.log_utils import logger
import os
import subprocess
import psutil


class Volume(base.ThreadedPollText):

    orientation = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("format", "{icon}{percent}", "format when unread articles"),
        ("update_interval", 86400.0, "update interval for the RSS feed"),
        ("xob", None, "xobpipe")
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(Volume.defaults)

        self.percent = ""

    def tick(self):
        self.update(self.poll())
        return self.update_interval

    def cmd_tick(self):
        self.tick()

    def poll(self):
        val = {}
        # if subprocess.check_output('echo $(pactl list sinks | grep -q "Mute: yes" && printf "M")', shell=True).decode().strip('\n') == "M":
        mute = subprocess.call('pamixer --get-mute', shell=True)
        # try:
        #     mute = bool(subprocess.check_output(['/usr/bin/pamixer', '--get-mute'], shell=True))
        # except:
            # mute = False
        if mute == 0:
            self.percent = 0
            val["icon"] = " "
            val["percent"] = ""
        else:
            self.percent = int(subprocess.check_output(['/usr/bin/pamixer', '--get-volume']).decode().strip('\n'))
            val["percent"] = str(self.percent) + "%"
            if self.percent > 70:
                val['icon'] = " "
            elif self.percent > 30:
                val["icon"] = " "
            else:
                val['icon'] = " "
        return self.format.format(**val)

    def command_up(self):
        self.qtile.cmd_spawn('pamixer -i 5')
        self.tick()
        if self.xob:
            subprocess.check_output(['echo {} > {}'.format(self.percent, self.xob)], shell=True)

    def command_down(self):
        self.qtile.cmd_spawn('pamixer -d 5')
        self.tick()
        if self.xob:
            subprocess.check_output(['echo {} > {}'.format(self.percent, self.xob)], shell=True)

    def command_toggle_mute(self):
        self.qtile.cmd_spawn('pamixer -t')
        self.tick()
        if self.xob:
            subprocess.check_output(['echo {} > {}'.format(self.percent, self.xob)], shell=True)

    def button_press(self, x, y, button):
        if button == 1:
            self.command_toggle_mute()
        elif button == 5:
            self.command_up()
        elif button == 4:
            self.command_down()
    #         if not self.show_text:
    #             self.show_text = True
    #             self.hide_timer = self.timeout_add(
    #                 self.text_displaytime, self.hide)
    #         else:
    #             self.show_text = False
    #             if self.hide_timer:
    #                 self.hide_timer.cancel()
    #         self.tick()
    #     elif button == 2:
    #         self.qtile.cmd_spawn('st -e neomutt')
    #     else:
    #         self.qtile.cmd_spawn(
    #             'notify-send "  Mail module" "\- Shows unread email\n\- Left click to see specifics\n\- Middle click to open neomutt"')
