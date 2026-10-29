# Publication policy

Every file in this repository is read by people who were targeted, by abuse
desks, and by the operators of the sites we describe. The rules below exist so
that publishing helps the first two and gives the third nothing.

## Never published

| category | why | examples |
|---|---|---|
| **collection vantage** | identifies our collection point and lets an operator block or trace it | the cloud address, instance id, provider region, SSH key names |
| **reporter identity** | personal and operational data; also the key to abuse-portal case lookups | names, mailboxes, phone numbers, account handles |
| **abuse-case identifiers** | keyed to the reporter identity in most portals | registrar/registry/CERT ticket IDs |
| **credentials and secrets** | obviously | SMTP tokens, API keys, cookies belonging to us, private keys |
| **victim data** | the victims are not the story and did not consent | phone numbers from the lure, entered form data, email headers with real addresses |
| **raw kit artifacts** | publishing criminal code distributes it | the phishing bundle, its source maps, archives |
| **third-party private data** | not ours to publish | WHOIS registrant details behind a privacy shield, unrelated hosts on shared infrastructure |
| **tool source code** | out of scope for this repository | any part of the r3dfr0g implementation |

## Always published (when verified)

- the domain and URL **as delivered**, plus the parsed host, so the userinfo or
  subdomain trick is visible;
- attacker infrastructure that can be blocked: addresses, nameservers,
  certificates (serial/issuer/times), hosting network, hashes of the kit's
  public assets;
- the funnel mechanics and the kit's structural fingerprint, because that is
  what lets the next recipient recognise the same build;
- timestamps of collection and disclosure, and the current takedown status;
- limitations and inferences, labelled as such.

## Screenshots

Only the attacker's pages, rendered from our own collection. Never a victim's
screen, a mailbox, a chat, or an abuse portal. Crop or omit anything that shows
an account, an address book, or a case page.

## Redaction mechanics

Three layers, in order:

1. **Author from scratch.** Public text is written from the case notes, not
   copied out of the private dossier — mechanical scrubbing cannot catch
   "the family member who received this".
2. **`scripts/check-redactions.sh`** (runs in CI on every push): fails on
   email addresses outside `redaction/allow.txt`, RFC1918/loopback addresses,
   private-key blocks, token-shaped strings, absolute home paths, and any
   source-code file.
3. **`scripts/check-local-secrets.sh`** (runs locally before a push): checks the
   tree against a deny-list that lives **outside** this repository
   (`~/.config/r3dfr0g-reports/deny.txt`), because the plaintext vantage address
   and reporter address must never be committed here either.

A case is publishable only when all three pass and a human has read the diff.

## Status claims

"Filed" means a report was accepted by a desk. It does not mean the site is
down. A name is described as taken down only when its registration status shows
a hold, or the hosting provider has suspended the service, with the observation
recorded.
