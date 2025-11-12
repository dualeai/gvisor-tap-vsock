# Duale AI Custom Changes

## DNS Zones Whitelist Support

**File:** `pkg/services/dns/dns.go`
**Function:** `addLocalAnswers()`
**Lines:** 69-73

**Change:**
```go
// Allow forwarding to upstream when IP is nil/empty
// Enables whitelist filtering: domains with nil IP forward upstream,
// unlisted domains blocked by defaultIP
if record.IP == nil || record.IP.Equal(net.IP{}) {
    return false  // Forward to upstream DNS
}
```

**Rationale:**
Enables whitelist filtering - domains with nil IP forward to upstream,
unlisted domains blocked by defaultIP.

**Usage Example:**
```json
{
  "name": "",
  "records": [
    {"name": "google.com", "IP": null}
  ],
  "defaultIP": "0.0.0.0"
}
```
- `google.com` → forwards to upstream DNS → resolves normally
- `evil.com` → blocked by defaultIP → returns 0.0.0.0

**Upstream PR:** TBD (consider contributing back)
**Discussion:** Internal requirement for secure code sandbox networking
