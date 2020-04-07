package = "upstream-oauth"
version = "1.0-1"
source = {
  url = "git://github.com/asfeor/kong-upstream-oauth2.0"
}
description = {
  summary = "A Kong plugin, that allow you to authorize requests to upstream service by custom headers",
  license = "Apache 2.0"
}
dependencies = {
  "lua >= 5.1"
  -- If you depend on other rocks, add them here
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.upstream-oauth.handler"] = "src/handler.lua",
    ["kong.plugins.upstream-oauth.schema"] = "src/schema.lua",
    ["kong.plugins.upstream-oauth.cache"] = "src/cache.lua"
  }
}
