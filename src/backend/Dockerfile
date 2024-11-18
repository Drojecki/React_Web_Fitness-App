# Backend Dockerfile

# Wybór obrazu bazowego
FROM node:16

WORKDIR /app

# Kopiowanie plików package.json i instalowanie zależności
COPY ./package*.json ./
RUN npm install

# Kopiowanie plików backendu do kontenera
COPY ./ ./src


COPY .env .env

# Eksponowanie portu, na którym działa backend
EXPOSE 5000

# Uruchamianie serwera
CMD ["node", "src/server.js"]
