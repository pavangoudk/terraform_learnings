Excellent. 🔥
Now we build complete Kubernetes notes with answers included — structured per layer.

Revise this 3–4 times and your confidence will change.


---

🧠 KUBERNETES COMPLETE STRUCTURED NOTES (WITH ANSWERS)


---

🔷 LAYER 1 — Cluster Architecture

📌 Components

Control Plane

API Server

Scheduler

Controller Manager

etcd


Worker Node

Kubelet

Kube-proxy

Container runtime



---

🔎 Questions + Answers

1️⃣ What is etcd?

👉 Distributed key-value store that stores cluster state and configuration.

2️⃣ Who schedules pods?

👉 Kubernetes Scheduler.

3️⃣ What happens if API server is down?

👉 Cluster cannot accept new requests, but running workloads continue.

4️⃣ What happens if kubelet stops?

👉 Node becomes NotReady, pods may be rescheduled.


---

🔷 LAYER 2 — Node Layer

Node = Worker machine

📌 Concepts

Node status (Ready / NotReady)

Labels

Taints

Capacity



---

🔎 Questions + Answers

1️⃣ What is Node NotReady?

👉 Kubelet not reporting healthy status (resource, network, or kubelet issue).

2️⃣ What is taint?

👉 Applied on node to repel pods unless tolerated.

3️⃣ What is toleration?

👉 Defined in pod to allow scheduling on tainted nodes.

4️⃣ How to label a node?

kubectl label nodes node1 env=prod


---

🔷 LAYER 3 — Scheduling Layer

Scheduler decides where pod runs.

📌 Controls

Node Selector

Node Affinity

Pod Affinity

Pod Anti-Affinity

Taints & Tolerations

Resource requests



---

🔎 Questions + Answers

1️⃣ Pod Pending — Why?

👉 No matching node (resources, affinity mismatch, taints).

2️⃣ What happens if required node affinity doesn’t match?

👉 Pod remains Pending.

3️⃣ Difference between required and preferred?

👉 Required = hard rule.
Preferred = soft rule (best effort).

4️⃣ Node affinity vs taints?

👉 Affinity attracts pods to nodes.
Taints repel pods from nodes.


---

🔷 LAYER 4 — Pod Layer

Smallest deployable unit.

📌 Includes

Containers

Init containers

Volumes

Probes



---

🔎 Questions + Answers

1️⃣ What does Init:0/1 mean?

👉 Init container has not completed successfully.

2️⃣ What does 0/1 Running mean?

👉 Container running but not ready (readiness probe failing).

3️⃣ What is CrashLoopBackOff?

👉 Container repeatedly crashing and restarting.

4️⃣ Readiness vs Liveness?

👉 Readiness controls traffic.
Liveness restarts container.


---

🔷 LAYER 5 — Controller Layer

Maintains desired state.

📌 Types

Deployment

ReplicaSet

StatefulSet

DaemonSet

Job

CronJob



---

🔎 Questions + Answers

1️⃣ Deployment vs StatefulSet?

👉 Deployment = stateless apps.
StatefulSet = stateful apps (stable identity, ordered startup).

2️⃣ What ensures zero downtime?

👉 Rolling updates with readiness probes.

3️⃣ What is DaemonSet?

👉 Runs one pod per node.


---

🔷 LAYER 6 — Service & Networking

Handles communication.

📌 Service Types

ClusterIP

NodePort

LoadBalancer



---

🔎 Questions + Answers

1️⃣ Service has no endpoints — Why?

👉 Label selector mismatch between service and pod.

2️⃣ Difference between ClusterIP and LoadBalancer?

👉 ClusterIP = internal only.
LoadBalancer = external access.

3️⃣ What is Ingress?

👉 Layer 7 routing for HTTP/HTTPS traffic.


---

🔷 LAYER 7 — Storage Layer

Persistent data handling.

📌 Concepts

PV

PVC

StorageClass

Dynamic provisioning



---

🔎 Questions + Answers

1️⃣ PVC Pending — Why?

👉 No matching StorageClass or insufficient storage.

2️⃣ Pod stuck in Terminating — Why?

👉 Volume detach issue or finalizer blocking.

3️⃣ What is StorageClass?

👉 Defines storage provisioning method.


---

🧠 MASTER STATUS DECODING TABLE (Revise This)

| Status | Common Cause |
| :--- | :--- |
| **Pending** | Scheduling issue |
| **Init:0/1** | Init container failed |
| **0/1 Running** | Readiness probe failing |
| **CrashLoopBackOff** | Application crashing |
| **Terminating** | Graceful deletion stuck |
| **Node NotReady** | Node/kubelet issue |


You made mistakes earlier in interpreting these — this table fixes that.


---

🎯 FINAL INTERVIEW STRATEGY

Whenever asked:

1️⃣ Identify layer

2️⃣ Explain what it means

3️⃣ Mention 2–3 causes

4️⃣ Say how you would troubleshoot

Example:

> "This looks like a scheduling layer issue. I would describe the pod to check events and verify node resources or affinity rules."



That is senior-level answer style.


---

📊 Your Current Level (After These Notes)

Knowledge: Strong
Layered thinking: Improving
If you revise this properly: 8.5/10 easily



