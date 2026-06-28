---
name: tf-destroy
description: Safely destroy all Terraform-managed AWS infrastructure to avoid costs. Empties the S3 bucket first, then runs terraform destroy.
allowed-tools: Bash, Read
disable-model-invocation: true
---

Destroy all Terraform-managed infrastructure to bring cost to $0.

Step 1 — Get the S3 bucket name from Terraform state:
```
cd terraform && terraform output s3_bucket_name
```

Step 2 — Empty the S3 bucket including all versions and delete markers (required because force_destroy = false and versioning is enabled):
```
aws s3 rm s3://<bucket-name> --recursive

aws s3api delete-objects \
  --bucket <bucket-name> \
  --delete "$(aws s3api list-object-versions \
    --bucket <bucket-name> \
    --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}' \
    --output json)"

aws s3api delete-objects \
  --bucket <bucket-name> \
  --delete "$(aws s3api list-object-versions \
    --bucket <bucket-name> \
    --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' \
    --output json)"
```
Note: `aws s3 rm --recursive` only creates delete markers when versioning is enabled — the two `s3api` calls above permanently remove all versions and markers so the bucket can be deleted.

Step 3 — Run destroy:
```
cd terraform && terraform destroy -no-color
```
When prompted, type `yes` to confirm. If running non-interactively, use `-auto-approve`.

After destroy completes:
- [ ] Confirm all 6 resources were destroyed (S3 bucket, public access block, versioning, bucket policy, CloudFront OAC, CloudFront distribution)
- [ ] Report any resources that failed to destroy and why
- [ ] Confirm expected AWS cost is now $0

If destroy fails because the bucket is not empty, re-run Step 2 and retry.
If destroy fails for any other reason, show the error and wait for instructions — do NOT retry automatically.
