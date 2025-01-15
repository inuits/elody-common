#!/bin/sh

set -e

echo "Starting dashboard"
chown -R node:node /app/node_modules/.vite
cd inuits-dams-pwa
pnpm run dev-only &

cd ../

echo "Starting graphql"
cd inuits-dams-graphql-service
exec pnpm run dev

