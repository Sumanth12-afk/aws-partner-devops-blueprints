FROM nginx:stable-alpine

# Minimal default static site for demo purposes
COPY README.md /usr/share/nginx/html/index.html

EXPOSE 80


