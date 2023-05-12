import pdb

from pygments.formatters import TerminalTrueColorFormatter


class Config(pdb.DefaultConfig):
    sticky_by_default = True
    use_pygments = True
    pygments_formatter = TerminalTrueColorFormatter
    pygments_formatter_kwargs = {
        "style": "github-dark",
    }
