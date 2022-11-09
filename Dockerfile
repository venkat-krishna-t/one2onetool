FROM mhart/alpine-node

MAINTAINER VENKAT

#copy sourcde inside image
COPY .  /app/one2onetool

#Provide permissions for the application dir and remove tmp files
RUN chmod -R 755 /app/one2onetool

#Port expose
EXPOSE 3000

#Run the one2onetool application
WORKDIR /app/one2onetool
CMD ["node", "index.js"]
