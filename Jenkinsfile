Exception_Start_Tag = "Jenkins stage exception: "
Exception_End_Tag = "Exit Pipeline execution "

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
						checkout([$class: 'GitSCM', branches: [[name: 'release']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub_Secret', url: 'https://github.com/venkat-krishna-t/one2onetool.git']]])
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
						echo " Build the one2onetool application"
						bat "npm install"
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
						echo " Test the one2onetool application"
						bat "npm test"
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
