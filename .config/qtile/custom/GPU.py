import subprocess

from libqtile.widget import base

__all__ = ["GPU"]


class GPU(base.ThreadedPollText):

    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("format", "{MemUsed}M/{MemTotal}M - {Temp}",
         "Formatting for field names."),
        ("update_interval", 1.0, "Update interval for the GPU Memory"),
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(GPU.defaults)

    def tick(self):
        self.update(self.poll())
        return self.update_interval

    def poll(self):
        process = subprocess.Popen(['nvidia-smi', '--query-gpu=memory.used,memory.total,temperature.gpu', '--format=csv,noheader'],
                                   stdout=subprocess.PIPE,
                                   universal_newlines=True)
        output = process.stdout.readline()
        internals = output.split(sep=',')
        val = {}
        val["MemUsed"], val["MemTotal"], val["Temp"] = int(internals[0].strip(
            ' MiB')), int(internals[1].strip(' MiB')), int(internals[2])
        return self.format.format(**val)
