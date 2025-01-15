### Development stage
FROM node:18-alpine as development-stage

RUN apk add --no-cache git && adduser --disabled-password --home /app --shell /bin/bash app
RUN corepack enable && corepack prepare pnpm@9.10.0 --activate

ARG PROJECT_FOLDER

WORKDIR /app
COPY clients/${PROJECT_FOLDER}/client-frontend/  ./
COPY inuits-dams-pwa  /app/inuits-dams-pwa
COPY modules /app/inuits-dams-graphql-service/modules
COPY packages /app/inuits-dams-graphql-service/packages
RUN pnpm i && pnpm run generate

RUN mkdir -p /app/node_modules/.vite && chown -R node:node /app/node_modules/.vite

WORKDIR /app/inuits-dams-graphql-service

WORKDIR /

COPY docker-compose/frontend/entrypoint.sh ./

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
USER root

EXPOSE 4001 8080