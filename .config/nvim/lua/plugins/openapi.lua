return {
  {
    "vinnymeller/swagger-preview.nvim",
    opts = {
      port = 8080,
      host = "localhost",
    },
    build = "npm install -g swagger-ui-watcher",
  },
}
