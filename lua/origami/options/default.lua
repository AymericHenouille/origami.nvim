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
      function_call = require("origami.options.lua.function_call"),
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
