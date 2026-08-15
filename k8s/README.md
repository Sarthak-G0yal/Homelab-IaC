
# Kubernetes IaC

Kubernetes Infrastructure as Code repository for deploying and managing self-hosted applications and observability services in my homelab.

The project uses declarative Kubernetes manifests with a focus on simplicity, extensibility, and learning Kubernetes fundamentals before introducing higher-level tooling such as Helm and GitOps.

## Architecture

```text
                         Kubernetes Cluster
                                │
             ┌──────────────────┴──────────────────┐
             │                                     │
        Applications                         Observability
             │                                     │
      ┌──────┴──────┐                    ┌─────────┴─────────┐
      │             │                    │         │         │
     ASAP      Uptime Kuma           Prometheus  Grafana   Loki
      │             │                    │         │         │
      └─────────────┴────────────────────┴─────────┴─────────┘
````

## Repository Structure

```text
.
├── apps/
│   ├── asap/
│   │   ├── client-deployment.yaml
│   │   ├── client-service.yaml
│   │   ├── server-deployment.yaml
│   │   ├── server-service.yaml
│   │   └── server-secret.yaml
│   │
│   └── uptimekuma/
│       ├── uptime-deployment.yaml
│       ├── uptime-pvc.yaml
│       └── uptime-service.yaml
│
├── namespace/
│
└── observability/
    ├── grafana/
    │   ├── configmap.yaml
    │   ├── deployment.yaml
    │   └── service.yaml
    │
    ├── loki/
    │
    └── prometheus/
        ├── configmap.yaml
        ├── deployment.yaml
        ├── secret.yaml
        └── service.yaml
```

## Applications

### ASAP

ASAP is a custom application deployed as separate frontend and backend workloads.

```text
ASAP Client
     │
     ▼
ASAP Server
     │
     ▼
PostgreSQL
```

The PostgreSQL database runs outside Kubernetes and is consumed by the ASAP backend.

Kubernetes resources:

* Deployment
* Service
* Secret

### Uptime Kuma

Uptime Kuma is deployed as a Kubernetes workload and provides an application that can be monitored by the observability stack.

Kubernetes resources:

* Deployment
* Service
* PersistentVolumeClaim

Uptime Kuma exposes Prometheus-compatible metrics through its authenticated `/metrics` endpoint.

## Observability

The observability stack is intentionally built manually rather than using a large Kubernetes monitoring bundle.

### Prometheus

Prometheus collects metrics from applications running inside the cluster.

Current flow:

```text
Uptime Kuma
     │
     │ /metrics
     ▼
 Prometheus
```

Prometheus authenticates with Uptime Kuma using an API key stored as a Kubernetes Secret.

### Grafana

Grafana provides visualization for the metrics collected by Prometheus.

```text
Prometheus
    │
    ▼
 Grafana
```

Grafana is configured to use Prometheus as its default datasource.

### Loki

Loki is planned as the centralized logging component.

```text
Kubernetes workloads
        │
        ▼
      Loki
        │
        ▼
     Grafana
```

## Design Goals

* Declarative Kubernetes configuration
* Simple Kubernetes primitives before introducing abstractions
* Reusable structure for adding new applications
* Centralized observability
* Secure secret management
* Separation of applications and platform services
* Integration with the existing homelab infrastructure
* Gradual progression toward GitOps

## Deployment

The cluster is currently managed directly using `kubectl`.

Example:

```bash
kubectl apply -f apps/asap/
kubectl apply -f apps/uptimekuma/
kubectl apply -f observability/prometheus/
kubectl apply -f observability/grafana/
```

Check workloads:

```bash
kubectl get pods
kubectl get services
```

## Relationship With Homelab IaC

This repository is responsible for **Kubernetes workloads and platform services**.

The main Homelab IaC repository handles the underlying infrastructure:

```text
Homelab IaC
├── Terraform
│   └── Infrastructure provisioning
│
└── Ansible
    └── Host configuration
```

This repository handles:

```text
Kubernetes IaC
├── Applications
├── Services
├── Storage
└── Observability
```

The separation allows the underlying infrastructure and Kubernetes workloads to be managed independently.
