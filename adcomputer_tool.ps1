<#
    Title: adcomputer_tool.ps1
    Authors: Dean Bunn
    Last Edit: 2021-12-14
#>

#Parameters for the Script Action
param ([Parameter(Position=0)]$action="", 
       [Parameter(Position=1)]$computer_name="");

#Var for Config Settings
$cnfgSettings = $null;

#Array for Reporting 
$arrRprting = @();

#Check for Settings File 
if((Test-Path -Path .\config.json) -eq $true)
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


#Function for Disabling Computers Listed in the Disable Text File
function set-actDisableComputers()
{
   #Check File Path for Names of Computers to Disable
   if((Test-Path -Path $cnfgSettings.AD_Computers_To_Disable_Text_File) -eq $true)
   {

        foreach($daCmpt in (Get-Content -Path $cnfgSettings.AD_Computers_To_Disable_Text_File))
        {
            Get-ADComputer -Identity $daCmpt.ToString().Trim() -Server $cnfgSettings.AD_Domain | Set-ADComputer -Enabled $false;
        }

   }
   else 
   {
        #Create the File that Doesn't Exist
        New-Item -Path $cnfgSettings.AD_Computers_To_Disable_Text_File;

        #Notify User
        Write-Output "Required file not found, so we created it";
   }

}#End of set-actDisableComputers

#Function for Reporting Computers Listed in the Report Text File
function get-actComputerReport()
{
    #Check File Path for Names of Computers to Report
   if((Test-Path -Path $cnfgSettings.AD_Computers_To_Report_Text_File) -eq $true)
   {
        #Loop Through the Reporting File Computer Names
        foreach($rptCmpt in (Get-Content -Path $cnfgSettings.AD_Computers_To_Report_Text_File))
        {
            Get-ADComputer -identity $rptCmpt.ToString().Trim() -Server $cnfgSettings.AD_Domain;
        }

   }
   else 
   {
        #Create the File that Doesn't Exist
        New-Item -Path $cnfgSettings.AD_Computers_To_Report_Text_File;

        #Notify User
        Write-Output "Required file not found, so we created it";
   }
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

