return {
  "yetone/avante.nvim",
  version = false, -- Never set this value to "*"! Never!
  -- enabled = false,
  opts = {
    provider = "gemini",
    providers = {
      gemini = {
        -- api_key_name = { "bw", "get", "notes", "gemini-api-key" },
        -- endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        -- model = "gemini-1.5-flash-latest",
        -- model = "gemini-2.0-flash",
        -- timeout = 30000,
        -- temperature = 0,
        -- max_tokens = 8192,
      },
      claude = {
        -- https://github.com/yetone/avante.nvim/issues/1775
        api_key_name = { "echo", "nothing" },
      },
    },
  },
  dependencies = {
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "Avante" },
      },
      ft = { "Avante" },
    },
  },
}
