Exception_Start_Tag = "Jenkins stage exception: "
Exception_End_Tag = "Exit Pipeline execution "
def REPO_PATH= 'repository/docker/venkatkrishnat/assessment'
def ARTIFACTORY_REPO = "registry.hub.docker.com"

pipeline {
    agent {
        node {
            label 'master'
        }
    }
	environment {
		registry = "venkatkrishnat/assessment"
		registryCredential = 'dockerhub'
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
						checkoutCode()
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
							checkoutCode()
							withCredentials([usernamePassword(credentialsId: 'DOCKERIDS', passwordVariable: 'PSW', usernameVariable: 'USR')]){
								sh """
								sudo docker login "${ARTIFACTORY_REPO}" --username $USR --password $PSW
								IMAGE_ID=\$(sudo docker build --no-cache -t "${registry}"":""${BUILD_NUMBER}" . | grep 'Successfully built' | cut -d" " -f3)
								echo "Image tagged to "${registry}"":""${BUILD_NUMBER}"
								sudo docker tag "\${IMAGE_ID}" "${registry}"":""${BUILD_NUMBER}"							
								echo "Image pushing to "${registry}"":""${BUILD_NUMBER}"
								sudo docker push "${registry}"":""${BUILD_NUMBER}"
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
		stage('Image Deploy') {
			steps {
				script {
					node('aws_docker_container_lx') {
						dir("${env.WORKSPACE}") {
							checkoutCode()
							withCredentials([usernamePassword(credentialsId: 'DOCKERIDS', passwordVariable: 'PSW', usernameVariable: 'USR')]){
								sh """
								sudo docker login "${ARTIFACTORY_REPO}" --username $USR --password $PSW
								echo "Pull the image "${registry}"":""${BUILD_NUMBER}"
								sudo docker pull "${registry}"":""${BUILD_NUMBER}"
								echo "Run the image "${registry}"":""${BUILD_NUMBER}"
								sudo docker run -p 3000":"3000  "${registry}"":""${BUILD_NUMBER}"
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
						EXCEPTION_LOG = Exception_Start_Tag + "Stage Image Deploy failed " + Exception_End_Tag
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
def checkoutCode() {
	checkout([$class: 'GitSCM', branches: [[name: 'staging']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub_Secret', url: 'https://github.com/venkat-krishna-t/one2onetool.git']]])
}
