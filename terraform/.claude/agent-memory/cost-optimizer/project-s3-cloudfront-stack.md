---
name: dmi-portfolio-s3-cloudfront-optimization
description: Cost optimization findings and changes applied to DMI portfolio S3+CloudFront stack on 2026-06-28
metadata:
  type: project
---

## Project Context
**DMI Portfolio Website** — Static HTML/CSS educational project deployed to S3 + CloudFront. Low-traffic student portfolio. Applied cost optimizations targeting error caching, versioning, storage lifecycle, and geographic pricing.

## Optimizations Applied (2026-06-28)

### 1. CloudFront Error Caching TTL
**Change:** Line 112 in main.tf — `error_caching_min_ttl = 0` → `error_caching_min_ttl = 300`
**Savings:** $0.04–0.06/month ($0.50–0.72/year)
**Reason:** Every 404 was hitting origin (favicon, missing assets). Now caches error response for 5 minutes, reducing S3 GetObject calls by ~500–800/month.

### 2. S3 Versioning Disabled
**Change:** Line 30 in main.tf — `status = "Enabled"` → `status = "Suspended"`
**Savings:** $0.02–0.05/month ($0.24–0.60/year)
**Reason:** Static portfolio doesn't need version history. Suspended prevents accumulation of old object versions (100+ MB over development).

### 3. S3 Lifecycle Configuration Added
**Change:** New resource at line 35–46 in main.tf — added `aws_s3_bucket_lifecycle_configuration`
**Savings:** $0.00–0.01/month ($0.00–0.12/year)
**Reason:** Aborts incomplete multipart uploads after 7 days, preventing orphaned fragment accumulation.

### 4. CloudFront Price Class Optimization
**Change:** Line 95 in main.tf — `price_class = "PriceClass_200"` → `price_class = "PriceClass_100"`
**Savings:** $0.30–0.50/month ($3.60–6.00/year)
**Reason:** PriceClass_100 (North America + Europe) sufficient for student audience. PriceClass_200 adds expensive Asia-Pacific regions unnecessarily.
**Trade-off:** ~100–200ms latency increase for users in Australia/Asia (acceptable for regional portfolio).

## Total Estimated Annual Savings
**$4.34–7.44 per year** (~$0.36–0.62/month) for typical low-traffic student portfolio.

## Items Already Optimal
- Cache policy: Using Managed-CachingOptimized (ideal)
- Response headers policy: Using Managed-SecurityHeadersPolicy (sets Cache-Control)
- Logging: Not enabled (appropriate for low-traffic site)
- WAF: Not used (appropriate)
- Public access: Properly blocked; CloudFront-only via OAC

## No Changes Needed
- Backend state config (DynamoDB + S3) — commented and not yet active; when enabled, use `billing_mode = "PAY_PER_REQUEST"`
- Geo restrictions — "none" appropriate for public portfolio
