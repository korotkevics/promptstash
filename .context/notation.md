# Logical Notation Reference

A comprehensive guide for converting natural language statements into formal logical notation using mathematical symbols.

## Basic Logical Operators

| Symbol | Name | Meaning | Example |
|--------|------|---------|---------|
| ∧ | Conjunction | AND | P ∧ Q (P and Q) |
| ∨ | Disjunction | OR | P ∨ Q (P or Q) |
| ¬ | Negation | NOT | ¬P (not P) |
| → | Implication | IF...THEN | P → Q (if P then Q) |
| ↔ | Biconditional | IF AND ONLY IF | P ↔ Q (P if and only if Q) |
| ⊕ | Exclusive OR | XOR | P ⊕ Q (P or Q but not both) |

## Quantifiers

| Symbol | Name | Meaning | Example |
|--------|------|---------|---------|
| ∀ | Universal | FOR ALL | ∀x P(x) (for all x, P(x) is true) |
| ∃ | Existential | THERE EXISTS | ∃x P(x) (there exists an x such that P(x)) |
| ∃! | Unique Existential | THERE EXISTS EXACTLY ONE | ∃!x P(x) (there exists exactly one x such that P(x)) |

## Set Theory Operators

| Symbol | Name | Meaning | Example |
|--------|------|---------|---------|
| ∈ | Element of | IS A MEMBER OF | x ∈ A (x is in set A) |
| ∉ | Not element of | IS NOT A MEMBER OF | x ∉ A (x is not in set A) |
| ⊂ | Proper subset | IS A PROPER SUBSET OF | A ⊂ B (A is a proper subset of B) |
| ⊆ | Subset | IS A SUBSET OF | A ⊆ B (A is a subset of or equal to B) |
| ⊃ | Proper superset | IS A PROPER SUPERSET OF | A ⊃ B (A is a proper superset of B) |
| ⊇ | Superset | IS A SUPERSET OF | A ⊇ B (A is a superset of or equal to B) |
| ∪ | Union | UNION | A ∪ B (union of A and B) |
| ∩ | Intersection | INTERSECTION | A ∩ B (intersection of A and B) |
| ∖ | Set difference | DIFFERENCE | A ∖ B (elements in A but not in B) |
| ∅ | Empty set | EMPTY SET | ∅ (the set with no elements) |

## Comparison Operators

| Symbol | Name | Meaning |
|--------|------|---------|
| = | Equals | IS EQUAL TO |
| ≠ | Not equals | IS NOT EQUAL TO |
| < | Less than | IS LESS THAN |
| > | Greater than | IS GREATER THAN |
| ≤ | Less than or equal | IS LESS THAN OR EQUAL TO |
| ≥ | Greater than or equal | IS GREATER THAN OR EQUAL TO |
| ≈ | Approximately equal | IS APPROXIMATELY EQUAL TO |
| ≡ | Equivalent | IS EQUIVALENT TO |

## Special Symbols

| Symbol | Name | Meaning |
|--------|------|---------|
| ⊤ | Tautology | ALWAYS TRUE |
| ⊥ | Contradiction | ALWAYS FALSE |
| ∴ | Therefore | THEREFORE |
| ∵ | Because | BECAUSE |
| ⊢ | Entails | PROVES/ENTAILS |
| ⊨ | Models | SATISFIES |
| ≔ | Definition | IS DEFINED AS |

## Common Patterns

### Conditional Statements

**Natural language:** "If it rains, then the ground is wet"
```
R → W
where R = "it rains", W = "the ground is wet"
```

**Natural language:** "It rains if and only if the sky is cloudy"
```
R ↔ C
where R = "it rains", C = "the sky is cloudy"
```

### Universal Statements

**Natural language:** "All humans are mortal"
```
∀x (H(x) → M(x))
where H(x) = "x is human", M(x) = "x is mortal"
```

**Natural language:** "Every student passed the exam"
```
∀x (S(x) → P(x))
where S(x) = "x is a student", P(x) = "x passed"
```

### Existential Statements

**Natural language:** "There exists a prime number greater than 100"
```
∃x (P(x) ∧ x > 100)
where P(x) = "x is prime"
```

