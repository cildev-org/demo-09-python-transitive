# demo-09-python-transitive

Demo target for Blue-Oryx dependency pull requests in Python, for a
vulnerable **transitive** dependency (fix class A1, parent bump).

> **This app is vulnerable on purpose.** `requirements.txt` pins
> `botbuilder-integration-aiohttp==4.14.8` (a real package on PyPI), which
> pins `aiohttp==3.8.5`. That aiohttp is affected by CVE-2024-23334: a static
> route with `follow_symlinks` serves files outside its root
> (`/static/../../srv/marker.txt`). Do not run it anywhere that is reachable
> from a network you care about.

## What is here

| File | Purpose |
| --- | --- |
| `requirements.txt` | One line: the parent `botbuilder-integration-aiohttp==4.14.8`. aiohttp is not a line here |
| `server.py` | aiohttp app with a static route on `/app/static` |
| `Dockerfile` | Python 3.11 image (pinned by digest) that installs `requirements.txt` from PyPI |
| `.github/workflows/build.yml` | Builds the image on every pull request; on a push to `main` it also pushes it to `ghcr.io/<repo>:<commit>` |

## Demo flow

1. Blue-Oryx receives a confirmed finding for CVE-2024-23334 (aiohttp 3.8.5)
   on the asset bound to this repository.
2. aiohttp is not in `requirements.txt`, so Blue-Oryx resolves the dependency
   graph and finds the parent. The lowest minor or patch release of the parent
   that asks for a fixed aiohttp is `4.15.0` (`aiohttp==3.9.3`), so the pull
   request changes one line: the parent pin, `4.14.8` to `4.15.0`.
3. The `build` workflow runs on the pull request.
4. A person reviews and merges the pull request. Blue-Oryx never merges.
5. The workflow pushes the image of the merge commit. The operator deploys it
   to the lab target; Blue-Oryx never deploys.
6. The operator confirms the deploy and Blue-Oryx runs the same exploit again.
   Only a blocked re-run makes the task `verified-fixed`.

## Branches

| Branch | Purpose |
| --- | --- |
| `main` | What Blue-Oryx patches |
| `vulnerable-baseline` | The vulnerable state, for resetting `main` between demo runs |
