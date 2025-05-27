FROM node:17-alpine

WORKDIR /app

COPY express_app/package*.json ./
RUN npm install

COPY express_app/ .

CMD [ "npm", "start" ]

EXPOSE 3000