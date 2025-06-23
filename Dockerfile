# Use a imagem oficial do Node.js como base
FROM node:18-alpine

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos de dependências primeiro (para aproveitar o cache do Docker)
COPY package*.json ./

# Instala as dependências
RUN npm ci --only=production && npm cache clean --force

# Copia o resto do código da aplicação
COPY . .

# Cria um usuário não-root para executar a aplicação
RUN addgroup -g 1001 -S appuser
RUN adduser -S appuser -u 1001 -G appuser

# Garante que as pastas necessárias existem e têm as permissões corretas
RUN mkdir -p /app/database /app/providers /app/contracts && \
    chown -R appuser:appuser /app

USER appuser

# Expõe a porta (padrão Heroku usa $PORT ou 3000)
EXPOSE $PORT

# Define variáveis de ambiente
ENV NODE_ENV=production

# Comando para executar a aplicação
CMD ["npm", "start"]