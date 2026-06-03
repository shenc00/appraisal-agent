# Appraisal Assistant — Microsoft 365 Copilot declarative agent

A Copilot agent that helps a **BD manager** draft performance-appraisal feedback
about **one employee at a time**, grounded in the **manager's own** emails and
meeting (Facilitator / Loop) notes within a chosen date range.

It covers two appraisal components:

1. **Goal Setting** — the manager pastes the employee's **SMART goals** and
   reported progress; the agent generates per-goal feedback and rates each goal
   **Above / Meet / Below Expectation** against evidence in emails and Loop notes.
2. **Overall Performance** — the manager pastes the employee's self-input; the
   agent produces a summary (**within 300 words**) organised under the **BD
   framework** (Values, Leadership Commitments, Mindset), noting where the
   self-input is or isn't supported.

It runs entirely inside Microsoft 365 Copilot using each user's existing
permissions — it never accesses anyone else's mailbox, and there is no backend,
no Azure resources, and no Graph app registration to maintain.

> **Output is always a DRAFT** for the manager to review and edit. Keep a human in
> the loop, and give HR/Legal a heads-up since this involves performance data.

---

## Repository contents

```
appraisal-agent/
├─ appPackage/
│  ├─ manifest.json          # Microsoft 365 app manifest (id, name, icons)
│  ├─ declarativeAgent.json  # The agent: instructions, starters, capabilities
│  ├─ color.png              # 192x192 app icon
│  └─ outline.png            # 32x32 transparent outline icon
├─ build.ps1                 # Packages appPackage/ into dist/appraisal-agent.zip
├─ .gitignore
└─ README.md
```

The **source of truth** is `appPackage/declarativeAgent.json`. Edit the
`instructions`, `conversation_starters`, or `capabilities` there to change the
agent's behaviour, then re-package and re-upload (steps below).

---

## Prerequisites

1. A **Microsoft 365 Copilot** license on the account you'll use.
2. **Custom app upload** must be allowed in your tenant. This is usually on by
   default, but some orgs disable it (an admin setting). If Step 3 below has no
   "Upload a custom app" option, you'll need an admin to enable it — see
   *Troubleshooting*.

> **No admin / upload is blocked?** You don't need the packaged app at all. See
> **[PROMPT.md](PROMPT.md)** — paste-ready prompts that deliver the same two
> components (SMART goal ratings + BD-framework summary) directly in Copilot
> chat, with **zero installation and no admin approval**. Hosting a website (e.g.
> Netlify) does **not** help: a web app can't read your mail/Loop notes without
> an Entra app registration + Graph admin consent, and can't borrow Copilot's
> access either — so it needs *more* approval, not less.

---

## Step 0 — Validate first (do this before anything else)

Open **Microsoft 365 Copilot chat** (in Teams or the Copilot app) and ask:

> *"Summarize my meeting notes and email correspondence with {a real colleague}
> from the last 3 months."*

- If it surfaces your **Facilitator/Loop meeting notes** and emails → great, this
  agent will work. Continue.
- If it returns emails but **not** the meeting notes → your Loop content isn't in
  Copilot's index yet, and the agent won't be able to use it either. Resolve that
  first (it's a tenant/indexing matter), otherwise the meeting-notes feature won't
  work regardless of this agent.

---

## Step 1 — Package the agent

From this folder, in PowerShell:

```powershell
.\build.ps1
```

This produces **`dist\appraisal-agent.zip`** containing `manifest.json`,
`declarativeAgent.json`, and the two icons at the zip root (required layout).

> Manual alternative:
> `Compress-Archive -Path appPackage\* -DestinationPath dist\appraisal-agent.zip -Force`
> Always zip the **contents** of `appPackage\` — `manifest.json` must sit at the
> root of the zip, not inside a subfolder.

---

## Step 2 — Upload ("push") to Copilot

There is no `git push` to Copilot. You upload the packaged zip as a custom app;
it then appears as an agent in Copilot. Two ways:

### Via Microsoft Teams (simplest)
1. Open **Microsoft Teams**.
2. Left rail → **Apps** → **Manage your apps** (bottom) → **Upload an app**.
3. Choose **Upload a custom app** → select `dist\appraisal-agent.zip` → **Add**.
4. Open **Microsoft 365 Copilot** (the Copilot app, Teams Copilot, or
   copilot.microsoft.com signed in with your work account). The
   **Appraisal Assistant** now appears in the agents list / right-hand panel.
5. Select it and use a conversation starter, e.g. *"Overall performance feedback
   for jane@contoso.com, 2026-01-01 to 2026-06-01. Here is their self-input:
   [paste]. Summarize evidence under BD Values, Leadership Commitments, and
   Mindset."*

### Via the Microsoft 365 Agents Toolkit (optional, for richer dev loop)
If you prefer an in-editor flow: install the **Microsoft 365 Agents Toolkit**
extension in VS Code, open this folder, sign in to your M365 account, and use the
toolkit to preview/provision. (The toolkit can also generate its own
`m365agents.yml` build config if you want its full lifecycle pipeline.)

---

## Step 3 — Update the agent later

1. Edit `appPackage/declarativeAgent.json` (instructions, starters, capabilities).
2. **Bump the version** in `appPackage/manifest.json` (e.g. `1.0.0` → `1.0.1`).
   Copilot/Teams uses this to recognise an update.
3. Re-run `.\build.ps1`.
4. Re-upload the new zip (Teams → Manage your apps → your app → **Update**, or
   re-upload as a custom app).

Because everything is in Git, you get full history and diffs on the instructions.
Typical workflow: branch → edit → `build.ps1` → upload to test → merge → re-upload.

---

## Sharing with colleagues

Each colleague needs their **own Microsoft 365 Copilot license**. The agent runs
in **each user's own data context** — when a colleague uses it, it reads *their*
emails and meeting notes, not yours. That's exactly what you want for an appraisal
tool used by several managers, and permission-trimming is enforced automatically.

| How to share | Who gets it | Admin needed? |
|---|---|---|
| Send them `appraisal-agent.zip` to upload themselves | The people you send it to | Needs custom app upload enabled for them |
| Share from within the agent (share link) | Named people you choose | Often works; depends on tenant sharing settings |
| Publish to the **org app catalog** | Everyone in the org | **Yes — admin approval required** |

Recommended path: use it yourself → share the zip with a couple of fellow managers
to validate → then ask an admin to publish org-wide.

---

## Troubleshooting

- **No "Upload a custom app" option** → your tenant has custom app upload disabled;
  an admin must enable *Upload custom apps* (Teams admin center → Setup policies).
- **Agent doesn't appear in Copilot after upload** → confirm you have a Copilot
  license; wait a minute and refresh; check the upload succeeded under *Manage your
  apps*.
- **Agent finds emails but not meeting notes** → see Step 0; this is a Loop/Copilot
  indexing matter, not an agent config issue.
- **Manifest/schema errors on upload** → verify `manifest.json` `version` was bumped
  and the zip has files at its root (not nested in `appPackage/`).

---

## Notes & limitations

- **Date ranges are best-effort.** Copilot retrieves semantically, not via an exact
  `date BETWEEN` query. State dates clearly and spot-check the results.
- **No custom UI.** It's a chat experience inside Copilot/Teams — no date-picker or
  employee dropdown. For a full app UI you'd move to a pro-code Graph + Azure OpenAI
  build (which reintroduces app registration and admin consent).
- **Drafts only.** The agent summarizes evidence; it does not make hiring,
  promotion, or termination recommendations.
