# Cases

One directory per campaign: `cases/<YYYY-MM>-<slug>/`.

Each case is a single readable page plus the attacker's own pages as images.
It answers, in order: what was delivered, when, where it lives, what it does,
how to recognise the kit next time, what was filed, and what remains unknown.

| case | target | first observed | status |
|---|---|---|---|
| [`2026-10-qxvwnwx-shop`](2026-10-qxvwnwx-shop/) | FedEx delivery-failure smishing | 2026-10-29 | filed; name live at last check |

Reading order for a new case: the summary, the *Indicators* block, then the kit
family section — the last one is what identifies the same operation on a
different domain.

Start a new case from [`../templates/case-template.md`](../templates/case-template.md)
and do not publish it until `scripts/check-redactions.sh` and
`scripts/check-local-secrets.sh` both pass and `POLICY.md` has been read line by
line against the draft.
