# EZOSD - User Guide

## Overview

EZOSD (Enterprise Zero-Touch Operating System Deployment) is a PowerShell-based Windows deployment tool. The **USB Creator** component allows technicians to build a bootable USB drive that can automatically image a target device with a pre-configured Windows installation — including drivers and post-install customizations — with minimal interaction.

Use this article when:
- A device needs to be reimaged
- You need to create a new deployment USB drive
- An existing USB drive is missing, corrupted, or out of date

---

## Requirements

### To Create a USB Drive (Technician Machine)

| Requirement | Details |
|---|---|
| Operating System | Windows 10/11 or Windows Server 2016+ |
| Privileges | Administrator (local admin required) |
| PowerShell | Version 5.1 or later (built into Windows 10/11) |
| USB Drive | 16 GB minimum; USB 3.0 recommended |
| Windows ADK | Must be installed — see note below |

> **Windows ADK:** The Windows ADK is required for the USB Creator to build the
> WinPE environment and create the bootable USB. If the ADK is not installed,
> the USB Creator will attempt to install it automatically, or you can install
> it manually before running the USB Creator.

### To Deploy Windows (Target Device)

| Requirement | Details |
|---|---|
| Firmware | UEFI or BIOS |
| Target Disk Size | 64 GB minimum (32 GB absolute minimum) |
| Network | Active network connection (wired preferred) |
| Boot Media | EZOSD bootable USB created using this guide |

---

## Part 1: Creating the Bootable USB Drive

### Step 1 — Download the USB Creator

1. Go to the latest release:  
   https://github.com/mattskare/EZOSD-Private/releases/latest/download/EZOSD-USBCreator.zip

2. Right-click the downloaded `.zip` file and select **Extract All**.

3. Open the extracted folder. You should see the following files:
   - `EZOSD-USBCreatorGUI.ps1`
   - `EZOSD-USBCreator.ps1`
   - `SetBootConfig.cmd`
   - `USBCREATORVERSION`

### Step 2 — Insert Your USB Drive

- Insert a USB drive (16 GB or larger) into your machine.
- **All data on the USB drive will be erased.** Make sure there is nothing on it that needs to be kept.

### Step 3 — Run the USB Creator (GUI)

1. Open **PowerShell as Administrator**:
   - Press `Win + X` → Select **Windows PowerShell (Admin)** or **Terminal (Admin)**

2. Navigate to the extracted folder:
   ```powershell
   cd C:\Path\To\Extracted\EZOSD-USBCreator
   ```

3. Run the GUI:
   ```powershell
   .\EZOSD-USBCreatorGUI.ps1
   ```

   > If you receive an execution policy error, run this first:
   > ```powershell
   > Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   > ```

### Step 4 — Build the USB Drive

1. In the USB Creator window, select your USB drive from the **Drive** dropdown.
   - Double-check the drive letter to avoid overwriting the wrong disk.

2. Click **Start**.

3. The process will run automatically. You will see a live log in the window.  
   **Do not close the window or remove the USB while it is running.**

4. When complete, the log will show a success message.  
   The USB drive is now ready to use.

> **Typical build time:** 5–15 minutes depending on your machine and USB speed.

---

## Part 2: Deploying Windows with the USB Drive

### Step 1 — Prepare the Target Device

- Ensure the target device is powered off.
- If the device has a working OS and data on it, confirm with the user (or ticket) that the device is approved for reimaging. **This process will erase all data.**

### Step 2 — Boot from the USB Drive

1. Insert the EZOSD USB drive into the target device.

2. Power on the device and immediately press the boot menu key for that device (usually F12 for Dell)

3. In the boot menu, select the **USB drive** as the boot device.

### Step 3 — Select Architecture

When WinPE loads, you will be prompted to select the Windows architecture:

- **x64** — Use for standard Intel/AMD 64-bit devices (most common)
- **arm64** — Use for ARM-based devices (e.g., Snapdragon-powered devices)

### Step 4 — Automated Deployment

Once the architecture is selected, EZOSD will run automatically and perform the following steps without further input:

1. Detect and partition the target disk
2. Download (or apply) the Windows image
3. Inject device drivers
4. Apply Windows and configure the bootloader
5. Run post-installation scripts (e.g., updates, software install)
6. Reboot into the newly installed Windows environment

> **Typical deployment time:** 15–45 minutes depending on network speed and disk type (SSD vs. HDD).

---

## Common Issues and Troubleshooting

### Device Does Not Boot from USB

**Symptoms:** Device boots into existing OS or shows a boot error.

**Steps to resolve:**
1. Confirm the USB is properly seated in the port.
2. Try a different USB port.
3. Reboot and press the boot menu key earlier (immediately after power-on).
4. Enter BIOS/UEFI setup (usually F2 or DEL) and verify **USB Boot** is enabled.
5. If the issue persists, recreate the USB drive using this guide.

---

### Deployment Appears Stuck

**Symptoms:** Progress stops for an extended period during download or image application.

**What to expect (normal):**
- Downloading Windows image: 5–20 minutes (depends on network)
- Applying image to disk: 5–20 minutes (depends on disk type)
- SSD deployments are significantly faster than HDD

---

### USB Drive Creation Fails

**Symptoms:** The USB Creator shows an error and does not complete.

**Common causes:**
- Windows ADK is not installed or is missing components
- Insufficient space on USB drive (must be 16 GB+)
- USB drive write-protected

**Steps to resolve:**
1. Verify Windows ADK is installed with **Deployment Tools** and **Windows PE** components.
2. Try a different USB drive.
3. Make sure PowerShell was launched as Administrator.

---

## Frequently Asked Questions

**Q: Will this process erase the user's data?**  
A: Yes. EZOSD wipes and repartitions the target drive. Ensure all user data has been backed up before proceeding.

**Q: What if I select the wrong architecture?**  
A: The deployment will likely fail or produce an unbootable system. Restart the process and select the correct option. When in doubt, use x64.

**Q: How do I know if a device is ARM or x64?**  
A: Check the device spec sheet or look up the model number. ARM devices include Snapdragon-based laptops. Most standard business laptops are x64.

**Q: The USB Creator asks for a password to access Advanced Options — what is it?**  
A: Advanced options are hidden by design. If needed, please reach out to the Endpoint Windows team if those settings need to be changed.

**Q: How often should I recreate the USB drive?**  
A: Recreate the USB whenever a new version of the EZOSD USB Creator is released. Always download from the latest release link.

---

## Escalation

If you are unable to resolve the issue using this article, please reach out to a member of the Endpoint Windows team with the following information:

- Device make, model, and serial number
- Description of the step where the failure occurred
- A photo or screenshot of any error message displayed
- The version of the USB Creator used (shown in the GUI title bar)
