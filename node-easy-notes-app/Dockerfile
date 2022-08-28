FROM node:18 AS build-env
COPY . /app
WORKDIR /app

RUN npm ci 

FROM gcr.io/distroless/nodejs:18
COPY --from=build-env /app /app
WORKDIR /app
CMD ["server.js"]
