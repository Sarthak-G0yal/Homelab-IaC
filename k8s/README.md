# Kubernetes IaC

Declarative Kubernetes manifests for deploying and managing self-hosted applications and observability services in the homelab K3s cluster.

The cluster is provisioned by Terraform + Ansible (see `../terraform` and `../ansible`). This directory manages what runs **inside** the cluster.

## Cluster

Runs on K3s v1.36+ on Ubuntu 24.04 VMs:
- `k3s-control` — Control plane
- `k3s-worker-1` — Worker node

## Port Mapping

| Application     | Service Type | Port | Target Port | Node Port |
| :---            | :---:        | :---:| :---:       | :---:     |
| Firefly         | NodePort     | 8080 | 8080        | 30000     |
| ASAP Client     | NodePort     | 80   | 80          | 30001     |
| Uptime Kuma     | NodePort     | 3001 | 3001        | 30002     |
| Grafana         | NodePort     | 3000 | 3000        | 30003     |
| ASAP Server     | NodePort     | 3000 | 3000        | 30004     |
| FireflyImporter | NodePort     | 8080 | 8080        | 30005     |


## Applications

### ASAP
Custom application deployed as separate frontend and backend workloads. The backend connects to PostgreSQL running outside the cluster.
- Resources: `Deployment`, `Service`, `Secret`

### Firefly III
Personal finance application backed by PostgreSQL running outside the cluster.
- Resources: `Deployment`, `Service`, `ConfigMap`, `Secret`, `PersistentVolumeClaim`

### Uptime Kuma

Uptime Kuma is deployed as a Kubernetes workload for service uptime monitoring.

Kubernetes resources:

* Deployment
* Service
* PersistentVolumeClaim

## Observability

Manually composed observability stack — intentionally avoiding large bundles (no `kube-prometheus-stack`) to keep things learnable.

| Component | Role |
|---|---|
| Prometheus | Scrapes metrics from apps (Uptime Kuma `/metrics`) |
| Grafana | Visualizes Prometheus metrics and Loki logs |
| Loki | Centralized log aggregation |
| Alloy | Collects Kubernetes pod logs and forwards them to Loki |

* `prometheus/` — metrics collection, uses Kustomize with RBAC for cluster-wide discovery.
* `node-exporter/` — host-level CPU, memory, disk, and network metrics (DaemonSet).
* `kube-state-metrics/` — Kubernetes object state metrics (pods, deployments, restarts).
* `grafana/` — visualization; uses Kustomize and expects a local `secrets.yaml`.
* `loki/` — centralized log storage.
* `alloy/` — log collection agent (DaemonSet).

### Prometheus

Prometheus collects metrics from the Kubernetes cluster using service discovery and RBAC-based API access.

Metrics sources:

```text
Kubelet / cAdvisor  ──┐
                      ├──▶  Prometheus  ──▶  Grafana
Node Exporter       ──┤
Kube State Metrics  ──┘
```

| Scrape job             | Source                | Metrics                                    |
| :--------------------- | :-------------------- | :----------------------------------------- |
| `kubernetes-cadvisor`  | Kubelet cAdvisor      | Container CPU & memory usage               |
| `node-exporter`        | Node Exporter DaemonSet | Host CPU, memory, disk, network          |
| `kube-state-metrics`   | KSM Deployment        | Pod restarts, deployment status, readiness |

Prometheus uses a dedicated `ServiceAccount` with a `ClusterRole` that grants read access to nodes, pods, services, endpoints, and the `/metrics/cadvisor` non-resource URL.

### Node Exporter

Node Exporter runs as a DaemonSet with `hostNetwork` and `hostPID` to expose hardware and OS metrics from each node on port `9100`.

Kubernetes resources:

* `observability/node-exporter/daemonset.yaml`
* `observability/node-exporter/service.yaml`

### Kube State Metrics

Kube State Metrics exposes metrics about the state of Kubernetes objects (pod phases, restart counts, deployment replicas, etc.) on port `8080`.

Kubernetes resources:

* `observability/kube-state-metrics/rbac.yaml`
* `observability/kube-state-metrics/deployment.yaml`
* `observability/kube-state-metrics/service.yaml`

### Grafana

Grafana provides visualization for the metrics collected by Prometheus.

```text
Prometheus
    │
    ▼
 Grafana
```

Grafana is configured to use Prometheus as its default datasource via provisioned configuration.

Grafana also uses PostgreSQL as its application database. The database password is stored in a Kubernetes Secret.

Before deploying Grafana, create the local secret file:

```bash
cp observability/grafana/secrets.example.yaml observability/grafana/secrets.yaml
```

Then set `stringData.db-password` in `observability/grafana/secrets.yaml`.

### Loki and Alloy

Loki is the centralized logging component. Alloy runs as a DaemonSet on each cluster node and forwards Kubernetes pod logs to Loki.

```text
Kubernetes workloads
        │
        ▼
      Alloy
        │
        ▼
      Loki
        │
        ▼
     Grafana
```

Alloy uses Kubernetes pod discovery, keeps only pods on the node where each Alloy instance is running, labels logs with pod metadata, and writes them to the in-cluster Loki service.

The Alloy manifests are:

* `observability/alloy/rbac.yaml`
* `observability/alloy/configmap.yaml`
* `observability/alloy/daemonset.yaml`

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

Deploy in the following order:

```bash
# Namespace
kubectl apply -f namespace/observability.yaml

# Applications
kubectl apply -f apps/asap/
kubectl apply -f apps/firefly3/
kubectl apply -f apps/uptimekuma/

# Observability — metrics
kubectl apply -k observability/prometheus/
kubectl apply -k observability/node-exporter/
kubectl apply -k observability/kube-state-metrics/

# Observability — visualization (requires secrets.yaml)
kubectl apply -k observability/grafana/

# Observability — logging
kubectl apply -f observability/loki/
kubectl apply -f observability/alloy/
kubectl apply -f observability/grafana/
```

> Grafana uses `kustomization.yaml` so the generated deployment includes the local `secrets.yaml` file.
> The real `secrets.yaml` is ignored by Git; commit only the matching `secrets.example.yaml` template.

Check workloads:
```bash
kubectl get pods -n observability
kubectl get services -n observability
```
