FROM mcr.microsoft.com/appsvc/node:10-lts

ENV HOST 0.0.0.0
ENV PORT 8000
EXPOSE 8000

ENTRYPOINT ["pm2", "start", "--no-daemon", "dist/main.js"]