#!/bin/bash
# Quick Resend API Setup Script
# Run these commands to set up your Resend API key

echo "🚀 Setting up Resend API Key for Data Export Emails..."
echo ""

# Set Resend API Key (export RESEND_API_KEY in your shell first)
if [ -z "$RESEND_API_KEY" ]; then
    echo "❌ Set RESEND_API_KEY in your environment before running this script."
    exit 1
fi
echo "Step 1: Setting Resend API Key..."
supabase secrets set RESEND_API_KEY="$RESEND_API_KEY"

# Set From Email (using Resend test domain for now)
echo "Step 2: Setting From Email (using Resend test domain)..."
supabase secrets set FROM_EMAIL=onboarding@resend.dev

echo ""
echo "✅ Secrets configured!"
echo ""
echo "Next steps:"
echo "1. Create the Edge Function: supabase functions new send-data-export-email"
echo "2. Add the function code (see RESEND-API-SETUP.md)"
echo "3. Deploy: supabase functions deploy send-data-export-email"
echo "4. Test by approving a download request in the admin panel"
echo ""
echo "🔒 Keep RESEND_API_KEY secure and never commit it to git!"

