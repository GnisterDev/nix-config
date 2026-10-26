-- Paints the editor from lua/nix.lua
-- `rice switch` calls `apply()` in every running instance so open editors follow the desktop.
local M = {}

function M.apply()
  package.loaded["nix"] = nil
  local ok, nix = pcall(require, "nix")
  if not ok then
    return
  end

  vim.o.background = nix.background or "dark"

  if nix.palette and pcall(require, "mini.base16") then
    require("mini.base16").setup({ palette = nix.palette, use_cterm = true })
    vim.g.colors_name = "rice"
  elseif not pcall(vim.cmd.colorscheme, nix.colorscheme) then
    vim.cmd.colorscheme("habamax")
  end

  if nix.transparent then
    for _, group in ipairs({ "Normal", "NormalNC", "SignColumn", "EndOfBuffer", "NormalFloat" }) do
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    end
  end
end

return M
