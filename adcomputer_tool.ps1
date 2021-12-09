<#
    Title: adcomputer_tool.ps1
    Authors: Dean Bunn
    Last Edit: 2021-12-08
#>

#Parameters for the Script Action
param ([Parameter(Position=0)]$action="", 
       [Parameter(Position=1)]$computer_name="");

#Var for Config Settings
$cnfgSettings = $null;

#Check for Settings File 
if((Test-Path -Path ./config.json) -eq $true)
{
    #Import Json Configuration File
    $cnfgSettings =  Get-Content -Raw -Path .\config.json | ConvertFrom-Json;
}
else
{
    #Create Blank Config Object and Export to Json File
    $blnkConfig = new-object PSObject -Property (@{ AD_Domain="mycollege.edu"; 
                                                    AD_DeptOU_Search_Base="OU=DeptOU,DC=mycollege,DC=edu";
                                                    AD_Computers_To_Report_Text_File=".\AD_Computers_To_Report.txt";
                                                    AD_Computers_To_Disable_Text_File=".\AD_Computers_To_Disable.txt";
                                                    AD_Computers_To_Remove_Text_File=".\AD_Computers_To_Remove.txt";
                                                  });

    $blnkConfig | ConvertTo-Json | Out-File .\config.json;

    #Array of Computer Names for AD_Computers_Example.txt file
    $("computer1","computer2","server1","server2") | Out-File .\AD_Computers_Example.txt;                                   

    #Exit Script
    exit;
}

function set-actDisableComputers()
{
    Write-Output "Would've disabled computers";
    Write-Output $cnfgSettings.AD_Domain;

    #Disable-ADAccount
}

function get-actComputerReport()
{
    Write-Output "Reporting on systems";
}

function remove-actComputers()
{
    Write-Output "Time to say goodbye";
}

function get-actInstructions()
{
    Write-Output " ";
    Write-Output "Script requires an action to run. The available options:";
    Write-Output " ";
    Write-Output "disable";
    Write-Output "remove";
    Write-Output "report";
    Write-Output "report-ou"
    Write-Output " ";
    #Exit Script
    exit;
}

#Determine Requested Action
if([string]::IsNullOrEmpty($action) -eq $false)
{
    switch($action.ToString().ToLower())
    {
        "report" { get-actComputerReport; }
        "disable" { set-actDisableComputers; }
        "removals" { remove-actComputers; }
        default { get-actInstructions; }

    }#End of $action Switch Statement
}
else 
{
    get-actInstructions;
}

