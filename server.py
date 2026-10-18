"""Lab app of the dependency scenarios: aiohttp serving a static folder.

The static route follows symlinks. Before 3.9.2, aiohttp does not check that
the resolved path stays inside the folder (CVE-2024-23334).
"""
from aiohttp import web


async def root(_req):
    return web.Response(text="ok\n")


app = web.Application()
app.router.add_get("/", root)
app.router.add_static("/static/", "/app/static", follow_symlinks=True)
web.run_app(app, host="0.0.0.0", port=8080)
