Exception_Start_Tag = "Jenkins stage exception: "
Exception_End_Tag = "Exit Pipeline execution "

pipeline {
    agent {
        node {
            label 'master'
        }
    }
    stages {
		/*stage("Clean Workspace") {
			steps {
				script {
					echo "Clearing the working directory"
					cleanWs()
				}
			}
		}*/
		stage("Checkout Code") {
			steps {
				script {
					try{    							
						dir("${env.WORKSPACE}") {
							echo " Check out the source code"
							checkout([$class: 'GitSCM', branches: [[name: 'staging']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub_Secret', url: 'https://github.com/venkat-krishna-t/one2onetool.git']]])
						}
					}catch(Exception exec){
						EXCEPTION_LOG = Exception_Start_Tag + "Stage Check out and Error " + exec + Exception_End_Tag
						error "${EXCEPTION_LOG}"
					}
				}
			}
		}
        stage("Build") {
            steps {
				script {
					try{
						dir("${env.WORKSPACE}") {
							withEnv(["DATA_FILE=Questions-test.json"]) {
								echo " Build the one2onetool application"
								bat "npm install"
							}
						}
					}catch(Exception exec){
						EXCEPTION_LOG = Exception_Start_Tag + "Stage Check out and Error " + exec + Exception_End_Tag
						error "${EXCEPTION_LOG}"
					}
				}
            }
        }
        stage("Test") {
            steps {
                script {
					try{
						dir("${env.WORKSPACE}") {
							withEnv(["DATA_FILE=Questions-test.json"]) {
								echo " Test the one2onetool application"
								bat "npm test"
							}
						}
					}catch(Exception exec){
						EXCEPTION_LOG = Exception_Start_Tag + "Stage Check out and Error " + exec + Exception_End_Tag
						error "${EXCEPTION_LOG}"
					}
				}
            }
        }
		post{        
			failure {
				 echo " Jenkins job failed - Sending Mail"
emailext body: "<br>\n\n Error: ${error}\n\n<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL build: ${env.BUILD_URL}", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'one2onetool:Notf - CI/CD pipeline failed'       
			}
		}
    }
}
