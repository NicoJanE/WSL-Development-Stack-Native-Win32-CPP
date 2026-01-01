---
layout: default_c
RefPages:
 - howto_create_a_dev_container
--- 
<div class="nje-br3"> </div>

# Win32 Native C++ Template <span style="color: #409EFF; font-size: 0.6em; font-style: italic;"> -  Docker Setup & Usage Guide</span>

![MIT License](https://img.shields.io/badge/License-MIT-green) ![Commercial Services Available](https://img.shields.io/badge/Services-Optional-blue)

## ℹ️ Introduction

This WSL Linux (Ubuntu 24.04) native Win32 C++ distribution is designed for developing Win32 C++ GUI applications via the WSL container while using the host compiler and SDK. It also sets up a template project which can be instantiated with Cookiecutter

### Quick setup

If you have previously installed this container, you can use the quick setup steps below to get running in a few steps. Otherwise please first read the [**full documentation**](https://nicojane.github.io/WSL-Development-Stack-Native-Win32-CPP/Howtos/howto_create_a_dev_container.html)

1. Make sure you have an installation file for the WSL container(**install.tar.gz**) see Background note below.

<details class="nje-back-box">
  <a name="manual-wsl"></a>
  <summary>Get the WSL Installation file🔧
  </summary>

## Download the WSL packages

- From [here](https://learn.microsoft.com/en-us/windows/wsl/install-manual).
- Scroll to the *"Downloading distributions" section.
- Download the Ubuntu 24.04 `.AppxBundle` (this guide assumes this version).
- Unpack the package, like, assuming you downloaded `Ubuntu2404-240425.AppxBundle`:

## Get the right **WSL Import** file

- Rename `Ubuntu2404-240425.AppxBundle` to `Ubuntu2404-240425.zip`
- Unpack it using 7zip or similar
- Find  `Ubuntu_2404.0.5.0_x64.appx` 
  - Rename it to: `Ubuntu_2404.0.5.0_x64.zip` unpack it.
  - Unpack it.  
**Result** you'll get the file: `install.tar.gz` this is what you’ll use in the next step,

<p align="center" style="padding:20px;">─── ✦ ───</p>
</details>
<div class="nje-br3"> </div>

1. Then run the script **CreateWSL.ps1** to generate the WSL environment with the required packages:
   <pre class="nje-cmd-one-line-sm-indent1">./CreateWSL.ps1 MyWSL ./WSL-target-dir project-name /mnt/d/project-location ./folder-to-your-installation/install.tar.gz  </pre>

<div class="nje-expect-multi-lines-indent2">
The results:
- A new WSL environment has been created with the name: **MyWSL** (execute: <span class="nje-cmd-inline-sm"> wsl -l -v </span>)
- The WSL is stored in the project folder under ***./WSL-target-dir***
- In the WSL, the template C++ project is available under the name: ***project-name**
</div>
<div class="nje-br2"> </div>

1. Start VSC and use the Visual Code Command below: (***CTRL-SHIFT-P***) to start the WSL in VS Code,
   <pre class="nje-cmd-one-line-sm-indent1">WSL: Connect to WSL using distribution in new window…  </pre>

1. You can then Open project folder in VS Code Container (File -> Open Folder) and start coding.

<span style="color: #6d757dff; font-size: 13px; font-style: italic;"> <br>
<i><b>License</b><br>This file is part of: ***WSL Native Win32 C++ Template -Stack**  Copyright (c) 2025-2026 Nico Jan Eelhart.This repository is [MIT licensed](MIT-license.md) and free to use. For optional commercial support, customization, training, or long-term maintenance, see [COMMERCIAL.md](COMMERCIAL.md).</i>
</span>


<br>
<p align="center">─── ✦ ───</p>
