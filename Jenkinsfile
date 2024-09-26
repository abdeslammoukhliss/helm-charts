pipeline {
    agent any

    environment {
        // Nexus Configuration
        NEXUS_URL = '146.235.233.225'
         DOCKER_REPO_PORT = '8083'
         NEXUS_PORT = '8443'
        NEXUS_DOCKER_REPO = 'docker-repo' // Replace with your actual Docker repository name
        NEXUS_HELM_REPO = 'helm-repo' // Replace with your actual Helm repository name
        // Application Configuration
        APP_VERSION = '1.0.1' // You can dynamically fetch this from pom.xml if needed
        HELM_CHARTS_DIR = './charts'
        // Credentials IDs (stored in Jenkins credentials store)
        NEXUS_CREDENTIALS_ID = 'nexus-credentials' // Replace with your Jenkins credentials ID for Nexus
    }


    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/abdeslammoukhliss/helm-charts.git' // Replace with your Git repository URL and branch
            }
        }



        stage('Package Helm Chart') {
            steps {
            script{
                dir (HELM_CHARTS_DIR){
                    def helmCharts = sh(script:'ls -d */',returnStdout:true).trim().split("\n")
                    def tasks= [:]
                    helmCharts.each{ chartDir ->
                        def chartName= chartDir.replaceAll("/",'')
                        tasks["Package and Upload ${chartName}"] = {
                            echo "Packaging ${chartName}"
                             def chartVersion = sh(script: "grep '^version:' ${chartDir}/Chart.yaml | awk '{print \$2}'", returnStdout: true).trim()
                            sh "helm package ${chartDir}"
                            def packageName="${chartName}-${chartVersion}.tgz"
                            echo "uploading ${packageName} to Nexus"
                              withCredentials([usernamePassword(credentialsId: NEXUS_CREDENTIALS_ID, usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASSWORD')]) {
                                                    sh """
                                                        curl -k -u $NEXUS_USER:$NEXUS_PASSWORD --upload-file ${packageName} https://${NEXUS_URL}:${NEXUS_PORT}/repository/${NEXUS_HELM_REPO}/
                                                    """
                                                }

                        }
                    }
                        parallel tasks
                }
            }

            }
        }



    }

    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
        always {
            cleanWs()
        }
    }
}
