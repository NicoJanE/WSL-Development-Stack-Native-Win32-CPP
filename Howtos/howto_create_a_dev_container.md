---
layout: default_c
RefPages:
 - howto_create_a_dev_container   
--- 

<br>

# Win32 Native C++ Template <span style="color: #409EFF; font-size: 0.6em; font-style: italic;"> -  WSL Setup & Usage Guide</span>

## ℹ️ Introduction

This WSL Linux (Ubuntu 24.04) Native win32 C++ distribution is designed for the development of Win32 C++ GUI applications, via the WSL container while using the host compiler and SDK. It also setup a Template project which can be instantiated with cookie cutter

### 🎯 Architecture of the Container

A setup script is used to create the WSL distribution inside a container. This WSL container includes the Linux distribution, a **C++ template project**, and all specialized Visual Studio Code (VSC) configuration files required to build, run, and debug the C++ project. The C++ template project is based on Cookiecutter and serves as a foundation from which new projects can be instantiated, allowing you to easily create multiple independent projects.

In contrast with the **Docker App-X11-Forward-win32-CPP-Development-Template Stack** [see here](https://nicojane.github.io/APP-X11-Forward-win32-CPP-Development-Template-Stack/index.html) which provides a cross-compilation environment for MinGW, this setup offers a native Win32 environment. In this configuration, the compiler and SDK from the Windows host system are used directly and must therefore be available on the host. The advantage of this native stack is that it supports building all types of programs, whereas the cross-compilation stack is primarily suited for more traditional or desktop-oriented applications. The trade-off is that some post-configuration may be required to integrate the compiler and SDKs with Visual Studio Code. (If you have Visual Studio 2022 Professional installed in its default location, minimal adjustment should be needed.) which is a cross-compiler environment for MinGW, this is a **native Win32** environment where the compiler and SDK from the host are used and must therefore be available. The advantage over the cross-compiled stack is that all types of programs can be created, whereas the cross-compiled stack is limited to more 'traditional' and desktop-oriented applications. The disadvantage of this stack is that some post-configuration is required to integrate the compiler and SDKs with Visual Studio Code (if you have Visual Studio 2022 Professional installed in the default location, you may not need to make many adjustments)

All related verification steps are provided later in this document (see section 5.3).The image below illustrates how the components interact once setup is complete. Following the image, the Data locations table describes the folder and file structure in detail.

#### 📁 The WSL Files and folders

![alt text](Context_wsl.png)

 <sub>***Data Locations, Within root 'WSL-Native-Win32-CPP\'***</sub>

| **Folder**                                                     | **Purpose**                                                             |
|:--------------------------------                               |:------------------------------------------------------------------------|
| \ 					                             			                 | **'WSL-Native-Win32-CPP'** root folder, holding the ***CreateWSL.ps1*** script  | 
| \_Installs_Required                                            | This and potential other documentation      |
| \Project-Templates                                             | C++ folder and files for the project template                                      |

<div class="nje-br2"> </div>
---
<div class="nje-br1"> </div>

## ⚙️ The Setup

### ⚡ Download the Ubuntu WSL version (preparation)

Finding this version can be a bit challenging, especially because we need the manual installation files (with the .Appx or .AppxBundle extensions). The Windows Store provides a direct installer, but we cannot use it because we need to control the installation name and location. Follow the steps in the background Notes below to obtain the required file: ***'install.tar.gz'***. (Note also that it is not allowed for this site to redistribute this file direct)

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

---

### ⚙️ Create the  WSL environment (including our packages and template files)

When we have the WSL installation file(install.tar.gz) we are able to generate our WSL environment with the packages required. We do this by executing the custom script ***CreateWSL.ps1***  

- Type in the following command:  
   <pre class="nje-cmd-one-line-sm-indent1"> <small>./CreateWSL.ps1 MyWSL </small> </pre>
<span class="nje-br1"> </span>
<span class="nje-expect-indent1"> This expects the Ubuntu source to be located at: ***./_Installs_Required/Ubuntu_2404.0.5.0_x64/install.tar.gz***  
If this is located in a different folder, you need to specify the full path in the above **command:** </span>

<pre class="nje-cmd-one-line-sm-indent1" style="margin-left:39px;" ><small>./CreateWSL.ps1 MyWSL ./WSL-target-dir project-name /mnt/d/project-location ./folder-to-your-installation/install.tar.g</small></pre>
<div class="nje-br"> </div>

<div class="nje-expect-multi-lines-indent2">
After 3 till 5 minutes:
- This creates your WSL under the name: **MyWSL** in the folder: ***/WSL-target-dir***
- With a project name: **project-name** where project will be in: ***/mnt/d/project-location***
- And it will use the folder: ***./folder-to-your-installation/install.tar.gz*** as source installation for the WSL
- With a project name: **project-name** where project will be in: ***/mnt/d/project-location***
</div>

> *Remark:*{: style="color: black;font-size:13px; "}
> <small>As an alternative you can adjust the defaults in the python file <br></small>

- To get more information about the program (includes an option to add a package to an existing WSL), type:

<pre class="nje-cmd-one-line"> <small>./CreateWSL.ps1 /? </small> </pre>


<div class="nje-br2"> </div>
---
<div class="nje-br1"> </div>

## 🏃‍♂️Start the WSL container

To start and manage your WSL container , use the following commands:
<pre class="nje-cmd-multi-line">

wsl -d distribution_name            #  using this command from your prompt will start the container
                                    #  Use 'exit' to return to Windows. while it remains started
wsl --list --verbose                #  Optional. Check if it is running (in other Windows CMD)
wsl --terminate distribution_name   #  Stops the distribution
wsl --unregister distribution_name  #  Removes the container, careful!
wsl --set-default distribution_name #  Set default when running command; wsl

</pre>

<div class="nje-br2"> </div> 
--- 
<div class="nje-br1"> </div>

## ▶️  Using **V**isual **S**tudio **C**ode and configuration checks

### Open the Application Environment in VS Code (@host)

- Press CTRL-SHIFT-P or F1 and start typing  **WSL: Connect to WSL using distro in new Window...**
- Select you WSL container
This opens a new VSC Window with the container.

### Open Folder and building your app

- Use the **VSC Explorer** and select **Open Folder** to open the remote container's folder. **Ensure** that you open the correct folder so the **.vscode** directory settings are applied properly. The name of the folder used can also be found in ***Results.txt***

When opening the WSL container and the project root folder in Visual Studio Code, a dedicated Visual Studio Code server will be installed within the container. This server provides a full Visual Studio Code environment with its own settings and extensions. Upon opening the folder for the first time, the system will detect any required extensions and prompt you to install them. Follow the instructions to complete the installation if prompted. If IntelliSense indicates errors in one of the project files, this is likely due to a missing extension.
<br>

### Check VSC config and build files

Please check these files for the correct SDK paths and compiler. They should point to your host directory, where the C drive is represented as **/mnt/c**

- ***./vscode/c_cpp_properties.json*** Check:
  <br><small>- IncludePath</small>
  <br><small>- CompilerPath</small>
- ***./vscode/settings.json*** Check:
  <br><small>- C_Cpp.default.compilerPath</small>
  <br><small>- C_Cpp.default.includePath</small>
- ***_buildtask.bat*** Check variable
  <br><small>- VSDEV_CMD_PATH (top of file)</small>

### VSC Use build tasks

In the menu **'Terminal -> Run Tasks...'**, you can find the build tasks for our project, which are defined in the settings file (see the side note above). The following tasks are defined for our project:

- AFX Configure Make 64 bits(CMake)<br>
<small>**Call this first!** To created the make file for the 64 bits application. Creates folder _build64</small> <br>  
- AFX Clean all <br>
<small>Remove the _build64 folder, you need the regenerate the makefiles again(see above)</small> <br>
- AFX Build Debug <br>
<small>Creates _build64/bin/debug/outapp.exe</small> <br>
- AFX Build Release <br>
<small>Creates _build64/bin/release/outapp.exe</small> <br>
- AFX Clean debug<br>
<small>removes bin and obj files of debug</small> <br>
- AFX Clean release<br>
<small>removes bin and obj files of release</small> <br>
- AFX Run Debug<br>
<small>Runs debug outApp</small> <br>
- AFX Run Release<br>
<small>RUns Release outApp</small> <br> 

<sub> <i>This file is part of:  **WSL Native Win32 C++ Development-Template -Stack**
Copyright (c) 2025 Nico Jan Eelhart. This source code is licensed under the MIT License found in the  'LICENSE.md' file in the root directory of this source tree.</i>
</sub>

<p align="center">─── ✦ ───</p>
