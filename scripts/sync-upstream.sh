#!/bin/bash
set -e

echo "🔄 Syncing with upstream gvisor-tap-vsock..."

# Fetch upstream
git fetch upstream

# Get latest upstream tag
UPSTREAM_TAG=$(git describe --tags --abbrev=0 upstream/main 2>/dev/null || echo "unknown")
echo "   Latest upstream: $UPSTREAM_TAG"

# Get current base version (from our tag)
CURRENT_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "none")
echo "   Current fork: $CURRENT_TAG"

# Check if upstream has new commits
BEHIND=$(git rev-list --count HEAD..upstream/main)
if [ "$BEHIND" -eq 0 ]; then
    echo "✅ Fork is up to date with upstream"
    exit 0
fi

echo "⚠️  Upstream has $BEHIND new commits"
echo ""
echo "To merge upstream changes:"
echo "  1. Review changes: git log HEAD..upstream/main --oneline"
echo "  2. Merge: git merge upstream/main"
echo "  3. Resolve conflicts in pkg/services/dns/dns.go if any"
echo "  4. Test: make test"
echo "  5. Tag new version: git tag v{UPSTREAM}-dualeai.{N}"
echo "  6. Push: git push origin main --tags"
exit 1
