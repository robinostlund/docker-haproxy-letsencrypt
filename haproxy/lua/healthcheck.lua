-- frontend config
-- acl healthceck path_beg /healthcheck
-- http-request use-service lua.healthcheck if healthcheck

healthcheck = function(applet)
local response = "server is up"
applet:add_header("Content-Length", string.len(response))
applet:add_header("Content-Type", "text/plain")
applet:set_status(200)
applet:start_response()
applet:send(response)
end

core.register_service("healthcheck", "http", healthcheck)
