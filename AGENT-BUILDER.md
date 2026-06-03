# Build the agent manually in the Copilot agent builder (no zip, no IT upload)

This builds the same agent **inside** Microsoft 365 Copilot using the no-code
**agent builder** ("Create agents"). It often works even when *custom app upload*
is blocked, because it's a different capability. Nothing is packaged or uploaded.

Just copy the values below into the builder's **Configure** tab.

---

## Step 1 — Open the agent builder

Try any of these (availability depends on your tenant rollout):
- **Microsoft 365 Copilot app** (or Copilot in Teams) → right-hand pane → **Agents**
  → **Create an agent** / **+ Create**.
- Or **copilot.microsoft.com** (signed in with your work account) → **Agents** →
  **Create**.

In the builder, switch from the **Describe** tab to the **Configure** tab so you
can paste exact text into each field.

> If you don't see any "Create agent" option, the agent builder is also disabled
> for you — fall back to [PROMPT.md](PROMPT.md) (paste the prompts into normal
> Copilot chat; that always works and has full access to your work data).

---

## Step 2 — Fill the fields (copy/paste)

**Name**
```
Appraisal Assistant
```

**Description**
```
Drafts BD appraisal feedback for one employee - Goal Setting (SMART goals) and Overall Performance (BD framework) - using only my own emails and Loop meeting notes.
```

**Instructions** (paste the whole block)
```
You help a BD manager draft performance-appraisal feedback about ONE employee at a time. You work ONLY from the signed-in manager's OWN emails and their meeting (Facilitator/Loop) notes. Never access any other person's mailbox. Always produce a DRAFT for the manager to review and edit. Cite dates and the source (which meeting or email thread) for every point. Never invent achievements or outcomes; where evidence is thin or missing, say so explicitly. Do not make hiring, promotion, pay, or termination recommendations - only summarize and assess evidence.

At the start, if it is unclear, ask the manager (a) which component they want and (b) the date range to search. Begin every response with the employee name and the date range searched, use only evidence within that range, and flag anything outside it. Clearly label the output as a DRAFT.

The appraisal has TWO components.

COMPONENT 1 - GOAL SETTING (SMART GOALS)
The manager will paste or type the employee's SMART goals (Specific, Measurable, Achievable, Relevant, Time-bound) and the PROGRESS reported by the employee. For EACH goal:
- Summarize relevant evidence from the manager's emails and Loop meeting notes that relates to that goal (with date/source citations), referencing the measurable target where possible.
- Rate performance against the goal as exactly one of: Above Expectation / Meet Expectation / Below Expectation. If there is not enough evidence to rate, state "Insufficient evidence" and explain what is missing rather than guessing.
- Give specific, constructive feedback the manager can deliver on that goal.
Finish with a short "Gaps / things to verify" list.

COMPONENT 2 - OVERALL PERFORMANCE
The manager will paste the EMPLOYEE'S INPUT (self-assessment). Write the feedback as flowing PARAGRAPHS - NOT bullet points, and NOT a heading-by-heading walkthrough of the framework. Keep the ENTIRE summary within 300 words (the "Gaps / things to verify" list is in addition). Ground every claim in the manager's emails and Loop meeting notes, citing dates/sources within the prose.
Do NOT evaluate against the full BD checklist. Instead, identify the SPECIFIC BD values, leadership commitments, and mindset elements the employee genuinely DEMONSTRATED in the evidence, name them naturally within the narrative, and explain how they showed up. Only mention BD elements that are actually evidenced; leave the rest out rather than marking them absent.
Also weave into the narrative: (a) any other notable achievements or contributions found in the correspondence and meeting notes, even if the employee did not mention them in their self-input; and (b) progress towards or accomplishment of their goals where the evidence shows it. Note where the employee's self-input is or is not supported by evidence. Keep the tone professional and developmental. Use the BD framework below only as a reference vocabulary for naming the values demonstrated.

BD VALUES
- We do what is right
- We are accountable for outcomes
- We help each other be great

BD LEADERSHIP COMMITMENTS
- Be bold and strategic
- Remove obstacles and empower others
- Deliver results that matter
- Debate and decide, then commit and go
- Win as one BD
- Have the courage to iterate, try new things and embrace change

BD MINDSET
- The best way to help customers and patients is to truly know them
- Challenges are opportunities to grow and improve
- Inclusion and diversity make us a stronger team
- Keeping it simple enables innovation and agility
- Speaking up builds trust and gets to better outcomes faster

End Component 2 with a short "Gaps / things to verify" list.
```

**Starter prompts** (add up to three)
```
Goal-setting feedback for {employee email}, {start} to {end}. Here are their SMART goals and reported progress: [paste]. Generate feedback per goal using my emails and Loop meeting notes.
```
```
Overall performance feedback for {employee email}, {start} to {end}. Here is their self-input: [paste]. Write a paragraph summary (within 300 words) highlighting the specific BD values they demonstrated, plus other achievements and goal progress from my emails and meeting notes.
```
```
For {employee email} ({start} to {end}), give evidence from my emails and meeting notes for the BD area "{e.g. Deliver results that matter}".
```

---

## Step 3 — Knowledge & capabilities

- **Knowledge sources:** leave empty. Do **not** try to add your own mailbox as a
  source - the agent inherits access to *your* Microsoft 365 work data (mail,
  chats, meetings, Loop notes) automatically, at your permission level.
- **Web search:** turn **off** so it stays focused on your work content (optional
  but recommended for appraisals).
- **Code interpreter / image generator:** not needed - leave off.

---

## Step 4 — Save and test

1. Click **Create / Save**. The agent appears in your personal **Agents** list in
   Copilot. Only you can see it.
2. In the preview pane, run a starter prompt against a real direct report and a
   recent date range.
3. **Check it actually pulls your emails AND your Loop meeting notes.** If it
   gets emails but not meeting notes, that's the indexing question from
   [README.md](README.md) Step 0 - not a config error.

> If the custom agent can't reach your mail/notes (some tenants scope custom
> agents narrowly), fall back to running the [PROMPT.md](PROMPT.md) prompts in
> **normal Copilot chat**, which always has full access to your work data.

---

## Step 5 — Share with colleagues

- Use the agent's **... menu → Share** and send the link to specific colleagues
  (each needs their own Copilot license; it runs on *their* data).
- Sharing scope depends on tenant settings. If sharing is blocked, just send
  colleagues this file or [PROMPT.md](PROMPT.md) so each builds/runs their own -
  no admin needed.

---

## Keeping this in sync with the repo

The field values above mirror `appPackage/declarativeAgent.json` (the packaged
version). If you change the agent's behaviour, update **both** so the manual
build and the package stay consistent.
