FROM mhart/alpine-node

#copy sourcde inside image
COPY -rp * /tmp/one2onetool
COPY -rp /tmp/one2onetool /app/

#Provide permissions for the application dir and remove tmp files
RUN rm -rf /tmp/one2onetool/ && \
    chmod -R 755 /app/one2onetool
#Port expose
EXPOSE 3000

#Run the one2onetool application
WORKDIR /app
CMD ["node", "/app/index.js"]
