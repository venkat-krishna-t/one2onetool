pipeline {
    agent {
        node {
            label 'master'
        }
    }
    stages {
        stage('Build') {
            steps {
              script {
                  bat 'npm install'
              }
            }
        }
        stage('Test') {
            steps {
                script {
                  bat 'npm test'
              }
            }
        }
    }
}
