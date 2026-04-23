---
description: Guidance for building a well-structured, accessible, and testable frontend UI component aligned with the project's component model and design system.
---
# Skill: Create UI Component

## Purpose

Produce a reusable, accessible, and testable UI component that fits the project's design system, state management approach, and component conventions defined in TECH.md.

## When to Use

- Adding a new piece of UI that will be rendered in a browser.
- Extracting repeated markup/logic into a shared component.
- Building a form, table, modal, page section, or interactive widget.

## Prerequisites

- [ ] The component's purpose, props/inputs, and visual states are defined in the acceptance criteria or design spec.
- [ ] The UI framework and design system (e.g., Tailwind, MUI, shadcn/ui) are set in `.github/TECH.md` section 2.
- [ ] The project's component structure convention is understood (file location, naming, barrel exports).

## Checklist

### Component Design
1. **Single responsibility** — one component does one thing. If it does more than one thing, split it.
2. **Props/interface first** — define the component's TypeScript interface or prop types before writing the implementation.
3. **Default props** — provide sensible defaults for optional props.
4. **Controlled vs. uncontrolled** — decide explicitly; prefer controlled components for forms and interactive elements.

### Implementation
5. **Keep the component pure** where possible — derive output from props/state, avoid side effects in render.
6. **Extract logic** to a custom hook if the component has significant state or async behavior.
7. **Avoid inline styles** — use the project's design system tokens, utility classes, or styled components per TECH.md conventions.
8. **Handle all visual states explicitly**: loading, empty, error, success, disabled.

### Accessibility (a11y)
9. **Semantic HTML first** — use `<button>`, `<nav>`, `<main>`, `<section>` etc. before reaching for `<div>`.
10. **Keyboard navigation** — interactive elements must be focusable and operable via keyboard.
11. **ARIA attributes** — add `aria-label`, `aria-describedby`, `role` only when semantic HTML is insufficient.
12. **Color is not the only signal** — never rely on color alone to convey state (use icons, labels, or patterns too).

### State Management
13. **Local state first** — use component state (`useState`) for state that doesn't need to be shared.
14. **Lift state** only when two or more sibling components need to share it.
15. **Global state** (Redux, Zustand, Pinia, etc.) only for truly application-wide concerns.

### Testing
16. **Test rendered output and user interactions**, not internal component state.
17. **Cover all visual states** — render the component in each state (loading, error, success, empty).
18. **Test accessibility** — use testing-library's accessible queries (`getByRole`, `getByLabelText`) rather than `getByTestId`.
19. **Mock external dependencies** (API calls, context providers) at the component boundary.

### Documentation
20. **Add a JSDoc comment** for complex props or non-obvious behavior.
21. **Export from the appropriate barrel file** (`index.ts`) per project conventions.

## Quality Bar

- Component renders correctly in all defined visual states.
- Component is keyboard-operable and has no missing ARIA roles for interactive elements.
- At least one test per visual state and one test per user interaction.
- No hardcoded colors, sizes, or spacing outside the design system tokens.

## Common Pitfalls

- **God components** — a single component that handles too many concerns; split at natural boundaries.
- **Skipping loading/error states** — every async operation needs explicit UI feedback.
- **Inaccessible interactive elements** — `<div onClick>` instead of `<button>`; missing focus management in modals.
- **Prop drilling** — passing props through many layers instead of lifting to context or global state.
- **Testing implementation details** — asserting on CSS class names or internal state instead of visible behavior.
