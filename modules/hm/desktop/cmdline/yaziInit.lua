require("starship"):setup()
require("full-border"):setup {
  type = ui.Border.ROUNDED,
}

require("searchjump"):setup({
  unmatch_fg = "#b2a496",
  match_str_fg = "#000000",
  match_str_bg = "#73AC3A",
  first_match_str_fg = "#000000",
  first_match_str_bg = "#73AC3A",
  lable_fg = "#EADFC8",
  lable_bg = "#BA603D",
  only_current = false,
  show_search_in_statusbar = false,
  auto_exit_when_unmatch = false,
  enable_capital_lable = true,
  search_patterns = ({ "hell[dk]d", "%d+.1080p", "第%d+集", "第%d+话", "%.E%d+", "S%d+E%d+", })
})
