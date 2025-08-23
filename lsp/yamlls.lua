-- https://github.com/b0o/SchemaStore.nvim
local ok, schemastore = pcall(require, 'schemastore')
local yaml_schemas = {}
if ok then
  yaml_schemas = schemastore.yaml.schemas()
end

-- https://github.com/redhat-developer/yaml-language-server
---@type vim.lsp.Config
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
  root_markers = { '.git' },
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = true,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = '',
      },
      schemas = yaml_schemas,
    },
    -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
    redhat = { telemetry = { enabled = false } },
  },
}
