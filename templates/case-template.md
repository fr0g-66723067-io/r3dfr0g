# <date> — <slug>

<!-- Copy this file to cases/<YYYY-MM>-<slug>/README.md and fill every section.
     Delete any section that genuinely does not apply; never leave placeholders. -->

**Case:** `<YYYY-MM>-<slug>` · **Status:** filed | taken down | observed
· **First observed:** <date>

## Summary

What was delivered, to whom (in aggregate — never an individual), how it looked,
and what it did. Two paragraphs maximum: the recipient's view, then the
operator's.

## Timeline (UTC)

| when | event | source |
|---|---|---|
| | | |

Registration → delivery interval belongs here; it is the strongest single
signal for a registrar.

## Infrastructure

| layer | value | evidence |
|---|---|---|
| domain | | |
| A / AAAA / CNAME | | |
| NS | | |
| MX / TXT | | |
| registrar (+ handle) | | |
| host (network + ASN) | | |
| front proxy / backend | | |
| TLS (issuer, serial, versions) | | |
| posture (HSTS / CAA / DNSSEC) | | |

## Funnel

Stage by stage, with the exact request that advances it and what the victim
sees. Include the client bundle's configuration object and the exfiltration
channel (protocol + message names). Never describe a step you reached by
submitting data.

## Cloaking

User-agent / cookie / geolocation filters observed, with the literal response
for each class of client.

## Kit family

Structural markers, comparison with public research (cite it), explicit
negatives (what it is *not*), and the attribution line: lineage, not actor.

## Indicators

```
# network / registration

# certificate

# http

# paths

# file hashes

# UI / template markers
```

## Blocklist state

If measured: the tuple (or equivalent), the controls used to interpret it, and
what it does and does not prove.

## Cluster pivots

What was tried, what returned data, what did not. Gaps are facts.

## Disclosure

Desks contacted (organisation and role, never the reporter identity or case
IDs), dates, and what each was asked for. Current takedown status with the
observation behind it.

## Limitations

Everything inferred, everything unreachable, everything not verified — each
labelled. If a claim cannot survive review, remove it rather than soften it.

## Safety note

Three sentences for a recipient: opening is not the harm, what to do if data was
entered, and how the follow-up call works.
