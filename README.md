# Section-2

Scenario:
Your organization is moving towards containerized deployments in AWS (EKS) and GCP
(GKE). The security team needs an automated solution to scan container images for
vulnerabilities before deployment.

## Vulnerability Scan



## Workflow 

The workflow (trivy-scan.yml):
* Triggers on pushes and pull requests to the main branch
* Installs Trivy
* Builds your Docker image
* Runs scan_trivy.sh on the built image
* Fails the build if high or critical vulnerabilities are detected