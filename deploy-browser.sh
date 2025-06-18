#!/bin/bash
# File: deploy-browser-vm.sh

PROJECT_ID="involuted-reach-457616-t7"
ZONE="northamerica-northeast1-c"
VM_NAME="browser-automation-${RANDOM}"

# Create firewall rule (only needed once)
gcloud compute firewall-rules create allow-vnc-6080 \
    --project=$PROJECT_ID \
    --allow tcp:6080 \
    --source-ranges 0.0.0.0/0 \
    --target-tags http-server \
    --description "Allow VNC web access" || true

# Create VM with startup script (more reliable than container args)
gcloud compute instances create $VM_NAME \
    --project=$PROJECT_ID \
    --zone=$ZONE \
    --machine-type=e2-standard-2 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --tags=http-server \
    --image=projects/cos-cloud/global/images/cos-stable-121-18867-90-62 \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-balanced \
    --metadata=startup-script='#!/bin/bash
docker run -d \
  -p 6080:80 \
  -p 5900:5900 \
  --name browser-automation \
  --shm-size=2g \
  --restart=always \
  dorowu/ubuntu-desktop-lxde-vnc
' \
    --scopes=https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write

# Get the external IP
EXTERNAL_IP=$(gcloud compute instances describe $VM_NAME \
    --project=$PROJECT_ID \
    --zone=$ZONE \
    --format="get(networkInterfaces[0].accessConfigs[0].natIP)")

echo "VM created: $VM_NAME"
echo "Access at: http://$EXTERNAL_IP:6080"
echo "Wait 2-3 minutes for container to start"