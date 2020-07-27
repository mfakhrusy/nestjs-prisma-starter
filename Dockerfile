FROM node:12 AS builder

# Create app directory
WORKDIR /app

RUN npm install -g @prisma/cli --unsafe-perm

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
COPY prisma ./prisma/

# Install app dependencies
RUN npm install
# Required if not done in postinstall
# RUN prisma generate

COPY tsconfig*.json ./
COPY src ./src
# Copy for swagger and graphql plugin
COPY nest-cli.json ./nest-cli.json

RUN npm run build

FROM node:12

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD [ "npm", "run", "start:prod" ]
