# GitHub Actions OIDC integration
# Allows the CI/CD pipeline to assume an AWS role without long-lived credentials.
# Scoped strictly to pushes on the main branch via StringEquals (not StringLike).

resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  # Two thumbprints are provided: the current active cert and its backup.
  # GitHub rotated the intermediate CA in 2023 — both are required to remain
  # functional across any future rotation window.
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]

  tags = local.tags
}

resource "aws_iam_role" "github_actions" {
  name = "gauravkarkidmi-github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GitHubActionsOIDC"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            # StringEquals (not StringLike) locks this role to main-branch
            # push events only — no wildcard that could be abused by PRs
            # or other refs in the same repository.
            "token.actions.githubusercontent.com:sub" = "repo:karki2195/Ultimate-Agentic-DevOps-with-Claude-Code:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy" "github_actions_deploy" {
  name = "gauravkarkidmi-deploy-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObject",
        ]
        Resource = "arn:aws:s3:::gauravkarkidmi-website-072988571347/*"
      },
      {
        Sid      = "S3BucketList"
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "arn:aws:s3:::gauravkarkidmi-website-072988571347"
      },
      {
        Sid    = "CloudFrontInvalidation"
        Effect = "Allow"
        Action = "cloudfront:CreateInvalidation"
        # Distribution ARN uses the account ID from the existing data source
        # rather than hardcoding, keeping the policy self-consistent.
        Resource = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/E331CKNCFCURYX"
      },
    ]
  })
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role assumed by GitHub Actions via OIDC"
  value       = aws_iam_role.github_actions.arn
}
