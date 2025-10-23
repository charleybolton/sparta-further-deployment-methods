FROM node:20
LABEL description="Sparta test app container"
WORKDIR /usr/src/app
COPY app /usr/src/app
COPY package*.json . 
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]
# CMD ["bash", "-c", "node seeds/seed.js && node app.js"]