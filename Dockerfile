FROM node:16-alpine3.11 AS base
RUN npm install -g npm@8.3.0
#RUN npm install -g @nestjs/cli
#RUN npm install -g rimraf@3.0.2

FROM base as build
ENV NODE_ENV development

WORKDIR /usr/src/app

COPY package*.json ./
COPY .npmrc /etc/secrets/.npmrc

RUN npm install

COPY .npmrc .npmrc

COPY . .

RUN rm -f .npmrc

RUN npm run build

FROM node:16-alpine3.11 

ENV NODE_ENV production

USER node
WORKDIR /usr/src/app

COPY --from=build --chown=node:node /usr/src/app/ ./

EXPOSE 8443

CMD ["node", "dist/main"]
