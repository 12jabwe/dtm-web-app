#!/bin/bash
# Step 1: Set Supabase Secrets
# Run this script to configure your Resend API key and email settings

echo "🔐 Setting Supabase Secrets..."
echo ""

# Set Resend API Key (export RESEND_API_KEY in your shell first)
if [ -z "$RESEND_API_KEY" ]; then
    echo "❌ Set RESEND_API_KEY in your environment before running this script."
    exit 1
fi
echo "Setting RESEND_API_KEY..."
supabase secrets set RESEND_API_KEY="$RESEND_API_KEY"

if [ $? -eq 0 ]; then
    echo "✅ RESEND_API_KEY set successfully"
else
    echo "❌ Failed to set RESEND_API_KEY"
    exit 1
fi

echo ""

# Set From Email
echo "Setting FROM_EMAIL (using Resend test domain)..."
supabase secrets set FROM_EMAIL=onboarding@resend.dev

if [ $? -eq 0 ]; then
    echo "✅ FROM_EMAIL set successfully"
else
    echo "❌ Failed to set FROM_EMAIL"
    exit 1
fi

echo ""
echo "✅ All secrets configured successfully!"
echo ""
echo "Next step: Deploy the function"
echo "Run: supabase functions deploy send-data-export-email"

