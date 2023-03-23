# jenkins-pipeline-deploy-to-eks

**Building Architecture and Deployment on Kubernetes using a Jenkins CI/CD Pipeline**

This project serves as an example of how to use Infrastructure as Code (IaaC) to build a microservices-based architecture on Kubernetes. A Socks Shop microservice application and a straightforward Nginx webpage app with a nginx/httpd frontend proxy and a database backend were the two webapps I provisioned. A pipeline that uses Terraform to provision the Kubernetes cluster on AWS starts the deployment procedure. Terraform takes over after the infrastructure is set up and deploys the web application, database, and microservices. For this project, my monitoring tool of choice was Prometheus. A robust and adaptable monitoring system, Prometheus offers real-time data and alarms.


***You'll need to provision the following elements in order to replicate this setup:***

- Your choice of web application with a nginx/httpd frontend proxy
a backend for a database (mongo, postgresql, etc.)
- Example microservice application: [The Socks Store](https://microservices-demo.github.io/)
- Terraform as IAC
- Jenkins for automation

This project places a strong emphasis on DevOps techniques, readability, and maintainability. I've automated the deployment process using Terraform as the configuration management tool.
