local fold_module = require("origami.functions.fold")

---@type Options
return {
  block_nodes = {
    default = {
      "function_definition",
      "function_call",
      "if_statement",
      "else_statement",
      "while_statement",
      "for_statement",
    },
    lua = {
      "function_definition",
      function_call = {
        fold = function(lines)
          local result = {}
          for _, line in ipairs(fold_module.fold(lines)) do
            local text = line
            text = text:gsub("%(%s+", "(")
            text = text:gsub("%s+%)", ")")
            table.insert(result, text)
          end
          return result
        end,
        unfold = function(lines)
          local result = {}
          for _, line in ipairs(lines) do
            local text = line
            text = text:gsub("%(", "(\n")
            text = text:gsub("%s*,%s*", ",\n")
            text = text:gsub("%)%s*$", "\n)")

            for l in text:gmatch("([^\n]+)") do
              table.insert(result, l)
            end
          end
          return result
        end,
      },
      "if_statement",
      "else_statement",
      "while_statement",
      "for_statement",
    },
    javascript = {
      "statement_block",
      "program",
      "function",
      "arrow_function",
    },
  },
}
