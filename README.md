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


# Script pentru Monitorizarea Sistemului

Acest script Python monitorizează informațiile esențiale ale sistemului, inclusiv data și ora curentă, sistemul de operare, CPU, RAM și spațiul pe disc. Scriptul rulează într-o buclă infinită și afișează aceste informații la intervale specificate.

## Dependențe

- Python
- psutil

Pentru a instala biblioteca `psutil`, folosiți comanda:
```bash
pip install psutil




Utilizare
Salvați scriptul Python în directorul dorit.

Asigurați-vă că aveți toate dependențele necesare instalate.

Rulați scriptul folosind comanda:
python nume_script.py
Script
import time
import platform
import psutil
from datetime import datetime

# Interval de așteptare 
interval = 5

# Bucla infinită
while True:
    # Afișăm data și ora curentă
    print("Data și ora curentă:", datetime.now().strftime("%Y-%m-%d %H:%M:%S"))

    # Informații despre sistemul de operare
    print("Sistem de operare:", platform.system())
    print("Versiune kernel:", platform.release())
    
    # Informații despre CPU
    print("CPU:", platform.processor())
    
    # Informații despre RAM (total și utilizat)
    ram_total = psutil.virtual_memory().total / (1024**3)  # GB
    ram_used = psutil.virtual_memory().used / (1024**3)    # GB
    print(f"Memorie RAM - Total: {ram_total:.2f} GB, Utilizat: {ram_used:.2f} GB")
    
    # Informații despre disk (total și disponibil)
    disk_total = psutil.disk_usage('/').total / (1024**3)  # GB
    disk_used = psutil.disk_usage('/').used / (1024**3)    # GB
    print(f"Spațiu disk - Total: {disk_total:.2f} GB, Utilizat: {disk_used:.2f} GB")
    
    # Linie de separare
    print("-------------------------------------------")
    
    # Așteptăm pentru intervalul specificat
    time.sleep(interval)

# System Monitoring Script

This Bash script monitors essential system information, including the current date and time, operating system details, CPU, RAM, and disk space. The script runs in an infinite loop and displays these details at specified intervals.

## Usage

1. Save the Bash script to your desired directory and make it executable:
```bash
chmod +x script_name.sh

./script_name.sh

Script
#!/bin/bash

# Set the interval in seconds 
interval=3

# Infinite loop
while true; do
    # Display the current date and time
    echo "Current date and time: $(date)"

    # Operating system information
    echo "Operating System: $(uname -o)"
    echo "Kernel Version: $(uname -r)"
    
    # CPU information
    echo "CPU: $(lscpu | grep 'Model name' | awk -F': ' '{print $2}')"
    
    # RAM information (total and used)
    ram_total=$(free -h | grep 'Mem:' | awk '{print $2}')
    ram_used=$(free -h | grep 'Mem:' | awk '{print $3}')
    echo "RAM - Total: $ram_total, Used: $ram_used"

    # Disk information (total and used)
    disk_total=$(df -h / | grep '/' | awk '{print $2}')
    disk_used=$(df -h / | grep '/' | awk '{print $3}')
    echo "Disk Space - Total: $disk_total, Used: $disk_used"
    
    # Separator line
    echo "**************************************************"
    
    # Wait for the specified interval
    sleep $interval
done

Dockerfile pentru scriptul Bash (folosind Ubuntu ca imagine de bază)
Creează un fișier numit Dockerfile.bash pentru imaginea bazată pe Ubuntu.

Adaugă următorul conținut în acest fișier:

# Dockerfile.bash
FROM ubuntu:latest

# Instalează pachetele necesare pentru a rula scriptul Bash
RUN apt-get update && \
    apt-get install -y bash lsb-release procps

# Creează și copiază scriptul Bash în container
COPY system_info.sh /system_info.sh

# Asigură-te că scriptul are permisiuni de execuție
RUN chmod +x /system_info.sh

# Rulează scriptul ca și comandă principală
CMD ["/system_info.sh"]

Creează fișierul system_info.sh în același director, apoi copiază și lipește scriptul Bash din mesajele anterioare.

Construiește imaginea Docker pentru acest fișier Dockerfile:
docker build -f Dockerfile.bash -t bash-system-info .

