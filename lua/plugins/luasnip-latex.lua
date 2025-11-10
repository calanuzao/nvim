-- LuaSnip configuration with LaTeX snippets 
return {
  {
    "L3MON4D3/LuaSnip",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = function()
      local types = require("luasnip.util.types")

      return {
        history = true,
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "choiceNode", "Comment" } },
            },
          },
        },
        ext_base_prio = 300,
        ext_prio_increase = 1,
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
        ft_func = function()
          return vim.split(vim.bo.filetype, ".", true)
        end,
      }
    end,
    config = function(_, opts)
      local ls = require("luasnip")
      ls.setup(opts)

      -- Snippet helper functions
      local s = ls.snippet
      local sn = ls.snippet_node
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local r = ls.restore_node
      local rep = require("luasnip.extras").rep
      local fmt = require("luasnip.extras.fmt").fmt

      -- Recursive list snippet for itemize
      local rec_ls
      rec_ls = function()
        return sn(
          nil,
          c(1, {
            t(""),
            sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
          })
        )
      end

      -- LaTeX Snippets (Neil Mehra style)
      ls.add_snippets("tex", {
        -- Itemize list with recursive items
        s("ls", {
          t({ "\\begin{itemize}", "\t\\item " }),
          i(1),
          d(2, rec_ls, {}),
          t({ "", "\\end{itemize}" }),
        }),

        -- Fraction
        s("ff", {
          t("\\frac{"),
          i(1),
          t("}{"),
          i(2),
          t("}"),
        }),

        -- Begin environment
        s("beg", {
          t("\\begin{"),
          i(1, "env"),
          t({ "}", "\t" }),
          i(2),
          t({ "", "\\end{" }),
          rep(1),
          t("}"),
        }),

        -- Boxed equation
        s("bx", {
          t({
            "\\begin{center}",
            "\t\\fbox{\\begin{varwidth}{\\dimexpr\\textwidth-2\\fboxsep-2\\fboxrule\\relax}",
            "\t\t\\begin{equation*}",
            "\t\t\t",
          }),
          i(1),
          t({
            "",
            "\t\t\\end{equation*}",
            "\t\\end{varwidth}}",
            "\\end{center}",
          }),
        }),

        -- Equation* (unnumbered)
        s("eq", {
          t({ "\\begin{equation*}", "\t" }),
          i(1),
          t({ "", "\\end{equation*}" }),
        }),

        -- Inline math
        s("mt", {
          t("$ "),
          i(1),
          t(" $"),
        }),

        -- Partial derivative
        s("pd", {
          t("\\frac{\\partial "),
          i(1),
          t("}{\\partial "),
          i(2),
          t("}"),
        }),

        -- Vector (angle brackets)
        s("ve", {
          t("\\langle "),
          i(1),
          t(","),
          i(2),
          t(" \\rangle"),
        }),

        -- Bold vector
        s("vc", {
          t("\\bm{\\vec{"),
          i(1),
          t("}}"),
        }),

        -- Display math
        s("dm", {
          t({ "\\[", "\t" }),
          i(1),
          t({ "", "\\]" }),
        }),

        -- Aligned environment
        s("al", {
          t({ "\\begin{align*}", "\t" }),
          i(1),
          t({ "", "\\end{align*}" }),
        }),

        -- Cases environment
        s("cas", {
          t({ "\\begin{cases}", "\t" }),
          i(1),
          t({ "", "\\end{cases}" }),
        }),

        -- Section
        s("sec", {
          t("\\section{"),
          i(1),
          t("}"),
        }),

        -- Subsection
        s("ssec", {
          t("\\subsection{"),
          i(1),
          t("}"),
        }),

        -- Sqrt
        s("sq", {
          t("\\sqrt{"),
          i(1),
          t("}"),
        }),

        -- Sum
        s("sum", {
          t("\\sum_{"),
          i(1, "i=1"),
          t("}^{"),
          i(2, "n"),
          t("}"),
        }),

        -- Integral
        s("int", {
          t("\\int_{"),
          i(1, "a"),
          t("}^{"),
          i(2, "b"),
          t("}"),
        }),

        -- Limit
        s("lim", {
          t("\\lim_{"),
          i(1, "x \\to \\infty"),
          t("}"),
        }),
      }, {
        key = "tex",
      })

      -- Keymaps for snippet navigation
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true, desc = "Expand or jump forward in snippet" })

      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true, desc = "Jump backward in snippet" })

      vim.keymap.set("i", "<C-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = "Cycle through snippet choices" })
    end,
  },
}
