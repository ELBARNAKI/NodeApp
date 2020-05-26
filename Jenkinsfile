pipeline{
    agent any
    environment{
        def dev_path = 'master@40.89.143.198:/home/master/dev'
        def prod_path = 'master@40.89.143.198:/home/master/prod'
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

    /////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    /*stage ("Deploy to DEV") {
      when {branch 'developer'} {
        anyOf {
          allOf {
            changeset "${env.K8S_YAML_DEV}"
            branch 'dev'
          }
          allOf {
            changeset "${env.VERSION}"
            branch 'dev'
          }
        }
      steps {
           sh "chmod +x changeTag.sh"
           sh "./changeTag.sh ${DOCKER_TAG}"
           sshagent(['kubmaster']) {
            sh " scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml master@40.89.143.198:/home/master/"
            script{
                 try{
                    sh "ssh master@40.89.143.198  kubectl apply -f ."
                    }catch(error){
                    sh "ssh master@40.89.143.198  kubectl create -f ."
                    }
                }
            sh "sed -i 's/docker_image_tag/'${env.TAG}'/' ${env.K8S_YAML_DEV}"
            sh "kubectl apply --context=${env.K8S_CONTEXT_DEV} -f ${env.K8S_YAML_DEV}"

             } 
        }*/
    }

 ////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    stage ("Deploy to PROD") {
      when { branch 'master' }
      steps{
            sshagent(['kubmaster']) {
            sh " scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ${prod_path}"
                script{
                     try{
                         sh "ssh master@40.89.143.198  kubectl --namespace=${env.BRANCH_NAME} apply -f ."
                        }catch(error){
                         sh "ssh master@40.89.143.198  kubectl --namespace=${env.BRANCH_NAME} create -f ."
                        }
                    }
                }

            }  
        }
    }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}