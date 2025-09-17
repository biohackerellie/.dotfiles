
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html
import datetime
import catppuccin


config = config # type: ignore
c = c # type: ignore

leader = " "
config.load_autoconfig()

c.editor.command = ["ghostty", "-e", "nvim", "{}"]
c.downloads.location.directory = "$HOME/Downloads"
c.zoom.default = "100%"
c.tabs.show = "switching"
c.statusbar.show = "in-mode"
c.auto_save.session = True
c.url.auto_search = "naive"
c.completion.height = "33%"
c.downloads.position = "bottom"
c.input.insert_mode.auto_load = True
c.spellcheck.languages = ["en-US"]
c.confirm_quit = ["always"]

# Tabs
c.tabs.favicons.scale = 1.0
c.tabs.background = True

# User agent
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.3 Firefox/121",
    "*",
)

# Dark mode
config.set("colors.webpage.darkmode.enabled", True)
config.set("colors.webpage.preferred_color_scheme", "auto")

# File handling
config.set("fileselect.handler", "external")
config.set(
    "fileselect.single_file.command",
    ["ghostty", "-e", "ranger", "--choosefile", "{}"],
)
config.set(
    "fileselect.multiple_files.command",
    ["ghostty", "-e", "ranger", "--choosefiles", "{}"],
)

# Enable Brave browser adblocker
# Install the python-adblock package and enable the adblocker within qutebrowser
config.set("content.blocking.method", "both")

# Theme
catppuccin.setup(c, 'frappe', True)

# Set fonts
c.fonts.default_size = "14"
c.fonts.default_family = "Cascadia Code"
c.fonts.completion.entry = "Cascadia Code"
c.fonts.hints = "Cascadia Code"
c.fonts.debug_console = "Cascadia Code"
c.fonts.prompts = "Cascadia Code"
c.fonts.statusbar = "Cascadia Code"

# Content
c.content.pdfjs = True
c.content.autoplay = False
c.content.canvas_reading = True 
c.content.webgl = True

# Home page
c.url.open_base_url = True
c.url.start_pages = ["https://startpage.com/"]
c.url.default_page = "https://startpage.com/"

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://startpage.com/?q={}",
    "am": "https://amazon.com/s?k={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "gh": "https://github.com/search?q={}",
    "gho": "https://github.com/{}",
    "ghr": "https://github.com/biohackerellie/{}",
    "rd": "https://reddit.com/search/?q={}",
    "rds": "https://reddit.com/r/{}",
    "wk": "https://en.wikipedia.org/wiki/{}",
    "yt": "https://youtube.com/results?search_query={}",
    "wa": "https://wiki.archlinux.org/?search={}",
}

# Aliases
c.aliases = {
    "o": "open",
    "q": "quit",
    "Q": "close",
    "w": "session-save",
    "x": "quit --save",
}
# Keybindings
config.bind("t", "cmd-set-text -s :open -t")
config.bind("O", "cmd-set-text -s :open -w")
config.bind("P", "cmd-set-text -s :open -p")
config.bind("W", "tab-clone -w")
config.bind("a", "mode-enter insert")

config.bind("K", "back")
config.bind("J", "forward")
config.bind("H", "tab-prev")
config.bind("L", "tab-next")
config.bind("Q", "tab-close")

config.bind("<Ctrl-=>", "zoom-in")
config.bind("<Ctrl-->", "zoom-out")

config.bind(
     " " + "A",
    "open -t https://github.com/biohackerellie/",
)
config.bind(leader + "b", "config-cycle statusbar.show always in-mode")
config.bind(leader + "B", "config-cycle tabs.show multiple switching")
config.bind(leader + "c", "config-edit")
config.bind(leader + "C", "cmd-set-text -s :set -t")
config.bind(leader + "d", "devtools")
config.bind(leader + "D", "devtools-focus")
config.bind(leader + "e", "edit-text")
config.bind(leader + "E", "cmd-edit")
config.bind(leader + "i", "hint inputs")
config.bind(leader + "h", "history")
config.bind(leader + "H", "help")
config.bind(leader + "m", "bookmark-list")
config.bind(leader + "M", "bookmark-add")
config.bind(leader + "n", "tab-clone")
config.bind(leader + "N", "tab-clone -w")
config.bind(leader + "o", "hint links window")
config.bind(leader + "O", "hint links run :open -p {hint-url}")
config.bind(leader + "p", "tab-pin")
config.bind(leader + "P", "cmd-set-text -s :tab-move")
config.bind(leader + "q", "tab-close")
config.bind(leader + "Q", "close")
config.bind(leader + "r", "config-source")
config.bind(leader + "R", "restart")
config.bind(
    leader + "s",
    "screenshot "
    + "$HOME/Pictures"
    + "qute-"
    + datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    + ".png",
)
config.bind(leader + "S", "view-source --edit")
config.bind(leader + "t", "cmd-set-text -s :tab-select")
config.bind(leader + "T", "tab-only")
config.bind(leader + "u", "undo")
config.bind(leader + "v", "hint links spawn mpv {hint-url}")
config.bind(
    leader + "V",
    "hint links spawn " + "ghostty" + "-e yt-dlp {hint-url}",
)
config.bind(leader + "w", "cmd-set-text -s :tab-take")
config.bind(leader + "W", "tab-give")
config.bind(leader + "y", "hint links yank")
config.bind(leader + "x", "quit --save")
config.bind(leader + "X", "window-only")

config.bind("p", "tab-pin")
config.bind(";w", "hint link spawn --detach mpv --force-window yes {hint-url}")
config.bind(";W", "spawn --detach mpv --force-window yes {url}")
config.bind(
    ";I",
    "hint images spawn --output-message wget -P "
    + "$HOME/Pictures"
    + "images/ -c {hint-url}",
)

# Password management
config.bind("ee", "spawn --userscript qute-pass")
config.bind("eu", "spawn --userscript qute-pass --username-only")
config.bind("ep", "spawn --userscript qute-pass --password-only")
config.bind("eo", "spawn --userscript qute-pass --otp-only")

