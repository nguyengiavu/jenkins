node{
  stage('SCM Checkout') {
    git 'https://github.com/nguyengiavu/jenkins'
  }
  stage('Compile-Package') {
    def mvnHome = tool name: 'maven-3', type: 'maven'
    sh "${mvnHome}/bin/mvn package -DskipTests"
  }
  stage('Email Notification') {
    mail bcc: '', body: '''Hi There, Welcome to Jenkins pipeline
    Thanks,
    Vu Nguyen.''', cc: '', from: '', replyTo: '', subject: 'Jenkins Job', to: 'nguyengiavu@gmail.com'
  }
}
