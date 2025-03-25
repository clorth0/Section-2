# Section-2

Scenario:

Your organization is moving towards containerized deployments in AWS (EKS) and GCP
(GKE). The security team needs an automated solution to scan container images for
vulnerabilities before deployment.

Task:

Design a proposed solution or provide script to accomplish the following tasks (include
proposed tools)
* The script should initiate a vulnerability scan on specified container images.
* If any high or critical vulnerabilities, the script should prevent the deployment by
failing the pipeline.

## Solution Overview

- **Trivy**: An open-source vulnerability scanner for container images, file systems, and Infrastructure as Code (IaC).
- **GitHub Actions**: To automate the scanning process in a CI/CD pipeline.

Overall, this solution:

- Scans container images for vulnerabilities using Trivy.
- Fails the pipeline automatically if high or critical vulnerabilities are detected.
- Outputs a vulnerability report with relevant details, including CVE ID, package name, installed and fixed versions, severity, and a short description.

## Vulnerability Scan

`scan_trivy.sh` performs the following actions:

- Accepts a container image name as input.
- Runs a Trivy scan against the image.
- Filters results for **HIGH** and **CRITICAL** severity vulnerabilities.
- Outputs a structured vulnerability report in JSON format.
- Uses `jq` to print relevant vulnerability details to the console.
- Exits with a non-zero code if any high or critical vulnerabilities are found, causing the pipeline to fail.

### Usage

./scan_trivy.sh <your-container-image>

Example:

./scan_trivy.sh my-app:latest

## Workflow

The GitHub Actions workflow (`.github/workflows/trivy-scan.yml`) automates the vulnerability scanning process in your CI/CD pipeline. Features include

- Trigger: Runs on pushes and pull requests to the `main` branch.
- Build: Builds a Docker image from the repository.
- Scan: Executes `scan_trivy.sh` to scan the image for vulnerabilities using Trivy.
- Fail Condition: Fails the pipeline if any high or critical vulnerabilities are found.

### How to Use

1. Ensure `scan_trivy.sh` is executable:

chmod +x scan_trivy.sh

2. Commit and push the following to your repository:
- `scan_trivy.sh` in the project root
- `.github/workflows/trivy-scan.yml`

3. Make a commit or open a pull request to the `main` branch. GitHub Actions will automatically trigger the workflow.

## Tools Used

- Trivy - Container image vulnerability scanner  
  https://github.com/aquasecurity/trivy

- GitHub Actions - CI/CD pipeline automation  
  https://docs.github.com/en/actions

- jq - Lightweight and flexible JSON processor  
  https://stedolan.github.io/jq/

      jq -r '.Results[].Vulnerabilities[] | 
      "CVE: \(.VulnerabilityID) | Package: \(.PkgName) | Installed: \(.InstalledVersion) | Fixed: \(.FixedVersion // "N/A") | Severity: \(.Severity) | Title: \(.Title)"' "$REPORT"
