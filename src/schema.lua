local typedefs = require "kong.db.schema.typedefs"
local validate_header_name = require "kong.tools.utils".validate_header_name

local function validate_headers(pair, validate_value)
    local name, value = pair:match("^([^:]+):*(.-)$")
    if validate_header_name(name) == nil then
        return nil, string.format("'%s' is not a valid header", tostring(name))
    end

    if validate_value then
        if validate_header_name(value) == nil then
            return nil, string.format("'%s' is not a valid header", tostring(value))
        end
    end
    return true
end


local EXAMPLE_HEADERS = {
    {
        allowed_header = "application-id: \"upstream_allowed_app\"",
        client_id = "upstream_allowed_app",
        client_secret = "not defined for now",
    },
}

local mapping_element = {
    type = "array",
    required = true,
    default = EXAMPLE_HEADERS,
    elements = {
        type = "record",
        fields = {
            { allowed_header = { type = "string", match = "^[^:]+:.*$", custom_validator = validate_headers }, },
            { client_id = { type = "string", required = true }, },
            { client_secret = { type = "string", required = true }, },
        },
    }
}

return {
    name = "Upstream Oauth plugin",
    fields = {
        {
            consumer = typedefs.no_consumer
        },
        {
            protocols = typedefs.protocols_http
        },
        {
            config = {
                type = "record",
                fields = {
                    { test_property = { type = "string", required = true, default = "hello_world" }, },
                    { discovery = { type = "string", required = true, default = "https://.well-known/openid-configuration" }, },
                    { token_endpoint_auth_method = { type = "string", required = true, default = "client_secret_post" }, },
                    { auth_headers_mapping = mapping_element },
                }
            },
        },
    }
}


