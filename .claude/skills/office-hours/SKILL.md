---
name: office-hours
description: >
  Product interrogation before commitment. Challenges whether you're solving
  the right problem for the right user at the right time. Use when starting
  a feature, exploring an idea, or before writing a spec. Triggers: "should I
  build this", "office hours", "is this worth building", "product check",
  "challenge this idea".
argument-hint: "<one-line description of what you're thinking about building>"
---

# Office Hours: Product Interrogation

Challenge whether to build something before committing. Not brainstorming (test
the idea you brought). Not a spec (use `/spec-out` after). Not council
(product decisions, not technical).

## Positioning

- **Upstream of council**: office-hours challenges _whether_ to build; council
  challenges _how_ to build
- **Upstream of /spec-out**: office-hours challenges the _why_; spec-out
  clarifies the _what_
- **Flow**: `/office-hours` → `/spec-out` or `/design` → council seats

## Process

### 1. Frame the idea

Restate the user's idea in one sentence. Confirm you understand before
questioning.

### 2. Seven-question framework

Ask questions **one at a time**. Wait for the answer before asking the next.
Follow up on weak or vague answers before moving on.

Three acts, adaptive questioning:

#### Act I — The User

**Q1. Who specifically?**
Name the person, not a persona or segment. "Mobile developers who deploy to
TestFlight weekly" — not "developers." If the user can't name someone specific,
stay on this question.

**Q2. What job are they hiring this to do?**
A verb and outcome in the _user's_ language, not the builder's. Apply the
Jobs-to-Be-Done framework (see `references/jobs-to-be-done.md`). The job
exists independent of your solution.

#### Act II — The Problem

**Q3. What happens if you don't build this?**
Concrete cost to the user. Not "they'd be disappointed" — what breaks, what
takes longer, what stays impossible? If the answer is "nothing much," that's a
signal.

**Q4. What are you assuming about user behavior?**
The riskiest assumption, stated as a falsifiable claim. "I assume users will
check this dashboard daily" is testable. "Users want better tools" is not.

#### Act III — The Bet

**Q5. Smallest version that tests the hypothesis?**
Not MVP — the _experiment_. What can you build in days (not weeks) that proves
or disproves the riskiest assumption from Q4?

**Q6. What would make you kill this in 3 months?**
A measurable kill signal. This question is **non-negotiable** — always ask it.
If the user can't define failure, they can't define success.

**Q7. How much time is this worth?**
Shape Up appetite: not how long it _will_ take, but how much you'd _bet_.
"Two days of effort, max" is an appetite. "However long it takes" is a blank
check.

### Adaptation rules

- **Minimum 3 questions**: Q1, Q3, Q6 (always asked)
- **Maximum 7 questions**: all seven
- **Stay on Act I** if the user is poorly defined — don't advance until Q1 has
  a real person
- **Skip to Q6** if the problem is hypothetical or the user seems to be
  exploring rather than committing
- **Skip Q2** if the user already described the job clearly in their framing
- **Skip Q5** if the user already described a minimal experiment
- **Skip Q7** if the user volunteered a time constraint

### 3. Synthesize the verdict

After questioning, produce the verdict using this template:

```markdown
## Office Hours: {Title}

**Date:** {YYYY-MM-DD}
**Verdict:** BUILD | NARROW | DEFER | KILL

### The User

{Who, specifically — from Q1}

### The Job

{What they're hiring this to do — from Q2}

### The Hypothesis

{The riskiest assumption, stated as falsifiable claim — from Q4}

### The Bet

{Smallest experiment + appetite — from Q5/Q7}

### Kill Signal

{What kills this in 3 months — from Q6}

### What I Noticed

{Patterns, contradictions, unstated assumptions surfaced during questioning.
Be direct. This is the value-add beyond the user's own answers.}
```

### Verdict criteria

| Verdict    | Criteria                                                                   |
| ---------- | -------------------------------------------------------------------------- |
| **BUILD**  | User real, problem concrete, hypothesis falsifiable, appetite proportional |
| **NARROW** | Good instincts, scope outpaces evidence — reduce to what you can prove     |
| **DEFER**  | Interesting, insufficient evidence — name what to learn first              |
| **KILL**   | No real user, hypothetical problem, or unfalsifiable bet — stop here       |

## Anti-patterns

- **Generating ideas**: test the idea the user brought, don't brainstorm
  alternatives (use `/brainstorm` for that)
- **Writing specs**: the verdict points to next steps, it doesn't define them
- **Being encouraging**: the value is honest challenge, not validation
- **Asking all seven questions mechanically**: adapt to what the user reveals
