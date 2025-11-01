---
layout: default_c
RefPages:
 - howto_create_a_dev_container   
--- 


# 1 Win32 Native C++ Template Setup & Usage Guide

## ℹ️ Introduction

This WSL Linux (Ubuntu 24.04) Native win32 C++ distribution is designed for the development of Win32 C++ GUI applications, via the WSL container while using the host compiler and SDK. It also setup a Template project which can be instantiated with cookie cutter

## 1.1 Architecture of the Container

We use a script to set up the WSL distribution in a container. This WSL container includes the Linux distribution, a **C++ template project**, and all specialized Visual Studio Code (VSC) configuration files needed to set up, compile, run, and debug the C++ project. The **C++ template project** is a Cookiecutter-based project from which real projects can be instantiated, allowing for the creation of multiple projects.

In contrast with the **Docker App-X11-Forward-win32-CPP-Development-Template Stack** [see here](https://nicojane.github.io/APP-X11-Forward-win32-CPP-Development-Template-Stack/index.html) which is a cross-compiler environment for MinGW, this is a **native Win32** environment where the compiler and SDK from the host are used and must therefore be available. The advantage over the cross-compiled stack is that all types of programs can be created, whereas the cross-compiled stack is limited to more 'traditional' and desktop-oriented applications. The disadvantage of this stack is that some post-configuration is required to integrate the compiler and SDKs with Visual Studio Code (if you have Visual Studio 2022 Professional installed in the default location, you may not need to make many adjustments) 

In any case the checking steps are provide future up in this document (see 5.3).Below is an image that shows how the components interact after the setup is completed. In addition to the processes displayed in the image, this section also includes the folders and files structure, which are detailed in the table *Data locations* below

### The WSL Architecture

![alt text](Context_wsl.png)

 <sub>***Data Locations, Within root 'WSL-Native-Win32-CPP\'***</sub>

| **Folder**                                                     | **Purpose**                                                             |
|:--------------------------------                               |:------------------------------------------------------------------------|
| \ 					                             			                 | **'WSL-Native-Win32-CPP'** root folder, holding the ***CreateWSL.ps1*** script  | 
| \_#Installs_Required 					                                 | source where the WSL distribution install is expected(see 2), 5th program argument       |
| \Howtos                                                        | This and potential other documentation      |
| \Project-Templates  					                                 | C++ folder and files for the project template                                      |

---

#### 2  Download the Ubuntu WSL version

Finding this version can be a bit challenging, especially because we need the manual installation files (with the .Appx or .AppxBundle extensions). The Windows Store provides a direct installer, but we cannot use it because we need to control the installation name and location. Follow these steps:
- Download the image from [here](https://learn.microsoft.com/en-us/windows/wsl/install-manual), Scroll to almost the bottom where it states **'Downloading distributions'** and choose the *Ubuntu 24.04* link (note that this is the distribution  we support, you may try other ones and be fine with it, but we have not tested it)
- Now, as of Aug 2024, a lott of documentation\samples will state that your receive **\*.Appx** extension file and that you need to change the file to **\*.zip.**  But in our case you probably receive a **\*.AppxBundle** file which contains multiple Ubuntu versions. Below is shown how we get access to the right folder so we can install it in the next paragraph (in my case the download name is ***'Ubuntu2204-221101.AppxBundle'*** we use this name in our example:

  - First rename ***'Ubuntu2204-221101.AppxBundle'***' to ***'Ubuntu2204-221101.zip'***
  - Unpack the file with for example **7zip**
  - In the unpacked folder locate the file for your machine distribution ,likely **'Ubuntu_2204.1.7.0_x64.appx'** rename this file to *.zip
  - Unpack the above renamed zip file
  - In the resulting folder you should see a file called ***'install.tar.gz'*** this is the location where the next command has to point to.
  - first make sure to add the above installation folder to the folder **_#Installs_Required**

---

#### 3 Create the  WSL image (here)

When we have the distribution installation source, we can create the WSL environment. Just type in the following command:<br><br> 

<pre class="nje-cmd-one-line"> <small>./CreateWSL.ps1 MyWSL </small> </pre>
This expects the Ubuntu source to be located at: ***./_#Installs_Required/Ubuntu_2404.0.5.0_x64/install.tar.gz*** If this is located in a different folder, you need to specify the full path in the above command: <br><br>
<pre class="nje-cmd-one-line"><small>./CreateWSL.ps1 MyWSL ./WSL-target-dir project-name /mnt/d/project-location ./folder-to-your-installation/install.tar.g</small></pre>

<div class="nje-ident1"> <small> - This creates your WSL under the name: **MyWSL** in the folder: **./WSL-target-dir**  
\- With a project name: **project-name** where project will be in: **/mnt/d/project-location**  
\- And it will use the folder: **./folder-to-your-installation/install.tar.gz** as source installation for the WSL  
</div>

> *Remark:*{: style="color: black;font-size:13px; "}
> <small>As an alternative you can adjust the defaults in the python file <br></small>

To get more information about the program (includes an option to add a package to an existing WSL), type:
<pre class="nje-cmd-one-line"> <small>./CreateWSL.ps1 /? </small> </pre>

<div class="nje-ident1">
When the installation start it will:

- Create the WSL in the **./WSL-target-dir** folder
- Configure the 'MyWSL' *WSL container* with the required packages
- Copy the template C++ project along with the VSC settings and configuration files.
- Add a WSL terminal prompt to identify the WSL.
This process may take between 3 and 5 minutes.

</div>

#### 4 Start the WSL container

To start and manage your WSL container , use the following commands:
<pre class="nje-cmd-multi-line">

wsl -d distribution_name            #  using this command from your prompt will start the container
                                    #  Use 'exit' to return to Windows. while it remains started
wsl --list --verbose                #  Optional. Check if it is running (in other Windows CMD)
wsl --terminate distribution_name   #  Stops the distribution
wsl --unregister distribution_name  #  Removes the container, careful!
wsl --set-default distribution_name #  Set default when running command; wsl

</pre>

---

## 5 Using **V**isual **S**tudio **C**ode  and configuration checks

### 5.1. Open the .NET application container in VSC (@host)

- Press CTRL-SHIFT-P or F1 and start typing  **WSL: Connect to WSL using distro in new Window...**
- Select you WSL container
This opens a new VSC Window with the container.

### 5.2. Open Folder and building your app.

- Use the **VSC Explorer** and select **Open Folder** to open the remote container's folder. **Ensure** that you open the correct folder so the **.vscode** directory settings are applied properly. The name of the folder used can also be found in ***Results.txt***

When opening the WSL container and the project root folder in Visual Studio Code, a dedicated Visual Studio Code server will be installed within the container. This server provides a full Visual Studio Code environment with its own settings and extensions. Upon opening the folder for the first time, the system will detect any required extensions and prompt you to install them. Follow the instructions to complete the installation if prompted. If IntelliSense indicates errors in one of the project files, this is likely due to a missing extension.
<br>

### 5.3. Check VSC config and build files

Please check these files for the correct SDK paths and compiler. They should point to your host directory, where the C drive is represented as **/mnt/c**

- ***./vscode/c_cpp_properties.json*** Check:
  <br><small>- IncludePath</small>
  <br><small>- CompilerPath</small>
- ***./vscode/settings.json*** Check:
  <br><small>- C_Cpp.default.compilerPath</small>
  <br><small>- C_Cpp.default.includePath</small>
- ***_buildtask.bat*** Check variable
  <br><small>- VSDEV_CMD_PATH (top of file)</small>


### 5.4. VSC Use build tasks

In the menu **'Terminal -> Run Tasks...'**, you can find the build tasks for our project, which are defined in the settings file (see the side note above). The following tasks are defined for our project:

- AFX Configure Make 64 bits(CMake)<br>
<small>Call this first to created the make file for the 64 bits application. Creates folder _build64</small> <br>  
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

<sub> This file is part of:  **WSL Native Win32 C++ Development-Template -Stack**
Copyright (c) 2025 Nico Jan Eelhart. This source code is licensed under the MIT License found in the  'LICENSE.md' file in the root directory of this source tree.
</sub>

<p align="center">─── ✦ ───</p>
