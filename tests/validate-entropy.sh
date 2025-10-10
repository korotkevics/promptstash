#!/bin/bash
set -e

# Minimum required entropy per prompt (in bits)
# The threshold of 6.3 bits was determined empirically by analyzing a set of high-quality prompts.
# Prompts with entropy below this value tend to be overly repetitive or lack vocabulary diversity,
# which can negatively impact model performance and generalization. Adjust this value if your
# prompt set has different characteristics, but ensure that lower values are justified by the
# intended use case and do not compromise prompt quality.
MIN_ENTROPY=6.3

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Validating entropy in prompt files..."

ERRORS=0
CHECKED=0
VIOLATIONS=()

# Check if Python and required modules are available
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Error: python3 not found${NC}"
    exit 1
fi

# Create a temporary Python script to calculate entropy
TEMP_SCRIPT=$(mktemp /tmp/validate-entropy.XXXXXX)
chmod 600 "$TEMP_SCRIPT"
trap "rm -f $TEMP_SCRIPT" EXIT

cat > "$TEMP_SCRIPT" << 'PYTHON_EOF'
import sys
import math

try:
    import tiktoken
except ImportError:
    print("Error: tiktoken is not installed.", file=sys.stderr)
    print("Please install it with: pip install tiktoken", file=sys.stderr)
    sys.exit(1)

TOKENIZER = tiktoken.get_encoding("cl100k_base")

def calculate_entropy(text):
    """Calculate Shannon entropy of text.

    H = -Σ(p(token) * log₂(p(token))) where p(token) = frequency/total
    """
    if not text:
        return 0.0

    tokens = TOKENIZER.encode(text)
    if not tokens:
        return 0.0

    # Count token frequencies
    token_counts = {}
    for token in tokens:
        token_counts[token] = token_counts.get(token, 0) + 1

    # Calculate Shannon entropy
    total_tokens = len(tokens)
    entropy = 0.0

    for count in token_counts.values():
        probability = count / total_tokens
        entropy -= probability * math.log2(probability)

    return entropy

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Error: No file path argument provided.", file=sys.stderr)
        print(f"Usage: {sys.argv[0]} <file_path>", file=sys.stderr)
        sys.exit(1)
    file_path = sys.argv[1]
    try:
        with open(file_path, 'r') as f:
            content = f.read()
    except OSError as e:
        print(f"Error: Could not open or read file '{file_path}': {e}", file=sys.stderr)
        sys.exit(1)
    entropy = calculate_entropy(content)
    print(f"{entropy:.2f}")
PYTHON_EOF

# Find all markdown files in .promptstash
while IFS= read -r md_file; do
  filename=$(basename "$md_file")

  # Exclude optimize-prompt.md from checking
  # Reason: 'optimize-prompt.md' contains optimization instructions or meta-prompts,
  # which are not subject to entropy validation as they do not represent user-facing prompts.
  if [ "$filename" = "optimize-prompt.md" ]; then
    continue
  fi

  CHECKED=$((CHECKED + 1))
  entropy=$(python3 "$TEMP_SCRIPT" "$md_file")

  # Compare entropy using awk for floating point comparison
  if awk -v e="$entropy" -v min="$MIN_ENTROPY" 'BEGIN { exit !(e < min) }'; then
    ERRORS=$((ERRORS + 1))
    deficit=$(awk -v min="$MIN_ENTROPY" -v e="$entropy" 'BEGIN { printf "%.2f", min - e }')
    VIOLATIONS+=("$filename: $entropy bits (below minimum by $deficit)")
  fi
done < <(find .promptstash -name "*.md")

echo ""
echo "Checked $CHECKED prompt files"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All prompts meet the minimum entropy of $MIN_ENTROPY bits!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS prompt(s) below the $MIN_ENTROPY bits minimum entropy:${NC}"
  echo ""
  for violation in "${VIOLATIONS[@]}"; do
    echo -e "  ${YELLOW}•${NC} $violation"
  done
  echo ""
  echo -e "${YELLOW}Suggestions:${NC}"
  echo "  1. Increase vocabulary diversity in the listed prompts"
  echo "  2. Avoid repetitive phrases and use varied terminology"
  echo "  3. If the low entropy is justified, adjust MIN_ENTROPY in tests/validate-entropy.sh"
  exit 1
fi
