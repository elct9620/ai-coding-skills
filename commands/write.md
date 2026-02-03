---
name: write
description: Implement features based on the agent skills.
disable-model-invocation: true
argument-hint: feature|id
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Skill(coding:clean-architecture), Skill(coding:domain-modeling), Skill(coding:pricinples), Skill(coding:design-patterns), Skill(coding:refactoring), Skill(coding:testing)
---

## Rule

The `<execute name="main">ARGUMENTS</execute>` is entry point for this command.

## Rubric

To select skills for implementing the feature, consider the following rubric:

| Skill                       | Description                                                                              |
|-----------------------------|------------------------------------------------------------------------------------------|
| `coding:clean-architecture` | No `docs/architecture.md` exists or the feature requires significant structural changes. |
| `coding:domain-modeling`    | The feature is related to business logic or domain entities.                             |
| `coding:pricinples`         | Fully new feature no existing code, following principles is essential.                   |
| `coding:design-patterns`    | The feature needs changes multiple components that can benefit from design patterns.     |
| `coding:refactoring`        | Need to change existing code to accommodate the new feature.                             |
| `coding:testing`            | Each new feature or behavior change requires apply testing.                              |

## Definition

<function name="overview">
    <description>Fast overview of the feature to implement, use keyword search to find relevant information in the codebase.</description>
    <parameter name="feature" type="string" description="The feature to implement." required="true"/>
    <step>1. read the specification of the feature, e.g. SPEC.md, issue tracker, project management tool</step>
    <step>2. use lightweight sub-agents to review codebase to understand current implementation related to the feature</step>
    <step>3. use `git log` to get context of recent changes related to the feature</step>
    <return>summary of the feature and current codebase context</return>
</function>

<function name="active-skills">
    <description>According to the feature requirements, determine which skills are needed to implement the feature.</description>
    <parameter name="overview" type="string" description="The overview of the feature and current codebase context." required="true"/>
    <step>1. analyze the overview with rubric of available skills</step>
    <step>2. select the skills that are most relevant to the feature implementation</step>
    <return>list of active skills needed for the feature implementation</return>
</function>

<procedure name="main">
    <parameter name="feature" type="string" description="The feature to implement." required="true"/>
    <step>1. enter the plan mode</step>
    <step>2. <execute name="overview" feature="$feature"/></step>
    <step>3. use ask question tool to clarify scope of the feature</step>
    <step>4. <execute name="active-skills" overview="$overview"/></step>
    <step>5. deeply understand the codebase related to the feature</step>
    <step>6. active skills to create implementation plan</step>
    <step>7. review the plan for completeness and correctness</step>
    <return>implementation plan for the feature</return>
</procedure>

## Task

<execute name="main">$ARGUMENTS</execute>
