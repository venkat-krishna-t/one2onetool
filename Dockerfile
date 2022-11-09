FROM mhart/alpine-node

MAINTAINER VENKAT

#copy sourcde inside image
COPY .  /home/ec2-user/opt/one2onetool

#Provide permissions for the application dir and remove tmp files
RUN chmod -R 755 /home/ec2-user/opt/one2onetool

#Port expose
EXPOSE 3000

#Run the one2onetool application
WORKDIR /home/ec2-user/opt/one2onetool
CMD ["node", "index.js"]
