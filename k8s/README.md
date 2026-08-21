# Kubernetes IaC

Declarative Kubernetes manifests for deploying and managing self-hosted applications and observability services in the homelab K3s cluster.

The cluster is provisioned by Terraform + Ansible (see `../terraform` and `../ansible`). This directory manages what runs **inside** the cluster.

## Cluster

Runs on K3s v1.36+ on Ubuntu 24.04 VMs:
- `k3s-control` — Control plane (192.168.1.170)
- `k3s-worker-1` — Worker node (192.168.1.171)

## Port Mapping

| Application | Service Type | Port | Target Port | Node Port |
| :---     | :---:    | :---:     | :---:     | :---:     | 
| Firefly     | NodePort   | 8080    | 8080    | 30000    |
| ASAP Client     | NodePort   | 80    | 80    | 30001    |
| Uptime Kuma     | NodePort   | 3001    | 3001    | 30002    |



## Applications

### ASAP
Custom application deployed as separate frontend and backend workloads. The backend connects to PostgreSQL running outside the cluster.
- Resources: `Deployment`, `Service`, `Secret`

### Uptime Kuma
Uptime monitoring tool. Exposes Prometheus-compatible `/metrics` endpoint consumed by the observability stack.
- Resources: `Deployment`, `Service`, `PersistentVolumeClaim`

## Observability

Manually composed observability stack — intentionally avoiding large bundles (no `kube-prometheus-stack`) to keep things learnable.

| Component | Role |
|---|---|
| Prometheus | Scrapes metrics from apps (Uptime Kuma `/metrics`) |
| Grafana | Visualizes Prometheus metrics |
| Loki | Centralized log aggregation (planned) |

Prometheus authenticates with Uptime Kuma using an API key stored as a Kubernetes `Secret`.

## Deployment

```bash
kubectl apply -f namespace/
kubectl apply -f apps/asap/
kubectl apply -f apps/uptimekuma/
kubectl apply -f observability/prometheus/
kubectl apply -f observability/grafana/
```

Check workloads:
```bash
kubectl get pods -A
kubectl get nodes
```
