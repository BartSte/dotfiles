# Darkmode for all pages
# c.colors.webpage.darkmode.algorithm = 'lightness-hsl'
# c.colors.webpage.darkmode.contrast = -.022
# c.colors.webpage.darkmode.enabled = True
# c.colors.webpage.darkmode.grayscale.images = 0.35
# c.colors.webpage.darkmode.policy.images = 'always'
# c.colors.webpage.darkmode.threshold.background = 100
# c.colors.webpage.darkmode.threshold.text = 150

c.aliases = {'w': 'session-save', 'q': 'close', 'qa': 'quit', 'wq': 'quit --save', 'wqa': 'quit --save'}
c.auto_save.session = False
c.bindings.key_mappings = {'<Ctrl-c>': '<Escape>', '<Ctrl-t>': '<Escape>'}
c.changelog_after_upgrade = 'minor'
c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.webpage.bg = 'white'
c.completion.cmd_history_max_items = 500
c.confirm_quit = ['multiple-tabs', 'downloads']
c.content.autoplay = False
c.content.blocking.enabled = True
c.content.cache.appcache = True
c.downloads.remove_finished = 50
c.editor.command = ['Alacritty', '-e', 'nvim', '{file}', '-c', '"normal {line}G{column0}l"']
c.editor.encoding = 'utf-8'
c.editor.remove_file = True
c.fonts.default_family = ['JetBrains Mono']
c.fonts.default_size = '12pt'
c.fonts.hints = 'JetBrains Mono Extra Bold'
c.fonts.keyhint = '14pt JetBrains Mono Extra Bold'
c.hints.chars = 'arstgmneiozxcdvkhqwfpbjluy'
c.hints.leave_on_load = True
c.hints.scatter = False
c.hints.uppercase = True
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = False
c.input.insert_mode.leave_on_load = True
c.input.links_included_in_focus_chain = True
c.keyhint.delay = 0
c.qt.workarounds.remove_service_workers = True
c.scrolling.bar = 'never'
c.spellcheck.languages = []
c.url.default_page = 'about:blank'
c.url.searchengines = {'DEFAULT': 'https://www.google.com/search?q={}'}
c.url.start_pages = ['about:blank']
c.window.hide_decoration = False
config.bind('<Down>', 'move-to-next-line', mode='caret')
config.bind('<Left>', 'move-to-prev-char', mode='caret')
config.bind('<Right>', 'move-to-next-char', mode='caret')
config.bind('<Up>', 'move-to-prev-line', mode='caret')
config.load_autoconfig(True)

