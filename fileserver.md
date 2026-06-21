# Fileserver LXC README

## Purpose

This LXC is the dedicated **SMB fileserver** for the homelab. It exists to provide simple, reliable file sharing for personal use over the local network.

It is designed to serve only the folders that are meant to be shared and to keep the rest of the storage private.

---

## Final Architecture

* **Proxmox node:** `pve-main` (`192.168.1.110`)
* **Fileserver LXC VMID:** `211`
* **Hostname:** `fileserver`
* **LXC type:** **Privileged**
* **Static IP:** `192.168.1.136`
* **Bridge:** `vmbr0`
* **Purpose:** Samba file sharing only

The USB HDD is physically connected to `pve-main` and is mounted on the Proxmox host at `/srv/storage`. The fileserver LXC receives access to that storage through a bind mount.

---

## Important Rules

1. The fileserver LXC runs only on `pve-main`.
2. The fileserver LXC must not be migrated to the other node.
3. The fileserver LXC is **not** HA-managed.
4. The USB HDD belongs to the Proxmox host; the LXC only uses it through a bind mount.
5. Do not store VM disks, databases, or Proxmox backups on this share.
6. Expose only the intended share folders.
7. Do not reintroduce NFS in this container.
8. Keep the setup simple and easy to recreate.

---

## Host Storage Layout

The Proxmox host mounts the external 1 TB HDD at:

```text
/srv/storage
```

Final folder layout on the host:

```text
/srv/storage
├── media
│   ├── Movies
│   ├── TV
│   ├── Music
│   └── Downloads
├── shared
│   ├── public
│   └── private
├── backups
└── .system
```

### Notes

* `media` is for Plex/media content.
* `shared` is for user-accessible files.
* `backups` stays private and is not shared through Samba.
* `.system` is reserved for housekeeping and internal notes.

---

## Proxmox Host Mount

The HDD is mounted on the host by UUID in `/etc/fstab`.

Example:

```fstab
UUID=bcf90e01-f9e0-4b07-a52f-336c2b6a6e4a /srv/storage ext4 defaults,noatime,nofail 0 2
```

### Mount verification commands

```bash
findmnt /srv/storage
df -hT /srv/storage
blkid /dev/sdb1
```

Expected result:

* mount point: `/srv/storage`
* filesystem: `ext4`
* options include `noatime`

---

## LXC Configuration

### Container details

* **VMID:** `211`
* **Hostname:** `fileserver`
* **Privileged:** yes
* **OS template:** Ubuntu 24.04 LTS
* **Cores:** 1
* **Memory:** 1024 MB
* **Swap:** 512 MB
* **Root disk:** 8 GB on `local-lvm`
* **Network:** static IP on `vmbr0`

### Proxmox config summary

```text
arch: amd64
cores: 1
hostname: fileserver
memory: 1024
net0: name=eth0,bridge=vmbr0,firewall=1,gw=192.168.1.1,hwaddr=BC:24:11:16:28:D6,ip=192.168.1.136/24,ip6=dhcp,type=veth
ostype: ubuntu
rootfs: local-lvm:vm-211-disk-0,size=8G
swap: 512
tags: fileserver;mediavault;samba
```

### LXC features

The container needed:

```text
features: nesting=1
```

This was required so the container’s networking services could start correctly.

---

## Bind Mounts

The fileserver LXC uses a bind mount from the Proxmox host:

```text
/srv/storage -> /storage
```

So inside the container, the storage is visible at:

```text
/storage
```

This makes the LXC act as a service layer on top of the host-managed disk.

### Bind mount verification

Inside the container:

```bash
ls -lah /storage
ls -lah /storage/media
ls -lah /storage/shared
```

---

## Networking Fix That Was Required

The container initially had a working veth device but no IPv4 address because `systemd-networkd` failed inside the LXC with a namespace error.

The fix was to enable:

```text
features: nesting=1
```

After that, the container successfully received and used its static IP.

### Useful checks

Inside the container:

```bash
ip a
ip route
systemctl status systemd-networkd
```

Expected:

* `eth0` is up
* IPv4 address is present
* default route exists

---

## Users and Access Model

For now, the homelab is single-user.

### Human account

Only one human account is intended right now:

* `storageadmin`

