# This repository is to execute CICD pipeline for one2onetool application which contains: Dockerfile, Jenkinsfile and sourceCode. 

 ## Configured multi pipeline to trigger the Jenkins job and the branch specific Jenkinsfile to cover the following functionalities. 
    1. Build - Build the application.
    2. Test - Execute the application testcases.
    3. BuildImage - The docker image is created for one2onetool application.
    4. UploadImage - the built docker image is uploaded into DockerHub repo.
    5. PullImage - the image will be pulled from dockerhub repo.
    6. DeployImage - Image is deployed in aws cloud ec2 instance.
    
 ## Instructins to run the job:
    1. Fork the repository to make your change, once changes done do commits to this branch, the jenkins job will trigger & execute automatically.
    2. The Jenkins pipeline set up is already completed. It is needed set up for this CI & CD execution.
    3. The image will be build and deploys/runs in aws containered environment. The container infrasturcture is needed in aws.
    4. This branch will take Questions.json as input datafile.

## Please note:
    1. I have started docker image on (aws linux)docker as I need more space for kubernates/minikube setup.
    2. The snapshots of Jenkins Jobs, images and containers will be send to received assessment email.

## URLs:
    1. For one2onetool images : https://hub.docker.com/repository/docker/venkatkrishnat/assessment
    2. For GitHub SoureCode : https://github.com/venkat-krishna-t/one2onetool.git    
