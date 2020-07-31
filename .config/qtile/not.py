#!/usr/bin/python

from gi.repository import Notify
import gi
import subprocess
gi.require_version('Notify', '0.7')
# Notify.Notification.new("hjlhj", subprocess.check_output('/usr/bin/pacman -Qu', shell=True).decode("utf-8"), "hjh").show()
# h.show()


def notification(title, command):
    Notify.init('Test')
    return Notify.Notification.new(title, subprocess.check_output(
        command, shell=True).decode("utf-8")).show()


notification('Upgradable packages', '/usr/bin/pacman -Qu')
