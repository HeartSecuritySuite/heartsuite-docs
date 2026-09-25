---
title: "Containers, microVMs, and the sealed host"
linkTitle: "Containers & microVMs"
weight: 6
description: "Shared-kernel Docker, containerd, Kubernetes, and CRI-O are not a supported workload. OCI images are built and run on another host. Root Lock runs as the guest kernel inside a virtual machine."
categories: ["Essentials"]
tags: ["heartsuite", "linux", "containers", "docker", "firecracker", "kata", "microvm"]
type: docs
aliases:
  - /docs/introduction/containers-and-microvms/
toc: true
menu:
  main:
    parent: "introduction"
    identifier: "containers-and-microvms"
---

**Overview**: Shared-kernel Docker is not a supported workload on a Root Lock host. Overlay filesystems and user namespaces are features attackers use to shadow directories and reach root. Root Lock by HeartSuite does not ship a container-host install that turns those features into a supported runtime.

The install is a sealed appliance — a backup receiver, a fixed server, a closed device. Build and run OCI images on another host. When a task should sit in its own machine, install Root Lock as the guest kernel in a virtual machine.

## Why Docker is not a fit on this host

Docker, containerd, Podman, and runc isolate processes on the **host** kernel. That stack needs OverlayFS and user namespaces. On a Standard-host install those primitives are compiled out — they are the attack surface, path to root, and bypass the allowlist model removes. See [System Requirements](../system-requirements/#software-compatibility-notes).

A backup receiver that only accepts Restic over SFTP does not need Docker. The Container-host install and microVMs matter when a second job would otherwise force a shared-kernel runtime onto a sealed host.

## What Firecracker and Kata are

| Name | What it is | What it is not |
|---|---|---|
| **Firecracker** | A small virtual machine monitor: boots **microVMs** with their own guest kernel, fast and dense, using KVM. Built for multi-tenant isolation. | Not a replacement for Docker Desktop. Not something most laptop developers install by name. |
| **Kata Containers** | An OCI/Kubernetes **runtime** that runs a container image **inside** a light VM (QEMU, Cloud Hypervisor, or Firecracker as backends). Same image format; stronger isolation boundary. | Not “Docker with a new logo.” Packaging stays OCI; isolation becomes VM-level. |
| **Docker / containerd / runc** | Shared-kernel packaging and runtime — process isolation on the **host** kernel. | Not a supported workload on a Root Lock host. |

Industry pattern: platforms that run untrusted or multi-tenant code put Firecracker or Kata **under** the workload. Everyday microservices still ship Docker/OCI images on a shared-kernel runtime. Firecracker is a trust badge for isolation, not a mass-market brand that replaces Docker.

## Where the containers go

### On another host

Build and run Docker, containerd, Kubernetes, and CRI-O images on a host that is not running the Root Lock kernel. Root Lock protects the fixed-workload machines around that runtime. The installer can notice a container engine on this host. It records a standard host and does not enable overlay filesystem support.

See [Deployment Scenarios → Shared-kernel containers](../deployment-scenarios/#container-hosts).

### Guest — Root Lock inside the virtual machine

```text
  Host (standard Linux or cloud VMM)
       │
       ▼
  Firecracker / Kata / KVM microVM
       │
       ▼
  Root Lock guest kernel
  Setup Mode → allowlist → Lockdown
  (known / trusted workload only)
```

Run Root Lock as the guest kernel inside a virtual machine. Build the allowlist once: run a representative task in Setup Mode, review and approve the tools through the Dashboard queues, then bake that allowlist into the VM image. A Kata Container or a Firecracker microVM is a virtual machine you provide.

Each task VM boots from that image into Lockdown. The allowlist holds for the life of the task. Then the VM is gone.

An attacker who already has root inside the guest cannot turn this off. There is no LSM to unload, no userspace shim to detach, and no agent to kill. This is the path for AI agent sandboxes, fixed-tool automation, and disposable task VMs. See [AI agent and automation sandboxes](../deployment-scenarios/#ai-agent-and-automation-sandboxes).

Root Lock is not a hypervisor host. Running Firecracker or Kata **on** a Root Lock kernel so this box becomes the VMM for untrusted tenants is not a supported configuration. KVM host mode is compiled out; the product protects workloads **inside** a kernel. See [Where Root Lock is not a fit](../deployment-scenarios/#where-root-lock-is-not-a-fit).

## What to run

| Workload | Shape | Where it is documented |
|---|---|---|
| Backup / SFTP dump target, single-purpose server | Standard host → seed allowlist → Lockdown | [Production servers](../deployment-scenarios/#production-servers), [Closed appliances](../deployment-scenarios/#closed-appliances-and-embedded-devices) |
| Build/CI fixed toolchain | Same | [Build, CI, and release infrastructure](../deployment-scenarios/#build-ci-and-release-infrastructure) |
| Docker, containerd, Kubernetes, CRI-O, or Podman on this host | Not a fit. Build and run the images on another host | [Shared-kernel containers](../deployment-scenarios/#container-hosts) |
| AI agent with a scoped tool set | Guest Root Lock in a per-task VM | [AI agent sandboxes](../deployment-scenarios/#ai-agent-and-automation-sandboxes) |
| Continuous Docker/K8s scheduling on this kernel | Not a fit | [Where it is not a fit](../deployment-scenarios/#where-root-lock-is-not-a-fit) |

## Comparison

| Approach | Isolation boundary | On a Root Lock kernel |
|---|---|---|
| Docker / runc on this host | Shared host kernel | Not a supported workload. 5.19.6 is built without OverlayFS. 6.18.9-hs ships OverlayFS as a module; that is not a container-host install |
| gVisor | Userspace syscall filter | Discussed as a peer under [How it compares](../how-it-compares/); different threat model |
| Firecracker / Kata microVM | Hardware VM boundary | Compose with Root Lock as the **guest** kernel |
| Root Lock Lockdown | Sealed allowlist in **this** kernel | Shipped product core |

Root Lock's job is that programs only do what you approved. MicroVMs are an optional wall next to that seal.

## Operator FAQ

{{< details summary="Can I run Docker on a Root Lock host?" >}}

A: On a **Standard-host** install, no — OverlayFS and user namespaces are compiled out. Choose the **Container-host** install when the installer detects a container engine and you have a long-lived, steady set of images. New containers after Lockdown still need a maintenance window. For untrusted or multi-tenant work, run the workload in a VM or microVM with Root Lock as the guest kernel instead. See [Deployment Scenarios → Container hosts](../deployment-scenarios/#container-hosts) and [FAQs](../../faqs/).

{{< /details >}}

{{< details summary="Does Root Lock use Firecracker like large cloud platforms?" >}}

A: No as a product dependency. Large platforms use Firecracker **under** multi-tenant serverless and sandboxes. You run Root Lock **inside** a Firecracker microVM, a Kata Container, or a cloud VM the same way you run it inside any guest. Root Lock does not ship Firecracker and is not a Firecracker distribution.

{{< /details >}}

{{< details summary="Can Root Lock host Firecracker or Kata for other tenants?" >}}

A: No. Root Lock protects workloads running inside a kernel. A hypervisor host grants trusted access to guests it does not control — the inverse model. KVM host mode is not a supported configuration.

{{< /details >}}

## Related pages

- [Deployment Scenarios](../deployment-scenarios/) — fit / not-fit, AI guest VMs, shared-kernel containers
- [System Requirements](../system-requirements/) — kernel line differences, including OverlayFS and KVM host
- [How Root Lock Compares](../how-it-compares/) — gVisor and enforcement peers
- [FAQs](../../faqs/) — who it is for; shared-kernel containers
