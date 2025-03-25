#!/bin/bash

# Usage: ./scan_trivy.sh <container-image>
IMAGE="$1"
SEVERITY="HIGH,CRITICAL"
REPORT="trivy_report.json"

if [[ -z "$IMAGE" ]]; then
  echo "Usage: $0 <container-image>"
  exit 2
fi

echo "Scanning image: $IMAGE for $SEVERITY vulnerabilities..."

# Run Trivy scan
trivy image --exit-code 1 \
            --severity $SEVERITY \
            --format json \
            -o "$REPORT" \
            "$IMAGE"

SCAN_RESULT=$?

if [[ $SCAN_RESULT -ne 0 ]]; then
  echo "High or Critical vulnerabilities detected."
  echo "Vulnerability details:"
  jq -r '.Results[].Vulnerabilities[] | 
    "CVE: \(.VulnerabilityID) | Package: \(.PkgName) | Installed: \(.InstalledVersion) | Fixed: \(.FixedVersion // "N/A") | Severity: \(.Severity) | Title: \(.Title)"' "$REPORT"
  exit 1
else
  echo "No high or critical vulnerabilities found."
  exit 0
fi