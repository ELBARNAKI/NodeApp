pipeline{
    agent any
    environment{
        DOCKER_TAG= getDockerTag()
    }
    stages{
        stage ('Build Docker Image'){
            steps{
                sh "docker build . -t elbarnaki/nodeapp:${DOCKER_TAG} "
            }
        }
        stage('DockerHub Push'){
           steps{
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockhubpwd')]) {
                    sh "docker login -u elbarnaki -p ${dockhubpwd}"
                    sh "docker push elbarnaki/nodeapp:${DOCKER_TAG}"
                }
           }
            
        }
            
        
    }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}