Pornește containerul:

docker run --name bash-container -d bash-system-info

Vizualizează logurile containerului pentru a verifica ieșirea scriptului:
docker logs -f bash-container

Dockerfile pentru scriptul Python (folosind Python ca imagine de bază)
Creează un fișier numit Dockerfile.python pentru imaginea bazată pe Python.

Adaugă următorul conținut în acest fișier:


# Dockerfile.python
FROM python:3

# Instalează pachetul psutil necesar pentru scriptul Python
RUN pip install psutil

# Creează și copiază scriptul Python în container
COPY system_info.py /system_info.py

# Rulează scriptul Python ca și comandă principală
CMD ["python", "/system_info.py"]

Creează fișierul system_info.py în același director, apoi copiază și lipește scriptul Python din mesajele anterioare.

Construiește imaginea Docker pentru acest fișier Dockerfile:
docker build -f Dockerfile.python -t python-system-info .
Pornește containerul:


docker run --name python-container -d python-system-info
Here's how to create a docker-compose.yml file to deploy both the Bash and Python scripts as services using Docker Compose. This deployment will use the two Dockerfiles created earlier.

Docker Compose Setup
In the same directory as your Dockerfiles (Dockerfile.bash and Dockerfile.python), create a file named docker-compose.yml with the following content:
version: '3.8'

services:
  bash-service:
    build:
      context: .
      dockerfile: Dockerfile.bash
    container_name: bash-container-v2
    
  python-service:
    build:
      context: .
      dockerfile: Dockerfile.python
    container_name: python-container-v2


Explanation
bash-service: This service builds the image using Dockerfile.bash and runs the Bash script as defined in the Dockerfile.
python-service: This service builds the image using Dockerfile.python and runs the Python script as defined in the Dockerfile.
Each service will have its own container name (bash-container and python-container) for easy reference.
Running the Services
Start the services using Docker Compose:
docker-compose up -d
View the logs of both services to see the output from each script:
docker-compose logs -f

Here’s a simple Ansible playbook that will deploy the two Docker Compose services described previously. The playbook will:

Create a new directory on the target host.
Copy the necessary files (Dockerfile.bash, Dockerfile.python, system_info.sh, system_info.py, and docker-compose.yml) to the target directory.
Run docker-compose up -d to start the services.
Step 1: Create the Required Files
Ensure you have the following files in the same directory as your playbook:

Dockerfile.bash
Dockerfile.python
system_info.sh
system_info.py
docker-compose.yml (with the container names modified if needed, as described in the previous steps)
Step 2: Create the Ansible Playbook
Create a file named deploy_docker_compose.yml with the following content:
---
- name: Deploy Docker Compose services
  hosts: target_host  # Replace with your target host group or hostname
  become: yes

  tasks:
    - name: Ensure deployment directory exists
      file:
        path: /opt/docker_compose_services  # Specify the target directory
        state: directory
        mode: '0755'

    - name: Copy Dockerfile.bash
      copy:
        src: Dockerfile.bash
        dest: /opt/docker_compose_services/Dockerfile.bash

    - name: Copy Dockerfile.python
      copy:
        src: Dockerfile.python
        dest: /opt/docker_compose_services/Dockerfile.python

    - name: Copy system_info.sh
      copy:
        src: system_info.sh
        dest: /opt/docker_compose_services/system_info.sh
        mode: '0755'

    - name: Copy system_info.py
      copy:
        src: system_info.py
        dest: /opt/docker_compose_services/system_info.py
        mode: '0755'

    - name: Copy docker-compose.yml
      copy:
        src: docker-compose.yml
        dest: /opt/docker_compose_services/docker-compose.yml

    - name: Run Docker Compose to deploy services
      shell: docker-compose up -d
      args:
        chdir: /opt/docker_compose_services


Explanation
path: Specifies the directory where the files will be stored (here it’s /opt/docker_compose_services). You can change this path as needed.
copy tasks: Copy each required file to the target directory.
shell task: Runs docker-compose up -d inside the specified directory to start the services.
Step 3: Run the Playbook
Execute the playbook with the following command, replacing target_host with the actual host you want to deploy to:

ansible-playbook -i inventory deploy_docker_compose.yml


