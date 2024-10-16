# ./WSL-native-win32-c++.ps1
#
#   This script creates a WSL environment and a template C++ program, including all necessary Visual Studio Code tools
#   and files to enable compilation. Before running the C++ program, you can/must use the Cookiecutter 
#   program to instantiate a C++ project from the template.
# 
#   At the end of this installation/configuration, you will see the instructions for using this image


# Script-level param blockm, first is required rest have sensible defaults
param (
#    [Parameter(Mandatory=$true)]
    [string]$distribution_name,
    [string]$WSL_target_dir     = "./Images/",
    [string]$project_name       = "Tmplcpp",
    [string]$CPP_project_dir    = "/mnt/d/WSL/WSL-Data/Projects",
    [string]$WSL_distr_source   = "./_#Installs_Required/Ubuntu_2404.0.5.0_x64/install.tar.gz"
)

# Global variables
$WSL_target_dir+= $distribution_name
$ExtendOption="!Extend"
$help_flags = @("?", "-?", "--?", "-h","--h", "-help",,"--help", "/help")

# Argument checking and Help information
if ( -not $distribution_name -or -not $project_name -or $help_flags -contains ($distribution_name.ToLower()) ) 
{
    $scriptName=$MyInvocation.MyCommand.Name
    Clear-Host
    Write-Host " `n`n General Syntax" -ForegroundColor Red
    Write-Host " Argument 1 is required! The others use defaults.`n" -ForegroundColor Red
    Write-Host " EXAMPLE: ./$scriptName`t[Distribution-name] [WSL-target-dir ($WSL_target_dir)] [project-name ($project_name)]`n`t`t`t`t[CPP-data-dir ($CPP_project_dir)]`n`t`t`t`t[WSL_distr_source ($WSL_distr_source)] `n`n" -ForegroundColor green
    Write-Host " Sepcial syntax. Add/Remove package: " -ForegroundColor green
    Write-Host " EXAMPLE: ./$scriptName`t[Distribution-name] @Extend 'sudo apt install -y tree;'`n " -ForegroundColor green
    Write-Host " `nSUPPORTED Distribution:`n`n`t- Debian`n`t- Linux Mint`n`t- PureOS`n`t- Pop!_OS`n`t- Zorin OS`n`t- Ubuntu`n`t- Any other apt Linux based distribution should work`n`n " -ForegroundColor green
    exit 1 
}


# Install Ubuntu if it's not already installed, and wait until it is done
function InstallWSLDistro
{    		
    param (
        [string]$distroSource 
    )
    $doesExist = IsDistroExisting

    if(-not $doesExist)
    {        
        Write-Host "`n - WSL base, installing:`n`t- $distribution_name to: $WSL_target_dir.`n`t- Form: $WSL_distr_source`n`t- C++ project:$CPP_project_dir$project_name`n"
        wsl --import $distribution_name $WSL_target_dir  $distroSource         
        if ($LASTEXITCODE -ne 0)
        {
            Write-Host "`n - WSL: ***Error*** " -ForegroundColor Red
            Write-Host "Details: $($Error[0])`n`n" -ForegroundColor Red
            exit 1
        }
        else{    
            WaitTillDone
        }
    }
    else {
        Write-Host "`n`n - WSL base, $distroSource  already  installed  ('$distribution_name')."        
    }
}

# Configure the WSL with the packages that we require for our WSL
function ConfigureWSLDistro
{ 
    # Run setup commands in the newly created WSL Ubuntu environment with root privileges
    # using sudo. WSL session will stop when commands are done.
    wsl -d $distribution_name -- bash -c "
    echo 'Updating package lists...'
    sudo apt update && sudo apt upgrade -y;

    echo 'Installing GCC...'
    sudo apt install -y build-essential;

    echo 'Installing Python and pip...'
    sudo apt install -y python3 python3-pip;

    echo 'Installing Cookiecutter with pipx (installs the apps in isolated env)'
    sudo apt install pipx -y
    pipx install cookiecutter
    pipx ensurepath

    echo 'WSL setup complete: GCC and Cookiecutter installed.';
    "

    $greenPrompt  = 'PS1="\[\033[92m\]WSL:\[\033[0m\]\[\033[0;33m\]${debian_chroot:+(\$debian_chroot)}\u\[\033[0m\]:\[\033[92m\] Native_Win32_CPP \[\033[0m\]../\W#"'
    ConfigureWSLDistro_Extend_Bash -bashrcContent $greenPrompt
    
    $source="Project-Templates/GUI-Application/"
    $dest="$CPP_project_dir$project_name/"
    CopyDirContent -sourcePath $source -destinationPath $dest
    ConfigureWSLDistro_Extend_Bash -bashrcContent "cd $dest"

    FinalInstructions
}