**Natural language:** "Some students like math"
```
∃x (S(x) ∧ L(x))
where S(x) = "x is a student", L(x) = "x likes math"
```

### Negation Patterns

**Natural language:** "Not all birds can fly"
```
¬∀x (B(x) → F(x))
or equivalently:
∃x (B(x) ∧ ¬F(x))
where B(x) = "x is a bird", F(x) = "x can fly"
```

**Natural language:** "No cats are dogs"
```
¬∃x (C(x) ∧ D(x))
or equivalently:
∀x (C(x) → ¬D(x))
where C(x) = "x is a cat", D(x) = "x is a dog"
```

### Complex Statements

**Natural language:** "If someone is a student and studies hard, then they will pass"
```
∀x ((S(x) ∧ H(x)) → P(x))
where S(x) = "x is a student", H(x) = "x studies hard", P(x) = "x passes"
```

**Natural language:** "Either it's sunny or it's raining, but not both"
```
(S ∨ R) ∧ ¬(S ∧ R)
or more concisely:
S ⊕ R
where S = "it's sunny", R = "it's raining"
```

## De Morgan's Laws

Useful transformations for negations:

```
¬(P ∧ Q) ≡ ¬P ∨ ¬Q
¬(P ∨ Q) ≡ ¬P ∧ ¬Q
¬∀x P(x) ≡ ∃x ¬P(x)
¬∃x P(x) ≡ ∀x ¬P(x)
```

## Logical Equivalences

Common logical equivalences:

```
P → Q ≡ ¬P ∨ Q (Implication)
P ↔ Q ≡ (P → Q) ∧ (Q → P) (Biconditional)
P ∧ Q ≡ Q ∧ P (Commutativity)
P ∨ Q ≡ Q ∨ P (Commutativity)
P ∧ (Q ∨ R) ≡ (P ∧ Q) ∨ (P ∧ R) (Distributivity)
P ∨ (Q ∧ R) ≡ (P ∨ Q) ∧ (P ∨ R) (Distributivity)
¬¬P ≡ P (Double negation)
```

## Precedence (highest to lowest)

1. ¬ (Negation)
2. ∧ (Conjunction)
3. ∨ (Disjunction)
4. → (Implication)
5. ↔ (Biconditional)

Use parentheses to override precedence or improve clarity.

## Examples

### Example 1: Simple conditional
**Text:** "If you study, you will pass"
**Notation:** `S → P`

### Example 2: Conjunction
**Text:** "It is raining and cold"
**Notation:** `R ∧ C`

### Example 3: Universal with implication
**Text:** "All integers are either even or odd"
**Notation:** `∀x (I(x) → (E(x) ∨ O(x)))`

### Example 4: Complex nested statement
**Text:** "If a number is divisible by 6, then it is divisible by both 2 and 3"
**Notation:** `∀x (D(x,6) → (D(x,2) ∧ D(x,3)))`
where `D(x,y)` = "x is divisible by y"

### Example 5: Existential with negation
**Text:** "There is no largest prime number"
**Notation:** `¬∃x (P(x) ∧ ∀y (P(y) → y ≤ x))`
where `P(x)` = "x is prime"

## Tips for Translation

1. **Identify the main structure**: Is it conditional (→), conjunction (∧), disjunction (∨), or quantified (∀, ∃)?
2. **Define predicates clearly**: Use descriptive letters or words for predicates
3. **Watch for implicit quantifiers**: "Dogs bark" often means "All dogs bark" (∀x)
4. **Disambiguate scope**: Use parentheses liberally
5. **Check for negations**: "Not all" ≠ "None"
6. **Convert to standard form**: Rewrite natural language to match logical patterns

## Common Natural Language Indicators

- **Universal (∀)**: all, every, each, any, whenever
- **Existential (∃)**: some, there exists, at least one
- **Conjunction (∧)**: and, but, also, moreover
- **Disjunction (∨)**: or, either...or (inclusive)
- **Implication (→)**: if...then, implies, whenever, only if
- **Negation (¬)**: not, never, no, none
- **Biconditional (↔)**: if and only if, iff, necessary and sufficient
