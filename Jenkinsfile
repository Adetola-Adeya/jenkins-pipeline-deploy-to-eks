#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage("Create an EKS Cluster") {
            when {
                expression { choice == '1'}
                }
                steps {
                script {
                    dir('terraform-infra-for-cluster') {
                        sh "terraform init"
                        sh "terraform init -upgrade"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
            
        stage("deploy socks && web") {
            when {
                expression { choice == '2'}
                }
                steps {
                script {
                    dir('deployment-for-both-apps') {
                        sh "terraform init"
                        sh "terraform init -upgrade"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
            
        stage("monitoring for both apps") {
            when {
                expression { choice == '3'}
                }
            steps {
                script {
                    dir('monitoring-logging') {
                        sh "terraform init"
                        sh "terraform init -upgrade"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }

        stage("deploy secondapp to eks") {
            when {
                expression { choice == '4'}
                }
            steps {
                script {
                    dir('secondapp') {
                        sh "kubectl apply -f ../../secondapp/ --namespace web-namespace"
                    }
                }
            }
        }

        stage("Deploy sockapp to EKS") {
            when {
                expression { choice == '5'}
                  }
                  steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks --region us-east-1 update-kubeconfig --name oneapp"
                        sh "kubectl apply -f sockappeks.yaml --namespace sock-shop"
                    }
                }
            }
        }
    }
}
            