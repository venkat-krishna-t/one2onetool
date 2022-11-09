Exception_Start_Tag = "Jenkins stage exception: "
Exception_End_Tag = "Exit Pipeline execution "
REPO_PATH= 'repository/docker/venkatkrishnat/assessment'
IMAGE_TAG_NAME = 'one2onetool'
IMAGE_TAG_VERSION = '1.0'
ARTIFACTORY_REPO = 'registry.hub.docker.com'

pipeline {
    agent {
        node {
            label 'master'
        }
    }
    stages {
		stage("Clean Workspace") {
			steps {
				script {
					echo "Clearing the working directory"
					cleanWs()
				}
			}
		}
		stage("CheckoutCode") {
			steps {
				script {					   							
					dir("${env.WORKSPACE}") {
						echo " Check out the source code"
						checkout([$class: 'GitSCM', branches: [[name: 'staging']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub_Secret', url: 'https://github.com/venkat-krishna-t/one2onetool.git']]])
					}
				}
			}
			post {        
				failure {
					script {
						echo " Jenkins job failed - Sending Mail"
						EXCEPTION_LOG = Exception_Start_Tag + "Stage CheckoutCode failed " + Exception_End_Tag
						sendEmail("${EXCEPTION_LOG}")
					}	
				}
			}
        }
        stage("Build") {
            steps {
				script {
					dir("${env.WORKSPACE}") {
						withEnv(["DATA_FILE=Questions-test.json"]) {
							echo " Build the one2onetool application"
							bat "npm install"
						}
					}
				}
            }
			post {        
				failure {
					script {
						echo " Jenkins job failed - Sending Mail"
						EXCEPTION_LOG = Exception_Start_Tag + "Stage Build failed " + Exception_End_Tag
						sendEmail("${EXCEPTION_LOG}")
					}	
				}
			}
        }
        stage("Test") {
            steps {
                script {
					dir("${env.WORKSPACE}") {
						withEnv(["DATA_FILE=Questions-test.json"]) {
							echo " Test the one2onetool application"
							bat "npm test"
						}
					}
				}
            }
			post {        
				failure {
					script {
						echo " Jenkins job failed - Sending Mail"
						EXCEPTION_LOG = Exception_Start_Tag + "Stage Test failed " + Exception_End_Tag
						sendEmail("${EXCEPTION_LOG}")
					}	
				}
			}
        }
		stage('Image build & Push Image to Artifactory') {
			steps {
				script {
					node('aws_docker_container_lx') {
						dir("${env.WORKSPACE}") {
							withCredentials([usernamePassword(credentialsId: 'DOCKERIDS', passwordVariable: 'PSW', usernameVariable: 'USR')]){
								sh """
								sudo docker login "${ARTIFACTORY_REPO}" --username $USR --password $PSW
								IMAGE_ID=$(sudo docker build --no-cache -t "${IMAGE_TAG_NAME}":\""${IMAGE_TAG_VERSION}"\" . | grep 'Successfully built' | cut -d" " -f3)
								echo "Image tagged to $IMAGE_ID "${ARTIFACTORY_REPO}"/"${REPO_PATH}""
								sudo docker tag $IMAGE_ID "${ARTIFACTORY_REPO}"/"${REPO_PATH}"
								echo "Image pushing to "${ARTIFACTORY_REPO}"/"${REPO_PATH}""
								sudo docker push "${ARTIFACTORY_REPO}"/"${REPO_PATH}"
								"""
							} 
						}
					}
				}
			}
			post {        
				failure {
					script {
						echo " Jenkins job failed - Sending Mail"
						EXCEPTION_LOG = Exception_Start_Tag + "Stage ImageBuild failed " + Exception_End_Tag
						sendEmail("${EXCEPTION_LOG}")
					}	
				}
			}
		}

	}
}
def sendEmail(error) {
	emailext (
			from: 'DevelopersRecipientProvider',
			to: 'RequesterRecipientProvider',
			subject: 'DevOps:Notf - CI/CD pipeline failed',
			mimeType: 'text/html',
			body: '<br>\n\n Error: ${error}<br>'
	)
	
}
