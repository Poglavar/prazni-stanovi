#!/bin/bash

# Deploy script for the prazni stanovi site
# Deploys to zagreb.lol/praznistanovi/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load Cloudflare credentials (CF_ZONE_ID, CF_API_KEY)
if [ -f "$SCRIPT_DIR/.env" ]; then
    set -a; source "$SCRIPT_DIR/.env"; set +a
fi

# Configuration
SSH_HOST="root@67.205.138.129"
REMOTE_PATH="/var/www/zagreb.lol/praznistanovi"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Starting deployment to zagreb.lol/praznistanovi/${NC}"

# Check if SSH key exists
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo -e "${RED}❌ SSH key not found at ~/.ssh/id_ed25519${NC}"
    exit 1
fi

echo -e "${YELLOW}📁 Ensuring remote directory exists...${NC}"
ssh -i ~/.ssh/id_ed25519 $SSH_HOST "mkdir -p $REMOTE_PATH"

echo -e "${YELLOW}📤 Uploading files...${NC}"
scp -i ~/.ssh/id_ed25519 index.html $SSH_HOST:$REMOTE_PATH/
scp -i ~/.ssh/id_ed25519 praznistanovi.json $SSH_HOST:$REMOTE_PATH/
scp -i ~/.ssh/id_ed25519 praznistanovi.css $SSH_HOST:$REMOTE_PATH/
scp -i ~/.ssh/id_ed25519 prazni-stanovi-primjer1.png $SSH_HOST:$REMOTE_PATH/
scp -i ~/.ssh/id_ed25519 drone.svg $SSH_HOST:$REMOTE_PATH/
scp -i ~/.ssh/id_ed25519 sobe.svg $SSH_HOST:$REMOTE_PATH/

# Set proper permissions
echo -e "${YELLOW}🔐 Setting permissions...${NC}"
ssh -i ~/.ssh/id_ed25519 $SSH_HOST "chmod -R 755 $REMOTE_PATH"
ssh -i ~/.ssh/id_ed25519 $SSH_HOST "chown -R www-data:www-data $REMOTE_PATH"

# Test if nginx is running and reload if needed
echo -e "${YELLOW}🔄 Checking nginx configuration...${NC}"
ssh -i ~/.ssh/id_ed25519 $SSH_HOST "nginx -t && systemctl reload nginx"

echo "Purging Cloudflare cache..."
result=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/purge_cache" \
    -H "Authorization: Bearer ${CF_API_KEY}" \
    -H "Content-Type: application/json" \
    --data '{"purge_everything":true}')
if echo "$result" | python3 -c "import sys,json; r=json.load(sys.stdin); sys.exit(0 if r['success'] else 1)" 2>/dev/null; then
    echo "Cache purged OK."
else
    echo "Cache purge failed: $result"
    exit 1
fi

echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "${GREEN}🌐 Site available at: https://zagreb.lol/praznistanovi/${NC}"
