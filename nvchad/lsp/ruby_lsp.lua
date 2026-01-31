return {
  mason = false,
  cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
  filetypes = { "ruby", "eruby" },
  root_markers = { "Gemfile", ".git" },
  init_options = {
    formatter = "rubocop",
    linters = { "rubocop" },
    pullDiagnosticsOn = "save",
    enabledFeatures = {
      codeActions = true,
      codeLens = true,
      completion = true,
      definition = true,
      diagnostics = true,
      documentHighlights = true,
      documentLink = true,
      documentSymbols = true,
      foldingRanges = true,
      formatting = true,
      hover = true,
      inlayHint = true,
      onTypeFormatting = false,
      selectionRanges = true,
      semanticHighlighting = true,
      signatureHelp = true,
      typeHierarchy = true,
      workspaceSymbol = true,
    },
    featuresConfiguration = {
      inlayHint = {
        implicitHashValue = true,
        implicitRescue = true,
      },
    },
  },
  -- autosave
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      local augroup = vim.api.nvim_create_augroup("RubyLspFormat", {})

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}
