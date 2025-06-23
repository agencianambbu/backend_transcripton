# Etapa de build
FROM node:20-alpine as build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Etapa de produção
FROM node:20-alpine

WORKDIR /app

COPY --from=build /app ./
COPY --from=build /app/build ./

ENV NODE_ENV=production
EXPOSE 3333

CMD ["node", "build/server.js"]
