# Design with https://diagrams.mingrammer.com/
# kubernetes-diagram.py
# run the cmd: python3 cyri-lan-archi-diagram.py to generate the png file.
from diagrams import Cluster, Diagram
from diagrams.generic.network import Switch, Router
from diagrams.generic.storage import Storage
from diagrams.k8s.compute import Pod
from diagrams.k8s.network import Ingress, Service
from diagrams.k8s.storage import PV, PVC, StorageClass
from diagrams.elastic.elasticsearch import Elasticsearch, Logstash, Kibana
from diagrams.oci.connectivity import DNS
from diagrams.onprem.compute import Server, Nomad

with Diagram("Kubernetes Diagram", show=False):
    synology = DNS("reverse DNS")

    with Cluster("RaspberryPi4 + K3S"):
        ingress = Ingress("cyri.intra")
        svc = Service("services")
        pvc = PVC("pv claim")
        with Cluster("apps"):
            logstash = Logstash("logstash-oss")
            elasticsearch = Elasticsearch("elasticsearch")
            squid = Server("squid")
            elk = [elasticsearch - logstash - Kibana("kibana")]
        with Cluster("local-storage"):
            pv = [StorageClass("storage class") >> PV("persistent volume")]
        k8s = ingress >> svc
        k8s >> squid >> pvc << pv
        k8s >> logstash >> pvc << pv
    
    synology << ingress