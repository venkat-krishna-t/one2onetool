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
					cleanWs()
				}
			}
		}
		stage("Checkout Code") {
			steps {
				script {
					dir("${env.WORKSPACE}") {
						checkout([$class: 'GitSCM', branches: [[name: 'staging']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub_Secret', url: 'https://github.com/venkat-krishna-t/one2onetool.git']]])
					}
				}
			}
		}
        stage("Build") {
            steps {
              script {
				dir("${env.WORKSPACE}") {
                  bat "npm install"
				}
              }
            }
        }
        stage("Test") {
            steps {
                script {
					dir("${env.WORKSPACE}") {
						bat "npm test"
					}
				}
            }
        }
    }
}
