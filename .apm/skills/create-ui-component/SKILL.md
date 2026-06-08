---
name: create-ui-component
description: Guidance for building accessible, testable frontend UI components.
---
# Skill: Create UI Component

## Purpose
Produce a reusable, accessible, and testable UI component that aligns with the project's design system and conventions.

## Prerequisites
- Component purpose, props, and states are defined in the design spec.
- UI framework and design system are defined in `TECH.md`.

## Checklist
1.  **Component Design**: Follow single responsibility. Define the props/interface first. Provide default props.
2.  **Implementation**: Keep the component pure. Extract complex logic to a custom hook. Use design system tokens, not inline styles. Handle all visual states (loading, empty, error).
3.  **Accessibility (a11y)**: Use semantic HTML. Ensure keyboard navigation. Add ARIA attributes only when necessary. Don't rely on color alone to convey state.
4.  **State Management**: Use local state first. Lift state only when needed. Use global state for app-wide concerns.
5.  **Testing**: Test rendered output and user interactions, not implementation details. Cover all visual states. Use accessible queries. Mock external dependencies.
6.  **Documentation**: Add JSDoc for complex props. Export from the barrel file.

## Quality Bar
- Renders correctly in all visual states.
- Keyboard-operable and accessible.
- Tested for each state and user interaction.
- No hardcoded styles outside the design system.
