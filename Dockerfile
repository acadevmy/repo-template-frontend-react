FROM node:lts-alpine AS base

ENV NODE_ENV $NODE_ENV

RUN mkdir -p /app
COPY . /app
WORKDIR /app

RUN yarn install
