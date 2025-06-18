# Fanr

## Vision

The goal of this project is to automate fanning out a single request to multiple Large Language Models (LLMs) and aggregate the results. This will allow for easy comparison of responses from different models.

## Current State: Manual Browser Automation Setup

The initial phase of this project focuses on setting up a remote environment where a user can manually interact with multiple LLMs through their web interfaces in a single place.

This is achieved by the `deploy-browser.sh` script, which automates the provisioning of a virtual machine on Google Cloud Platform (GCP).

### What `deploy-browser.sh` does:

- Creates a firewall rule in your GCP project to allow web access to the VM.
- Spins up a new `e2-standard-2` Google Compute Engine VM instance.
- The VM runs a Docker container with a full Ubuntu LXDE desktop environment accessible via a web browser (noVNC).
- It prints the public URL to access the remote desktop.

### Prerequisites

- [Google Cloud SDK (`gcloud`)](https://cloud.google.com/sdk/docs/install) installed and configured.
- A Google Cloud Project.

### How to use

1.  **Configure Project ID:**
    Open `deploy-browser.sh` and replace the placeholder `PROJECT_ID` with your own GCP project ID.

    ```bash
    # deploy-browser.sh
    PROJECT_ID="your-gcp-project-id"
    # ...
    ```

2.  **Run the script:**

    ```bash
    bash deploy-browser.sh
    ```

3.  **Access the remote desktop:**
    The script will output a URL like `http://<EXTERNAL_IP>:6080`. Open this URL in your browser. It might take 2-3 minutes for the container and the desktop environment to be fully ready.
