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

**Overview**: Shared-kernel Docker is not a supported workload on a Root Lock host.

Build and run OCI images on another host. When a task should sit in its own machine, install Root Lock as the guest kernel in a virtual machine.

## Why Docker is not a fit on this host

Docker, containerd, Podman, and runc isolate processes on the host kernel. A container runtime on it is not a supported configuration: under Lockdown, Root Lock refuses the new mounts a runtime makes each time it starts or reschedules a container. See [System Requirements](../system-requirements/#software-compatibility-notes).

A backup receiver that accepts Restic over SFTP runs a handful of programs and needs no container engine. Run the container engine on another host, and let Root Lock protect the machines around it.

## What Firecracker and Kata are

| Name | What it is | Compared with Docker |
|---|---|---|
| **Firecracker** | A small virtual machine monitor that uses KVM to boot microVMs quickly and densely, each with its own guest kernel. Built for multi-tenant isolation. | Runs underneath platform workloads rather than on developer laptops; Docker Desktop keeps its role for everyday development. |
| **Kata Containers** | An OCI/Kubernetes runtime that runs each container image inside a light VM, with QEMU, Cloud Hypervisor, or Firecracker as the backend. | Uses the same OCI image format, and moves the isolation boundary from the shared kernel to a VM. |
| **Docker / containerd / runc** | Shared-kernel packaging and runtime: process isolation on the host kernel. | The shared-kernel baseline, and not a supported workload on a Root Lock host. |

Platforms that run untrusted or multi-tenant code put Firecracker or Kata underneath the workload, so each tenant gets its own kernel. Everyday microservices still ship as Docker/OCI images on a shared-kernel runtime. Firecracker signals strong isolation, and it sits alongside Docker rather than replacing it.

## Where the containers go

### On another host

Build and run Docker, containerd, Kubernetes, and CRI-O images on a host that runs its distribution kernel rather than the Root Lock kernel, and let Root Lock protect the fixed-workload machines around that runtime. If the installer notices a container engine on a Root Lock host, it installs Root Lock the same way as on any other host and does not enable overlay filesystem support.

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

Run Root Lock as the guest kernel inside a virtual machine you provide, such as a Kata Container or a Firecracker microVM. Build the allowlist once: run a representative task in Setup Mode, review and approve the tools through the Dashboard queues, then bake that allowlist into the VM image.

The image carries the allowlist and is not sealed. You run the seal on that machine, and the seal takes effect on the next boot. The allowlist holds for the life of the task until the VM is discarded.

An attacker who already has root inside the guest cannot turn this off, because blocking is compiled into the guest kernel: its enforcement cannot be unloaded or set permissive the way an LSM policy can, and there is no userspace shim to detach and no agent to kill. This is the path for AI agent sandboxes, fixed-tool automation, and disposable task VMs. See [AI agent and automation sandboxes](../deployment-scenarios/#ai-agent-and-automation-sandboxes).

Running Firecracker or Kata on a Root Lock kernel, so that this box becomes the VMM for untrusted tenants, is not a supported configuration, because Root Lock protects workloads inside a kernel rather than hosting them. See [Where Root Lock is not a fit](../deployment-scenarios/#where-root-lock-is-not-a-fit).

## What to run

| Workload | Shape | Where it is documented |
|---|---|---|
| Backup / SFTP dump target, single-purpose server | Root Lock host → seed allowlist → Lockdown | [Production servers](../deployment-scenarios/#production-servers), [Closed appliances](../deployment-scenarios/#closed-appliances-and-embedded-devices) |
| Build/CI fixed toolchain | Same | [Build, CI, and release infrastructure](../deployment-scenarios/#build-ci-and-release-infrastructure) |
| Docker, containerd, Kubernetes, CRI-O, or Podman, including continuous scheduling | Not a fit on this host. Build and run the images on another host | [Shared-kernel containers](../deployment-scenarios/#container-hosts), [Where it is not a fit](../deployment-scenarios/#where-root-lock-is-not-a-fit) |
| AI agent with a scoped tool set | Guest Root Lock in a per-task VM | [AI agent sandboxes](../deployment-scenarios/#ai-agent-and-automation-sandboxes) |

## Comparison

| Approach | Isolation boundary | On a Root Lock kernel |
|---|---|---|
| Docker / runc on this host | Shared host kernel | Not a supported workload. |
| gVisor | Userspace syscall filter | Discussed as a peer under [How it compares](../how-it-compares/); different threat model |
| Firecracker / Kata microVM | Hardware VM boundary | Compose with Root Lock as the guest kernel |
| Root Lock Lockdown | Sealed allowlist in the Root Lock kernel itself | Shipped product core |

Root Lock makes sure programs do only what you approved. A microVM adds an optional hardware boundary around that sealed kernel.

## FAQ

{{< details summary="Can I run Docker on a Root Lock host?" >}}

A: No. Root Lock ships a single install for hosts with a fixed set of programs, and a container runtime on the Root Lock kernel is not a supported configuration. Under Lockdown, Root Lock refuses the new mounts a runtime makes when it starts containers. Build and run the images on another host. For untrusted or multi-tenant work, run the workload in a VM or microVM with Root Lock as the guest kernel. See [Deployment Scenarios → Shared-kernel containers](../deployment-scenarios/#container-hosts) and [FAQs](../../faqs/).

{{< /details >}}

{{< details summary="Does Root Lock use Firecracker like large cloud platforms?" >}}

A: Only as a place to run. Large platforms run Firecracker underneath multi-tenant serverless and sandboxes, and you run Root Lock inside a Firecracker microVM, a Kata Container, or a cloud VM the same way you run it inside any other guest.
{{< /details >}}

{{< details summary="Can Root Lock host Firecracker or Kata for other tenants?" >}}

A: No. A hypervisor host grants trusted access to guests it does not control, which is the inverse of what Root Lock does: it protects the workloads running inside its own kernel. Hosting virtual machines is not a supported role on either kernel line, so Root Lock runs as the guest.

{{< /details >}}

## Related pages

- [Deployment Scenarios](../deployment-scenarios/) — fit / not-fit, AI guest VMs, shared-kernel containers
- [System Requirements](../system-requirements/) — kernel line differences, including OverlayFS and KVM host
- [How Root Lock Compares](../how-it-compares/) — gVisor and enforcement peers
- [FAQs](../../faqs/) — who it is for; shared-kernel containers
