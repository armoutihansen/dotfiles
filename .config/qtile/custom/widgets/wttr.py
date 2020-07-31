import os
import requests
from datetime import datetime
import re

from libqtile.widget import base

__all__ = ["wttr"]


class wttr(base.ThreadedPollText):

    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("format", "{Temp} {Temp_measure}, {Wind} {Wind_measure}, {Rain} {Rain_measure} - [{Rain_chance}]",
         "Formatting for field names."),
        ("update_interval", 3600.0, "Update interval for the weather"),
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(wttr.defaults)

    def tick(self):
        self.update(self.poll())
        return self.update_interval

    def has_internet(self):
        connection = None
        try:
            r = requests.get("https://google.com")
            r.raise_for_status()
            connection = True
        except:
            connection = False
        finally:
            return connection

    def poll(self):
        if self.has_internet():
            os.system(
                'curl -sf "wttr.in/$LOCATION" > "/home/jah/.local/share/weatherreport"')
        with open("/home/jah/.local/share/weatherreport") as f:
            content = f.read()
            f.close()
        val = {}
        val["Temp_measure"] = re.findall('°\S', content)[0]
        val["Wind_measure"] = re.findall('\S\S/\S', content)[0]
        val['Temp'] = re.findall(
            '\d\dm[0-9]*\S', content)[0].split('m')[1].replace('\x1b', '')
        val['Wind'] = re.findall(
            '\d\dm[0-9]*\S', content)[1].split('m')[1].replace('\x1b', '')
        rain_ = re.findall('[0-9.]*\Wmm', content)[0].split()
        val["Rain"] = rain_[0]
        val["Rain_measure"] = rain_[1]
        rain_chances = re.findall('\d*%', content)[:4]
        now = int(datetime.now().strftime('%H'))
        if now in range(5, 11):
            val["Rain_chance"] = rain_chances[0]
        elif now in range(11, 17):
            val["Rain_chance"] = rain_chances[1]
        elif now in range(17, 23):
            val["Rain_chance"] = rain_chances[2]
        else:
            val["Rain_chance"] = rain_chances[3]
        return self.format.format(**val)


a = wttr()
a.has_internet()
a.poll()
