FROM node:16 AS development

# Ustawienie katalogu roboczego
WORKDIR /app

# Kopiowanie plików package.json i package-lock.json
COPY package*.json ./

# Instalacja zależności npm
RUN npm install

# Kopiowanie całej aplikacji
COPY ./ ./ 

# Otwieramy port 3000
EXPOSE 3000
