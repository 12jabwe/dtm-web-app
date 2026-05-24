#!/bin/bash
# Deploy Stripe edge functions after rotating STRIPE_SECRET_KEY in Supabase.
# Usage:
#   export STRIPE_SECRET_KEY=sk_live_...
#   ./scripts/rotate-stripe-deploy.sh

set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v supabase &>/dev/null; then
  echo "❌ Install Supabase CLI: npm install -g supabase"
  exit 1
fi

if [ -z "${STRIPE_SECRET_KEY:-}" ]; then
  echo "❌ Export STRIPE_SECRET_KEY before running this script."
  exit 1
fi

echo "🔐 Setting Supabase secrets..."
supabase secrets set \
  STRIPE_SECRET_KEY="$STRIPE_SECRET_KEY" \
  ${STRIPE_PUBLISHABLE_KEY:+STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY"}

echo "📦 Deploying Stripe functions..."
supabase functions deploy \
  create-stripe-checkout \
  create-payment-intent \
  create-checkout \
  handle-stripe-webhook \
  handle-stripe-webhook-complete \
  handle-payment-webhook

echo "✅ Done. Test checkout in the app."
