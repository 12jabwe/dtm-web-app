#!/bin/bash

# ============================================
# COMPLETE DATA REQUEST EMAIL SYSTEM SETUP
# ============================================
# This script sets up the automatic email system
# Run: chmod +x setup-email-system.sh && ./setup-email-system.sh

set -e  # Exit on error

echo "============================================"
echo "🚀 DATA REQUEST EMAIL SYSTEM SETUP"
echo "============================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Check Supabase CLI
echo "📋 Step 1: Checking Supabase CLI..."
if ! command -v supabase &> /dev/null; then
    echo -e "${RED}❌ Supabase CLI not found${NC}"
    echo "Installing Supabase CLI..."
    npm install -g supabase
else
    echo -e "${GREEN}✅ Supabase CLI installed${NC}"
    supabase --version
fi
echo ""

# Step 2: Check if logged in
echo "📋 Step 2: Checking Supabase login..."
if ! supabase projects list &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in. Please login:${NC}"
    echo "Run: supabase login"
    exit 1
else
    echo -e "${GREEN}✅ Logged in to Supabase${NC}"
fi
echo ""

# Step 3: Check if project is linked
echo "📋 Step 3: Checking project link..."
if [ ! -f ".supabase/config.toml" ]; then
    echo -e "${YELLOW}⚠️  Project not linked${NC}"
    echo "Please run: supabase link --project-ref YOUR_PROJECT_REF"
    echo "Get your project ref from: https://supabase.com/dashboard"
    read -p "Enter your project reference ID: " PROJECT_REF
    supabase link --project-ref "$PROJECT_REF"
else
    echo -e "${GREEN}✅ Project linked${NC}"
fi
echo ""

# Step 4: Set Resend API Key
echo "📋 Step 4: Setting Resend API Key..."
if [ -z "$RESEND_API_KEY" ]; then
    echo -e "${RED}❌ Set RESEND_API_KEY in your environment before running this script.${NC}"
    exit 1
fi
supabase secrets set RESEND_API_KEY="$RESEND_API_KEY"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ RESEND_API_KEY set successfully${NC}"
else
    echo -e "${RED}❌ Failed to set RESEND_API_KEY${NC}"
    exit 1
fi
echo ""

# Step 5: Set From Email
echo "📋 Step 5: Setting From Email..."
supabase secrets set FROM_EMAIL=onboarding@resend.dev
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ FROM_EMAIL set successfully${NC}"
else
    echo -e "${RED}❌ Failed to set FROM_EMAIL${NC}"
    exit 1
fi
echo ""

# Step 6: Check if function exists
echo "📋 Step 6: Checking Edge Function..."
if [ ! -f "supabase/functions/send-data-export-email/index.ts" ]; then
    echo -e "${YELLOW}⚠️  Function not found. Creating...${NC}"
    supabase functions new send-data-export-email
    echo -e "${GREEN}✅ Function created${NC}"
    echo -e "${YELLOW}⚠️  Please copy the function code from:${NC}"
    echo "   supabase/functions/send-data-export-email/index.ts"
    echo ""
    read -p "Press Enter after you've added the function code..."
else
    echo -e "${GREEN}✅ Function file exists${NC}"
fi
echo ""

# Step 7: Deploy function
echo "📋 Step 7: Deploying Edge Function..."
supabase functions deploy send-data-export-email
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Function deployed successfully${NC}"
else
    echo -e "${RED}❌ Failed to deploy function${NC}"
    exit 1
fi
echo ""

# Step 8: Verify deployment
echo "📋 Step 8: Verifying deployment..."
supabase functions list | grep -q "send-data-export-email"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Function verified${NC}"
else
    echo -e "${RED}❌ Function not found in list${NC}"
fi
echo ""

# Step 9: SQL Scripts reminder
echo "============================================"
echo "📋 Step 9: Database Setup Required"
echo "============================================"
echo ""
echo "⚠️  IMPORTANT: Run these SQL scripts in Supabase Dashboard:"
echo ""
echo "1. Go to: https://supabase.com/dashboard"
echo "2. Select your project"
echo "3. Go to SQL Editor"
echo "4. Run the SQL from: add-data-export-url-column.sql"
echo "5. Run the SQL from: fix-data-requests-status-constraint.sql"
echo ""
read -p "Press Enter after running the SQL scripts..."
echo ""

# Final summary
echo "============================================"
echo "✅ SETUP COMPLETE!"
echo "============================================"
echo ""
echo "✅ Supabase CLI configured"
echo "✅ Project linked"
echo "✅ Secrets set (RESEND_API_KEY, FROM_EMAIL)"
echo "✅ Edge Function deployed"
echo ""
echo "📋 Next Steps:"
echo "1. Run SQL scripts in Supabase Dashboard (if not done)"
echo "2. Test by approving a download request in admin panel"
echo "3. Check email delivery at: https://resend.com/emails"
echo ""
echo "🧪 Test the function:"
echo "   supabase functions logs send-data-export-email"
echo ""
echo "🎉 Your email system is now live!"
echo ""

