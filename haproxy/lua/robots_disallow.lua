-- frontend config
-- acl			robots	path_end -i robots.txt
-- http-request use-service lua.robots  if  robots aclcrt_SharedFront

robots = function(applet)
local response = "User-agent: *\nDisallow: /"
applet:add_header("Content-Length", string.len(response))
applet:add_header("Content-Type", "text/plain")
applet:set_status(200)
applet:start_response()
applet:send(response)
end

core.register_service("robots", "http", robots)
