-- custom snippets
vim.pack.add({
  { src = "https://github.com/L3MON4D3/LuaSnip" }
})

local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta


ls.add_snippets("markdown", {
  s("new_daily",fmta(
    [[
    created: <timestamp>
    tags: <tags>

    # <title>

    ---
    ## Pre notes
      - <pre_note>


    ## Tasks
      - <tasks>


    ## Meetings
      - <meetings>


    ## Notes
      - <main_note>
    ]],
    {
      timestamp = t(os.date("%Y-%m-%d %H:%M")),
      tags = t("[[+daily]]"),
      title = t(os.date("%w,%B %d,%Y")),
      pre_note = i(1, ""),
      tasks = i(2, "[ ] "),
      main_note = i(3, ""),
      meetings = t("[[]]"),
    }
  )),

  s("new_task", fmta(
    [[
    created: <timestamp>
    tags: <tags>
    prio: <prio>

    # <title>

    ---
    ## Summary
    <summary>


    ## Todo
    -[ ] <todo>

    ]],
    {
      timestamp = t(os.date("%Y-%m-%d %H:%M")),
      tags = t("[[+tasks]]"),
      prio = i(1,"easy"),
      title = i(2,"Task"),
      summary = i(3,"a little summary"),
      todo = i(4,"first step")
    }
  )),
  s("new_meeting", fmta(
    [[
    date: <timestamp>
    tags: <tags>

    # Meeting: <title>
    
    ---
    ## summary
    date: <date>
    companies: Bwi,<comps>
    attendees: <attendees>
    description: <desc>

    ---
    ## Notes
    - <notes>

    ]],
    {
      timestamp = t(os.date("%Y-%m-%d %H:%M")),
      tags = t("[[+meetings]]"),
      title = i(1,"Meeting"),
      date = t(os.date("%w,%B %d,%Y - %H:%M")),
      comps = i(2,"Comps"),
      attendees = i(3,"People"),
      desc = i(4,"a little summary"),
      notes = i(5,"")
    }
  )),
  s("new_note", fmta(
    [[
    created: <timestamp>
    tags: <tags>

    # <title>
    
    ---


    ---
    ## References

    ]],
    {
      timestamp = t(os.date("%Y-%m-%d %H:%M")),
      tags = t("[[+notes]]"),
      title = i(1,""),
    }
  )),
})
