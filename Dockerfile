FROM node:24.22.1-alpine AS build
WORKDIR /srv
COPY . .
ENV CYPRESS_INSTALL_BINARY=0
RUN npm ci
RUN npm run build

FROM nginx:alpine
STOPSIGNAL SIGQUIT
WORKDIR /srv
RUN apk --no-cache add gettext
COPY --from=build /srv/container/ /srv/
COPY --from=build /srv/dist /usr/share/nginx/html
ENTRYPOINT ["/srv/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
