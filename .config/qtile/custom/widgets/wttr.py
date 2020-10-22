from libqtile.widget import base
import subprocess

__all__ = ["wttr"]


class wttr(base.ThreadedPollText):

    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("short_format", "  {Condition} {real_temp}",
         "Formatting for field names."),
        ("long_format", "{wind} 🌧 {precipitation} [{pressure}] 🌅 {dawn} 🌇 {sunset} {moonphase} {moonday}", "jj"),
        # ("long_format",
        #     "{condition}[{Condition}] 🌡{real_temp} [{feel_temp}] 💦 {humidity} 🌧 {precipitation} {wind}", "blabla"),
        ("update_interval", 3600.0, "Update interval for the weather"),
        ("text_displaytime", 5, "Time for text to remain before hiding"),
        ("location", "", "location")
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(wttr.defaults)

        self.show_text = False
        self.hide_timer = None
        self.val = None
        if self.location != "":
            self.loc = "/" + self.location
        else:
            self.loc = self.location
        # self.mouse_callbacks['Button3'] = lambda qtile: qtile.cmd_spawn('st')

    def tick(self):
        self.update(self.poll())
        return self.update_interval

    def alt_tick(self):
        self.update(self.alt_poll())

    def poll(self):
        keys = ['condition', 'Condition',  'humidity', 'real_temp', 'feel_temp', 'wind', 'location', 'moonphase',
                'moonday', 'precipitation', 'prob_precipitation', 'pressure', 'dawn', 'sunrise', 'zenith', 'sunset', 'dusk']
        values = subprocess.check_output(
            'curl -s wttr.in{}?format="%c_%C_%h_%t_%f_%w_%l_%m_%M_%p_%o_%P_%D_%S_%z_%s_%d" | sed "s/+//g"'.format(self.loc), shell=True).decode().split('_')
        self.val = dict(zip(keys, values))
        # self.val['Condition'] = self.val['Condition'].split(',')[0]
        if self.show_text:
            return self.long_format.format(**self.val)
        else:
            return self.short_format.format(**self.val)

    def alt_poll(self):
        if self.show_text:
            return self.long_format.format(**self.val)
        else:
            return self.short_format.format(**self.val)

    def button_press(self, x, y, button):
        if button == 1:
            if not self.show_text:
                self.show_text = True
                self.hide_timer = self.timeout_add(
                    self.text_displaytime, self.hide)
            else:
                self.show_text = False
                if self.hide_timer:
                    self.hide_timer.cancel()
        if self.val:
            self.alt_tick()
        else:
            self.tick()

        if button == 2:
            self.show_weather()

        if button == 3:
            self.qtile.cmd_spawn(
                'notify-send "🌤 Weather module" "Shows weather"')

    def hide(self):
        self.show_text = False
        if self.val:
            self.alt_tick()
        else:
            self.tick()

    def open_something(self):
        self.qtile.cmd_spawn("st -e '$(curl -s wttr.in{} | less -Srf)'".format(self.loc))

    def show_weather(self):
        subprocess.run("curl -sf 'wttr.in' > /tmp/weatherreport", shell=True)
        self.qtile.cmd_spawn("st -e less -Srf /tmp/weatherreport")

    # def show_weather(self):
        # ps = subprocess.Popen(('curl', '-s', 'wttr.in'),
        # stdout = subprocess.PIPE)
        # return subprocess.run(('less', '-Srf'), stdin=ps.stdout)
