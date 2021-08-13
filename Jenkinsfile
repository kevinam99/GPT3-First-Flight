pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Build GPT3-First-Flight'
        sh '''


mix deps.get&&mix compile'''
      }
    }

    stage('Linux test') {
      steps {
        echo 'Run Linux tests'
        sh 'mix test'
      }
    }

    stage('Deploy staging') {
      steps {
        echo 'Deploy to staging env'
        input 'Deploy to production'
      }
    }

    stage('Deploy production') {
      steps {
        echo 'Deploying to production'
      }
    }

  }
  post {
    always {
      archiveArtifacts(artifacts: 'target/demoapp', fingerprint: true)
    }

    failure {
      mail(to: 'kevinam99.work@gmail.com', subject: "Failed Pipeline ${currentBuild.fullDisplayName}", body: " For details about the failure, see ${env.BUILD_URL}")
    }

  }
}