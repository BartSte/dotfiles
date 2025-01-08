c.aliases = {
    "w": "session-save",
    "q": "close",
    "qa": "quit",
    "wq": "quit --save",
    "wqa": "quit --save",
    "da": "set colors.webpage.darkmode.enabled true",
    "li": "set colors.webpage.darkmode.enabled false",
    "dark": "set colors.webpage.darkmode.enabled true",
    "light": "set colors.webpage.darkmode.enabled false",
}
c.auto_save.session = False
c.bindings.key_mappings = {"<Ctrl-c>": "<Escape>", "<Ctrl-[>": "<Escape>"}
c.changelog_after_upgrade = "minor"
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.bg = "white"
c.completion.cmd_history_max_items = 500
c.confirm_quit = ["multiple-tabs", "downloads"]
c.content.autoplay = False
c.content.blocking.enabled = True
c.content.blocking.adblock.lists.extend(
    ["https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"]
)
c.content.cache.appcache = True
c.downloads.remove_finished = 50
c.editor.command = [
    "Alacritty",
    "-e",
    "nvim",
    "{file}",
    "-c",
    '"normal {line}G{column0}l"',
]
c.editor.encoding = "utf-8"
c.editor.remove_file = True
c.fonts.default_size = "11pt"
c.fonts.hints = "14pt JetBrainsMono NF"
c.fonts.keyhint = "14pt JetBrainsMono NF"
c.hints.chars = "arstgmneiozxcdvkhwfpbjluy"
c.hints.leave_on_load = True
c.hints.scatter = False
c.hints.uppercase = True
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = False
c.input.insert_mode.auto_load = False
c.input.insert_mode.leave_on_load = False
c.input.links_included_in_focus_chain = True
c.keyhint.delay = 0
c.qt.workarounds.remove_service_workers = True
c.scrolling.bar = "never"
c.url.default_page = "about:blank"
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}&safe=active"
}
c.url.start_pages = ["about:blank"]
c.window.hide_decoration = False
c.content.javascript.enabled = True

# Per-domain settings
key: str = "colors.webpage.darkmode.enabled"
dark: list[str] = ["www.nos.nl"]
for url in dark:
    config.set(key, True, url)

light: list[str] = [
    "www.netflix.com",
    "play.max.com",
    "mail.google.com",
    "outlook.live.com",
]
for url in light:
    config.set(key, False, url)

# Bindings
config.bind("<Down>", "move-to-next-line", mode="caret")
config.bind("<Left>", "move-to-prev-char", mode="caret")
config.bind("<Right>", "move-to-next-char", mode="caret")
config.bind("<Up>", "move-to-prev-line", mode="caret")
config.load_autoconfig()
