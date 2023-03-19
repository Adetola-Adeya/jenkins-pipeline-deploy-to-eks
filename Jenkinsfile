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
            steps {
                script {
                    dir('jenkins-pipeline-deploy-to-eks/terraform-infra-for-cluster') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage("deploy socks && web ]") {
            steps {
                script {
                    dir('jenkins-pipeline-deploy-to-eks/deployment-for-both-apps') {
                        sh "terraform init"
                        sh "terraform init -upgrade"
                        sh "terraform apply -auto-approve -force"
                    }
                }
            }
        }
        stage("deploy socks && web ]") {
            steps {
                script {
                    dir('jenkins-pipeline-deploy-to-eks/monitoring-logging') {
                        sh "terraform init"
                        sh "terraform init -upgrade"
                        sh "terraform apply -auto-approve -force"
                    }
                }
            }
        }

        stage("Deploy to EKS") {
            steps {
                script {
                    dir('jenkins-pipeline-deploy-to-eks') {
                        sh "aws eks --region us-east-1 update-kubeconfig --name oneapp"
                        sh "kubectl apply -f sockappeks.yaml --namespace sock-shop"
                        sh "kubectl apply -f ../jenkins-pipeline-deploy-to-eks/secondapp/ --namespace web-namespace"
                    }
                }
            }
        }
    }
}