# r3dfr0g — public campaign reports

Sanitized write-ups of phishing and abuse campaigns we investigated and filed
for takedown. The point is that the next person who gets the same SMS can
recognise the kit in one request, and that the desks who can kill a domain have
the technical evidence in a citable form.

This repository contains **reports only**. It is not the r3dfr0g tool, and no
part of the tool's source code is published here.

## What is here

```
cases/<date>-<slug>/README.md    the write-up: timeline, infrastructure, funnel
                                 mechanics, indicators, disclosure status, limits
cases/<date>-<slug>/screenshots/ renders of the attacker's pages (attacker
                                 content only, never a victim's screen)
POLICY.md                        exactly what is published and what is withheld
templates/case-template.md       the shape every case follows
scripts/                         the redaction checker that gates every push
```

## How a case is produced

1. **Read the lure literally.** `https://<brand>@evil.tld/…` is URL userinfo — the
   host is `evil.tld`. Most of the deception is in that string, not the page.
2. **Collect read-only.** Only what a victim's browser does (GETs, DNS, TLS),
   from a pinned collection vantage. Never submit to the kit's capture
   endpoints; never scan or exploit the host. This is evidence gathering, not
   an attack.
3. **Document the funnel without walking it.** Gate → cookie → payload is
   recovered from the page's own redirect and its bundle; the form stages are
   described from the client code, not by typing into them.
4. **Fingerprint the family, cite, do not name.** Structural markers (cookie
   names, path prefixes, framework error shapes, hosting) survive hostname
   rotation; public research is cited when it matches. A lineage is stated; a
   person or crew is never named on similarity alone.
5. **File to every desk that can kill or flag the name** — registrar, registry,
   host, national CERT, brand, blocklists — and record what was filed, without
   publishing the reporter identity or the case IDs keyed to it.
6. **Publish the sanitized report** after it has been checked against
   `POLICY.md` and `scripts/check-redactions.sh`.

## What is never published

Collection vantage addresses, reporter identity and addresses, credentials and
tokens, victim data, private correspondence with abuse desks, raw kit archives
or the attackers' code, and anything belonging to a third party that is not the
campaign's own infrastructure. Details: [`POLICY.md`](POLICY.md).

## Indicators are live attack infrastructure

Addresses, domains and hashes in these reports point at infrastructure used to
defraud people. They are published for blocking and detection. Do not visit the
sites; do not interact with them.

## Corrections and re-use

Open an issue for a correction or to tell us a case has been resolved, or mail
`fr0g@66723067.io`. Text is published under CC BY 4.0
([`LICENSE`](LICENSE)); indicators are facts and are not copyrightable.

## Index

| case | target | kit | status |
|---|---|---|---|
| [`2026-10-qxvwnwx-shop`](cases/2026-10-qxvwnwx-shop/) | FedEx "delivery failed" smishing | `us_post_*` V2 lineage (fake Cloudflare gate + Vue SPA + live operator WebSocket) | filed 2026-10-29; name still live at last check |
