import pdb


class Config(pdb.DefaultConfig):
    sticky_by_default = True
    pygments_formatter_kwargs = {
        "style": "gruvbox-dark",
    }
