local BasePlugin = require "kong.plugins.base_plugin"
local UpstreamOauthPlugin = BasePlugin:extend()

local cache = require("kong.plugins.upstream-oauth.cache")


UpstreamOauthPlugin.PRIORITY = 940

function UpstreamOauthPlugin:new()
    UpstreamOauthPlugin.super.new(self, "upstream-oauth")
end

function filter_headers(auth_headers_mapping, req_headers)

    local header_matches = false
    local matched_client_id = ""
    local matched_client_secret = ""

    -- TODO: 1. match headers, 2. check cache or database for existing auth 3. check if expired 4. use or update and use token
    for k, v in pairs(auth_headers_mapping)
    do
        ngx.log(ngx.DEBUG, "UpstreamOauthPlugin handle headers_mapping_key, " .. k)
        ngx.log(ngx.DEBUG, "UpstreamOauthPlugin handle headers_mapping_value_allowed_header, " .. v.allowed_header)
        ngx.log(ngx.DEBUG, "UpstreamOauthPlugin handle headers_mapping_value_client_id, " .. v.client_id)
        ngx.log(ngx.DEBUG, "UpstreamOauthPlugin handle headers_mapping_value_client_secret, " .. v.client_secret)
        local name, value = v.allowed_header:match("^([^:]+):*(.-)$")

        ngx.log(ngx.DEBUG, "name, value: " .. name .. ", " .. value)
        for req_h_name, req_h_value in pairs(req_headers) do
            ngx.log(ngx.DEBUG, "req_h_name, req_h_value: " .. req_h_name .. ", " .. req_h_value)
            if name == req_h_name and value == req_h_value then
                header_matches = true
            end
        end
    end
    return header_matches, matched_client_id, matched_client_secret
end


function UpstreamOauthPlugin:access(config)
    UpstreamOauthPlugin.super.access(self)
    local requestUrl = ngx.var.request_uri
    local applicationId = ngx.req.raw_header(true)
    ngx.log(ngx.DEBUG, "UpstreamOauthPlugin handle test_property, " .. config.test_property)

    -- TODO: 1. match headers
    --       2. check cache for existing auth
    --       3. check if token expired -> renew token
    --       4. cache token and send it to upstream as Bearer

    local header_matches, matched_client_id, matched_client_secret = filter_headers(config.auth_headers_mapping, ngx.req.get_headers())




    if not header_matches then
        ngx.say("Access denied.")
        ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end

    ngx.log(ngx.DEBUG, "UpstreamOauthPlugin requestUrl, " .. requestUrl)
    ngx.log(ngx.DEBUG, "UpstreamOauthPlugin applicationId, " .. applicationId)

    --	local SCHEMA = {
    --		primary_key = { "id" },
    --		table = "keyauth_credentials",
    --		cache_key = { "key" }, -- cache key for this entity
    --		fields = {
    --			id = { type = "id" },
    --			created_at = { type = "timestamp", immutable = true },
    --			consumer_id = { type = "id", required = true, foreign = "consumers:id"},
    --			key = { type = "string", required = false, unique = true }
    --		}
    --	}
    --
    --	return { keyauth_credentials = SCHEMA }
end



return UpstreamOauthPlugin

