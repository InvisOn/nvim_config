return {
    {
    "neovim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      { "neovim-treesitter/treesitter-parser-registry" },  -- required by community fork
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",  -- master requires deleted nvim-treesitter.configs module
      },
    },
    init = function()
      -- Highlighting and indentation must be enabled manually via FileType autocmd;
      -- the new plugin does not handle these through setup().
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- ensure_installed is no longer a setup() option; install explicitly.
      local wanted = {
        "bash", "c", "html", "lua",
        "markdown", "markdown_inline",
        "python", "query", "vim", "vimdoc", "yaml",
      }
      local installed = require("nvim-treesitter.config").get_installed()
      local to_install = vim.iter(wanted)
        :filter(function(p) return not vim.tbl_contains(installed, p) end)
        :totable()
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end
    end,

    config = function()
      -- setup() now only accepts parser/query management options.
      -- highlight, indent, incremental_selection, textobjects are gone from here.
      require("nvim-treesitter").setup({})

      -- Textobjects: new main branch exposes a standalone setup + direct module API.
      -- Keymaps must be wired manually; configs.setup() no longer does it.
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable    = true,
          lookahead = true,
        },
        move = {
          enable     = true,
          set_jumps  = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move   = require("nvim-treesitter-textobjects.move")

      -- Select textobjects (visual + operator-pending)
      local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      }
      for key, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end, { desc = "Select " .. query })
      end

      -- Move: goto next/prev start/end
      local move_maps = {
        goto_next_start     = { ["]m"] = "@function.outer", ["]]"] = "@class.inner" },
        goto_next_end       = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
        goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.inner" },
        goto_previous_end   = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
      }
      local move_fns = {
        goto_next_start     = move.goto_next_start,
        goto_next_end       = move.goto_next_end,
        goto_previous_start = move.goto_previous_start,
        goto_previous_end   = move.goto_previous_end,
      }
      for map_type, keys in pairs(move_maps) do
        for key, query in pairs(keys) do
          vim.keymap.set({ "n", "x", "o" }, key, function()
            move_fns[map_type](query, "textobjects")
          end, { desc = map_type .. " " .. query })
        end
      end
    end,
  },
}

