Project: System Info Script Deployment with Docker, Docker Compose, and Ansible
Prerequisites
Before running the deployment, ensure the following are installed on your local machine:

Ansible (for automation)
Docker and Docker Compose (for containerization)
/path/to/your/project
│
├── Dockerfile.bash
├── Dockerfile.python
├── system_info.sh
├── system_info.py
├── docker-compose.yml
├── deploy.yml
└── README.md
Scripts Overview
1. system_info.sh (Bash Script)
This script runs indefinitely, printing system information every x seconds.
 Dockerfile.bash
Dockerfile for the Bash script.
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    bash \
    coreutils \
    procps \
    util-linux

# Copy the Bash script
COPY system_info.sh /system_info.sh

# Set the entrypoint
CMD ["/bin/bash", "/system_info.sh"]

 Dockerfile.python
Dockerfile for the Python script.
FROM python:3

# Install necessary packages
RUN apt-get update && apt-get install -y \
    procps \
    lscpu \
    psutil

# Copy the Python script
COPY system_info.py /system_info.py

# Set the entrypoint
CMD ["python", "/system_info.py"]
 docker-compose.yml
This file defines the two services for the Bash and Python scripts.
version: '3'

services:
  bash-service:
    build:
      context: .
      dockerfile: Dockerfile.bash
    container_name: bash-container
    restart: always
    volumes:
      - ./system_info.sh:/system_info.sh
    command: /system_info.sh

  python-service:
    build:
      context: .
      dockerfile: Dockerfile.python
    container_name: python-container
    restart: always
    volumes:
      - ./system_info.py:/system_info.py
    command: python /system_info.py
    Deployment Steps
1. Install Ansible
Ensure Ansible is installed on your local machine. Use the following command to install:
sudo apt install ansible
 Set Up Ansible Inventory File
Create an inventory file (hosts.ini) to specify the target server for deployment.

Example hosts.ini:
[servers]
your-server-ip ansible_ssh_user=your-user

Replace your-server-ip with the IP of your server, and your-user with the SSH user.

3. Run the Ansible Playbook
Execute the following command to deploy the application:
ansible-playbook -i hosts.ini deploy.yml


Here's the README.md file that includes everything you need to deploy the Bash and Python scripts using Docker, Docker Compose, and Ansible.

Project: System Info Script Deployment with Docker, Docker Compose, and Ansible
This project contains two scripts (one Bash and one Python) that run in infinite loops, printing system information such as the current date and time, OS details, CPU, RAM, and disk usage at regular intervals. The project uses Docker, Docker Compose, and Ansible for deployment.

Prerequisites
Before running the deployment, ensure the following are installed on your local machine:

Ansible (for automation)
Docker and Docker Compose (for containerization)
Project Structure
bash
Copy code
/path/to/your/project
│
├── Dockerfile.bash
├── Dockerfile.python
├── system_info.sh
├── system_info.py
├── docker-compose.yml
├── deploy.yml
└── README.md
Scripts Overview
1. system_info.sh (Bash Script)
This script runs indefinitely, printing system information every x seconds.

bash
Copy code
#!/bin/bash

# Set the wait time (e.g., 5 seconds)
interval=5

# Infinite loop
while true; do
    # Print current date and time
    echo "Current date and time: $(date)"

    # OS information
    echo "Operating System: $(uname -o)"
    echo "Kernel version: $(uname -r)"
    
    # CPU information
    echo "CPU: $(lscpu | grep 'Model name' | awk -F': ' '{print $2}')"
    
    # RAM usage
    ram_total=$(free -h | grep 'Mem:' | awk '{print $2}')
    ram_used=$(free -h | grep 'Mem:' | awk '{print $3}')
    echo "RAM - Total: $ram_total, Used: $ram_used"

    # Disk usage
    disk_total=$(df -h / | grep '/' | awk '{print $2}')
    disk_used=$(df -h / | grep '/' | awk '{print $3}')
    echo "Disk space - Total: $disk_total, Used: $disk_used"
    
    # Separator line
    echo "-------------------------------------------"
    
    # Wait for the specified interval
    sleep $interval
done
2. system_info.py (Python Script)
This Python script runs in an infinite loop, displaying similar system information.

python
Copy code
import os
import time
import psutil
from datetime import datetime

# Set the interval (e.g., 5 seconds)
interval = 5

# Infinite loop
while True:
    # Print current date and time
    print(f"Current date and time: {datetime.now()}")

    # OS information
    print(f"Operating System: {os.uname()}")
    
    # CPU information
    print(f"CPU: {os.popen('lscpu | grep "Model name"').read().strip()}")

    # RAM usage
    mem = psutil.virtual_memory()
    print(f"RAM - Total: {mem.total / (1024 ** 3):.2f} GB, Used: {mem.used / (1024 ** 3):.2f} GB")

    # Disk usage
    disk = psutil.disk_usage('/')
    print(f"Disk space - Total: {disk.total / (1024 ** 3):.2f} GB, Used: {disk.used / (1024 ** 3):.2f} GB")
    
    # Separator line
    print("-------------------------------------------")
    
    # Wait for the specified interval
    time.sleep(interval)
3. Dockerfile.bash
Dockerfile for the Bash script.

Dockerfile
Copy code
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    bash \
    coreutils \
    procps \
    util-linux

# Copy the Bash script
COPY system_info.sh /system_info.sh

# Set the entrypoint
CMD ["/bin/bash", "/system_info.sh"]
4. Dockerfile.python
Dockerfile for the Python script.

Dockerfile
Copy code
FROM python:3

# Install necessary packages
RUN apt-get update && apt-get install -y \
    procps \
    lscpu \
    psutil

# Copy the Python script
COPY system_info.py /system_info.py

# Set the entrypoint
CMD ["python", "/system_info.py"]
5. docker-compose.yml
This file defines the two services for the Bash and Python scripts.

yaml
Copy code
version: '3'

services:
  bash-service:
    build:
      context: .
      dockerfile: Dockerfile.bash
    container_name: bash-container
    restart: always
    volumes:
      - ./system_info.sh:/system_info.sh
    command: /system_info.sh

  python-service:
    build:
      context: .
      dockerfile: Dockerfile.python
    container_name: python-container
    restart: always
    volumes:
      - ./system_info.py:/system_info.py
    command: python /system_info.py
Deployment Steps
1. Install Ansible
Ensure Ansible is installed on your local machine. Use the following command to install:

bash
Copy code
sudo apt install ansible
2. Set Up Ansible Inventory File
Create an inventory file (hosts.ini) to specify the target server for deployment.

Example hosts.ini:

ini
Copy code
[servers]
your-server-ip ansible_ssh_user=your-user
Replace your-server-ip with the IP of your server, and your-user with the SSH user.

3. Run the Ansible Playbook
Execute the following command to deploy the application:

bash
Copy code
ansible-playbook -i hosts.ini deploy.yml
This playbook will:

Install Docker and Docker Compose on the target machine.
Clone the project repository to /opt/system-info.
Build the Docker images for the Bash and Python scripts.
Start the containers using Docker Compose.
4. Verify the Containers
After deployment, you can check if the containers are running:
docker ps
You should see both containers running (bash-container and python-container).

5. View Logs
To view the logs of the running containers:
docker-compose logs -f
You will see the system information being printed by both scripts in the logs.

6. Stopping the Deployment
To stop the containers, run:
docker-compose down






