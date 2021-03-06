-- Copyright 2018-2020 Lienol <lawlienol@gmail.com>
module("luci.controller.ipsec-server", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/luci-app-ipsec-server") then return end

    entry({"admin", "vpn"}, firstchild(), "VPN", 45).dependent = false
    entry({"admin", "vpn", "ipsec-server"},
          alias("admin", "vpn", "ipsec-server", "settings"),
          _("IPSec VPN Server"), 49).dependent = false
    entry({"admin", "vpn", "ipsec-server", "settings"},
          cbi("ipsec-server/settings"), _("General Settings"), 10).leaf = true
    entry({"admin", "vpn", "ipsec-server", "users"}, cbi("ipsec-server/users"),
          _("Users Manager"), 20).leaf = true
    entry({"admin", "vpn", "ipsec-server", "status"}, call("status")).leaf =
        true
end

function status()
    local e = {}
    e.status = luci.sys.call("/usr/bin/pgrep ipsec > /dev/null") == 0
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end