### Service account ideas

If needed later, service users can be introduced for automation, but for now the system is kept simple.

### Access policy

* `storageadmin` gets access to the Samba shares.
* Plex gets access only to media.
* Backups are private and not exposed.

---

## Ownership and Permissions

### Host-side ownership

The host keeps ownership of the storage tree simple and predictable.

Recommended base ownership:

```bash
chown -R root:root /srv/storage
chmod 755 /srv/storage
chmod 755 /srv/storage/media
chmod 775 /srv/storage/shared
chmod 750 /srv/storage/backups
chmod 700 /srv/storage/.system
```

### File-level intent

* `media` should be writable for the fileserver/Samba use case.
* `shared` should be writable for the owner.
* `backups` should not be shared.
* `.system` should remain private.

### Setgid behavior for shared folders

For folders where group inheritance matters, the setgid bit may be useful.

Example:

```bash
chmod 2775 /srv/storage/shared
chmod 2775 /srv/storage/shared/public
chmod 2770 /srv/storage/shared/private
```

---

## Samba Setup

This LXC runs **Samba only** for file sharing.

### Packages installed

```bash
apt update
apt install samba -y
```

### Samba service

The Samba daemon is enabled and started:

```bash
systemctl enable smbd
systemctl restart smbd
systemctl status smbd
```

### Samba configuration

The share definitions are kept minimal and restricted to personal use.

#### Example shares

```ini
[Media]
path = /storage/media
browseable = yes
read only = no
valid users = storageadmin

[Shared]
path = /storage/shared
browseable = yes
read only = no
valid users = storageadmin
```

### Samba account

The Linux account `storageadmin` should also exist as a Samba user.

Commands:

```bash
useradd -m -s /bin/bash storageadmin
smbpasswd -a storageadmin
smbpasswd -e storageadmin
```

---

## What Is Shared

Only the following folders are meant to be exposed through Samba:

* `/storage/media`
* `/storage/shared`

### What is not shared

* `/storage/backups`
* `/storage/.system`
* anything outside `/storage`

---

## Plex Integration

Plex is running in LXC `202` on `pve-main`.

The Plex container mounts only the media folder from the host:

```text
/srv/storage/media -> /media
```

### Plex rule

Plex should never see the backups folder or the private system area.

### Expected Plex access

* Read media files
* Organize its library
* Do not interact with backups

---

## Network Access Paths

The fileserver is intended to be reached on the LAN using:

* **Hostname:** `fileserver.homelab118.home`
* **IP:** `192.168.1.136`

### SMB share examples

```text
\\fileserver.homelab118.home\Media
\\fileserver.homelab118.home\Shared
```

or by IP:

```text
\\192.168.1.136\Media
\\192.168.1.136\Shared
```

---

## Software Installed

### Inside the fileserver LXC

* Ubuntu 24.04 LTS
* Samba
* standard Linux utilities

### Not used anymore

* NFS-Ganesha
* OMV
* any NFS server configuration

---

## What Was Learned During Setup

1. The LXC had working virtual NIC creation, but no IPv4 until networking was fixed.
2. `systemd-networkd` needed `nesting=1` enabled.
3. The fileserver works best as a simple Samba-only service container.
4. Keeping the host as the owner of `/srv/storage` makes the setup cleaner.
5. Sharing only `media` and `shared` keeps the permissions simple.

---

## Recommended Checks

### Host checks

```bash
findmnt /srv/storage
df -hT /srv/storage
ls -lah /srv/storage
```

### LXC checks

```bash
pct config 211
pct enter 211
ip a
ip route
systemctl status smbd
```

### Samba checks

```bash
testparm
smbclient -L localhost -U storageadmin
```

---

## Maintenance Notes

* Keep the fileserver LXC pinned to `pve-main`.
* Do not enable HA.
* Do not move the disk ownership into the LXC.
* Keep `/srv/storage` mounted on the host by UUID.
* Keep the Samba shares small and predictable.
* Back up the Proxmox and Samba configs separately.

---

## Final Goal

The end result is a simple personal fileserver:

* the Proxmox host owns the disk
* the fileserver LXC provides Samba access
* Plex gets direct access to media
* only the intended folders are exposed
* the setup stays easy to rebuild later
