FROM node:22-alpine

WORKDIR /app

# Cài đặt package trước để tận dụng Docker cache layer
COPY package*.json ./
RUN npm install --production

# Copy toàn bộ mã nguồn
COPY . .

EXPOSE 3000

CMD ["node", "src/app.js"]