# Extends .bashrc with a specific line
function ConfigureWSLDistro_Extend_Bash 
{
    param (
        [string]$bashrcContent 
    )
 
    Write-Host_Bold $bashrcContent
    # Build the command to append the PS1 variable to .bashrc and source it
    # WARNING: Without here-string it wont work!! Picky with space leave the format (Sick stuff)
    $command = @"
                    echo '$bashrcContent' >> ~/.bashrc
                    echo '#Auto generated(fix)' >> ~/.bashrc            
"@

    # Execute the command in WSL
    $result = Write-Output $command | wsl -d $distribution_name -- bash

    # Check if the command was successful
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n - WSL: ~/.bashrc has been successfully updated`n"
    } else 
    {
        Write-Host "`n - WSL: ***Error*** adding PS1 to .bashrc." -ForegroundColor Red
        Write-Host "Result: $result"
    }
}

# Additional command line option to extend an existing WSL with one or more packages
# Example: /CreatWSL.ps Distribution-name @Extend 'sudo apt install -y tree;'
function ConfigureWSLDistro_Extend_Custom
{   param (
        [string]$content 
    )

    $content_apt = "sudo apt update && sudo apt upgrade -y;" +$content 
    Write-Host "Input: $content_apt"
    # Run setup commands in the newly created WSL Ubuntu environment with root privileges
    # using sudo. WSL session will stop when commands are done.
    wsl -d $distribution_name -- bash -c "
    $content_apt
    "
    FinalInstructions
}

function FinalInstructions
{
    $dest="$CPP_project_dir$project_name/"
    $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Write-Host "`n - WSL: installd or extened the configuration successfully!`n"
    Write-Host "`t Visual Studio Code\WSL CLI instructions:"
    Write-Host "`t`t --> Start the WSL with: wsl -d $distribution_name "
    Write-Host "`t`t     1. VSC: CTRL-SHIFT-P, 'WSL:Connect to WSL Using Distro...' "
    Write-Host "`t`t --> Your project can be found at: $dest"
    Write-Host "`t`t     2. VSC: Open folder "
    Write-Host "`n`t Information also added to: Results.txt`n"
    
$outputToFile = @"
`n`n
New WSL Create:
- Start the WSL with: wsl -d $distribution_name
- Your project can be found at: $dest
Add at:$currentDateTime
"@
$outputToFile | Out-File -FilePath "Results.txt" -Encoding UTF8 -Append

}


# Check if WSL is installed by listing distributions
function IsDistroExisting
{    
    Write-Host "Checking if WSL is installed..."
    $wslCheck = wsl --list --quiet

    if ($wslCheck -contains $distribution_name) 
    {
        Write-Host "'`n - WSL is (allready) installed  ('$distribution_name')."
        return $true
    } 
    else {        
        return $false
    }
}

function CopyDirContent
{
    param ( [string]$sourcePath,  [string]$destinationPath )

    # Note: rsync will automatically create the destination directory and sub Dir's 
    # if it doesn’t exist (use '-a' and add '/'' to last target dir)
    wsl -d $distribution_name -- bash -c "
    rsync -a $sourcePath $destinationPath
    "
}

function WaitTillDone {
        # Wait for Ubuntu to be installed and available
    Write-Host "Waiting for Ubuntu installation to complete..."
    $maxRetries = 30  # Maximum retries to prevent infinite loop
    $retryCount = 0

    while ($retryCount -lt $maxRetries) 
    {
        # Check if Ubuntu is listed in the available WSL distributions
        if(IsDistroExisting)
        {
            Write-Host "WSL basic installation complete. Update configuration..."
            break
        }
        else 
        {
            Write-Host "Still waiting for installation to complete... retrying in 5 seconds."
            Start-Sleep -Seconds 5
            $retryCount++
        }
    }

    if ($retryCount -eq $maxRetries) 
    {
        Write-Host "Error: WSL installation took too long. Please check your installation manually."
        exit 1
    }
}



# Start Main
# ========================================================================================================================
#
Write-Host $ExtendOption
if( $WSL_target_dir -ne $ExtendOption)
{
    # Install and configure the WSl distribution  it's not already installed    
    InstallWSLDistro -distroSource $WSL_distr_source
    ConfigureWSLDistro
}
elseif ($WSL_target_dir -eq $ExtendOption)
{
    # okay we abuse the $distribution_name to trigger the '!extend' option and  $project_name for the apt command
    Write-Host "EXTENDING existing distribution: $distribution_name with $project_name"
    ConfigureWSLDistro_Extend_Custom -content $project_name
}

