# Project Description

The goal of the project is to setup a proxy appliance for monitoring the internal home web activities.

The purpose is to install a light Kubernetes (k3s) cluster on [**Raspberry Pi 4**](https://www.raspberrypi.org) (armv8) and then to deploy Squid and the open source ELK stack: ElasticSearch OSS, Logstash OSS and Kibana OSS. 

### Installing and configuring the setup

The project contains 2 folders:

* folder ***squid*** contains the *Dockerfile* to build the ARM64 (aarch64)  Squid image based on CentOS7. Also the full YAML files for deploying the application based on the Squid config file and the related exposed service.
* folder ***elk*** contains the YAML for creating the deployment with ElasticSearch, Logstach and Kibana. Also, the related config files for ELK such as the *grok* instructions to parse the Squid logs. Finally, the folder contains the *Dockerfiles* to build the ARM64 (aarch64) ELK images based on CentOS7.

### Running the project

#### Prerequisites
- Ensure that your Raspberry Pi 4 (RPI4) runs with 64 bits OS such as Ubuntu Server [**https://ubuntu.com/download/raspberry-pi**](https://ubuntu.com/download/raspberry-pi). For my setup, I selected the LTS release: ***Ubuntu 18.04.4 LTS***.
- Read the matrix compliancy: [**https://www.elastic.co/fr/support/matrix**](https://www.elastic.co/fr/support/matrix)
- Verify the k3s requirements: [**https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/**](https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/)

#### Installation

Follow the steps:

1. Install RPI4 as described on the [**Ubuntu**](https://ubuntu.com/download/raspberry-pi/thank-you) documentation for Raspberry Pi.
2. Install Docker to build the [Squid image](squid/centos7/README.md) and [ELK images](elk/centos7/README.md) for ARM64 or pull the images from [**my Docker hub repositories**](https://hub.docker.com/r/cyrriv/)
    * Instructions to install docker-ce: [**docker-ce**](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
3. Install **k3s** with the shell script: 
    [**https://rancher.com/docs/k3s/latest/en/installation/install-options/**](https://rancher.com/docs/k3s/latest/en/installation/install-options/)
    ``` 
    sudo curl -sfL https://get.k3s.io | sh -
    ``` 

    * After successful installation, list the k8S node:
        ``` 
        sudo kubectl get nodes
        ``` 
        The command returns the list of node, here only the master node:
         ``` 
        ubuntu@cyri-pi4:~$ sudo kubectl get nodes
        NAME       STATUS   ROLES    AGE   VERSION
        cyri-pi4   Ready    master   65s   v1.17.3+k3s1
         ``` 

#### Quickstart

Follow the steps:

1. To deploy Squid, launch the *kubectl* commands:
    ```
    sudo kubectl create -f ./squid/pvc.yaml         #Create the Persitent Volume
    sudo kubectl create -f ./squid/deployment.yaml  #Deploy Squid (app and service)
    ```
2. To deploy ELK OSS, launch the *kubectl* commands:
    ```
    sudo kubectl apply -f ./elk/deployment.yaml        #Deploy and expose ELK
    ```
    **NOTE**: The Elastic index mapping creation may fail the pod startup. To get ride of this, the pod may restart at least once to ensure that ElasticSearch is up and running to accept the CURL command.

3. Finally, the command *kubectl get all,pv,pvc* returns the following status:
    ```
    NAME                                    READY   STATUS    RESTARTS   AGE
    pod/svclb-squid-service-vnhlh           1/1     Running   0          35h
    pod/svclb-elk-svc-kibana-oss-h5bdm      1/1     Running   0          9h
    pod/elk-deployment-75597586f4-qdsh5     3/3     Running   2          9h
    pod/squid-deployment-695cdcd79f-mt6bj   1/1     Running   0          9h

    NAME                         TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)          AGE
    service/kubernetes           ClusterIP      10.43.0.1       <none>         443/TCP          5d14h
    service/squid-service        LoadBalancer   10.43.156.130   192.168.0.35   3128:32267/TCP   35h
    service/elk-svc-squid        ClusterIP      10.43.73.63     <none>         1025/TCP         9h
    service/elk-svc-kibana-oss   LoadBalancer   10.43.255.243   192.168.0.35   5601:31098/TCP   9h

    NAME                                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
    daemonset.apps/svclb-squid-service        1         1         1       1            1           <none>          35h
    daemonset.apps/svclb-elk-svc-kibana-oss   1         1         1       1            1           <none>          9h

    NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/elk-deployment     1/1     1            1           9h
    deployment.apps/squid-deployment   1/1     1            1           35h

    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/elk-deployment-75597586f4     1         1         1       9h
    replicaset.apps/squid-deployment-695cdcd79f   1         1         1       35h

    NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE
    persistentvolume/pvc-71709da5-8fe5-4356-8ea7-7d1579d90a04   1Gi        RWO            Delete           Bound    default/local-path-pvc   local-path              35h

    NAME                                   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    persistentvolumeclaim/local-path-pvc   Bound    pvc-71709da5-8fe5-4356-8ea7-7d1579d90a04   1Gi        RWO            local-path     35h
    ```

#### Additional deployments

* To ease the configuration the web proxy on all home devices, I deployed a Nginx web server with the *proxy.pac* file detailing how the web traffic is routed to the proxy or not. Files are located into the *squid/nginx-proxy* folder with the YAML file named *squid/deploy-nginx.yaml* for the K8s deployment and service.

## Issues encountered and problems solving

* K3s fails to start with the fatal error:
    ```
    FATA[2020-03-14T15:40:30.660878233Z] failed to find memory cgroup, you may need to add "cgroup_memory=1 cgroup_enable=memory" to your linux cmdline (/boot/cmdline.txt on a Raspberry Pi)
    ```
    - Solution: under Ubuntu 18.04, the boot file to amend is located under */boot/firmware/nobtcmd.txt*. Update it by adding "cgroup_memory=1 cgroup_enable=memory" at the end of the file. Then reboot your RPI4. Finally check that changes are ok by running the command: 
        ```
        sudo cat /proc/cmdline.
        ```


## Tips and tricks

* Add rules in iptables for openning default ports exposing pods on the K8S cluster:
    ```
    sudo iptables -A INPUT -i eth0 -p tcp -s 192.168.0.0/24 --dport 30000:32767 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
    sudo iptables -L --line-numbers
    sudo iptables -A OUTPUT -o eth0 -p tcp --sport 30000:32767 -m conntrack --ctstate ESTABLISHED -j ACCEPT
    sudo iptables-save
    ```

* Health check of k3s by running the command
    ```
    sudo k3s check-config
    ```
    The command returns the overall configuraton state of k3s.

* Restart k3s:
    ```
    sudo systemctl restart k3s
    sudo systemctl status k3s
    ```