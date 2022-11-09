Exception_Start_Tag = "Jenkins stage exception: "
Exception_End_Tag = "Exit Pipeline execution "

pipeline {
    agent {
        node {
            label 'master'
        }
    }
	environment {
        DATA_FILE = ''
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
							checkout([$class: 'GitSCM', branches: [[name: 'release']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub_Secret', url: 'https://github.com/venkat-krishna-t/one2onetool.git']]])
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
							withEnv(["${env.DATA_FILE}"]) {
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
							withEnv(["${env.DATA_FILE}"]) {
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
		/*post{        
			failure {
				 echo " Jenkins job failed - Sending Mail"
				 emailBuidFailure("${JIRA_KEY}", "${ASSIGNEE_EMAILTO}")
				 ASSIGNEE_EMAILTO from JIRA custom fikelds, define & use it            
			}
		}*/
    }
}
