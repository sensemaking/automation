Add-Type -TypeDefinition @"
public enum Project
{
   None = 0,
   Automation = 1,
   Common = 2,
   Messaging = 4,
   Authoring = 8,
   PlatformCommon = 16,
   Rules = 32,
   Swaps = 64,
   AreasOfInterest = 128,
   PlatformHandlers = 256,
   Provisioning = 512,
   ContentAuthoring = 1024,
   Emis = 2048,
   Opportunities = 4096,
   Smokes = 8192,
   Reporting = 16384,
   ArxCommon = 32768,
   All = Automation + Common + Messaging + Authoring + PlatformCommon + Rules + Swaps + AreasOfInterest + PlatformHandlers + Provisioning + ContentAuthoring + Emis + Opportunities + Smokes + Reporting + ArxCommon
}
"@

function global:Get-Projects {
   return @{
      [Project]::Automation = [PSCustomObject]@{Directory = "~\fdb-rx-automation"; HasJs = $false; CodeSolution = "~\fdb-rx-automation"; VsSolution = $null; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-automation.git" };
      [Project]::Common = [PSCustomObject]@{Directory = "~\fdb-rx-common"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-common\Common.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-common.git" };
      [Project]::Messaging = [PSCustomObject]@{Directory = "~\fdb-rx-messaging"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-messaging\Messaging.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-messaging.git" };
      [Project]::Authoring = [PSCustomObject]@{Directory = "~\fdb-rx-authoring"; HasJs = $false; CodeSolution = "~\fdb-rx-authoring\Provision"; VsSolution = "~\fdb-rx-authoring\Authoring.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-authoring.git" };
      [Project]::PlatformCommon = [PSCustomObject]@{Directory = "~\fdb-rx-platform-common"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-platform-common\Platform.Common.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-platform-common.git" };
      [Project]::Rules = [PSCustomObject]@{Directory = "~\fdb-rx-rules"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-rules\Rules.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-rules.git" };
      [Project]::Swaps = [PSCustomObject]@{Directory = "~\fdb-rx-swaps"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-swaps\Swaps.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-swaps.git" };
      [Project]::PlatformHandlers = [PSCustomObject]@{Directory = "~\fdb-rx-platform-handlers"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-platform-handlers\Platform.Handlers.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-platform-handlers.git" };
      [Project]::Provisioning = [PSCustomObject]@{Directory = "~\fdb-rx-provisioning"; HasJs = $false; CodeSolution = "~\fdb-rx-provisioning"; VsSolution = $null; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-provisioning.git" };
      [Project]::ContentAuthoring = [PSCustomObject]@{Directory = "~\fdb-arx-content-authoring"; HasJs = $true; CodeSolution = "~\fdb-arx-content-authoring\Host\Ui\Web\src"; VsSolution = "~\fdb-arx-content-authoring\ContentAuthoring.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-arx-content-authoring.git" };
      [Project]::Emis = [PSCustomObject]@{Directory = "~\fdb-arx-emis"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-arx-emis\Emis.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-arx-emis.git" };       
      [Project]::Opportunities = [PSCustomObject]@{Directory = "~\fdb-arx-opportunities"; HasJs = $true; CodeSolution = "~\fdb-arx-opportunities\Host\Ui\Web\src"; VsSolution = "~\fdb-arx-opportunities\Opportunities.sln"; Script = "~\fdb-arx-opportunities\Scripting\Opportunities.ps1"; Git = "git@github.com:HearstHealthInternational/fdb-arx-opportunities.git" };
      [Project]::Smokes = [PSCustomObject]@{Directory = "~\fdb-arx-smokes"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-arx-smokes\Smokes.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-arx-smokes.git" };
      [Project]::Reporting = [PSCustomObject]@{Directory = "~\fdb-arx-reporting"; HasJs = $true; CodeSolution = "~\fdb-arx-reporting\Host\Ui\Web\src"; VsSolution = "~\fdb-arx-reporting\Reporting.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-arx-reporting.git" };
      [Project]::AreasOfInterest = [PSCustomObject]@{Directory = "~\fdb-rx-areas-of-interest"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-areas-of-interest\AreasOfInterest.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-areas-of-interest.git" };
      [Project]::ArxCommon = [PSCustomObject]@{Directory = "~\fdb-arx-common"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-arx-common\ArxCommon.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-arx-common.git" };
   }
} 
function global:Update-ArxProjects { 
   $automationDir =((get-projects).GetEnumerator() | where { $_.Name -eq "Automation" }).Value.Directory 
   $profileDir = Split-Path $PROFILE
   
   if(!(Test-Path $automationDir)){ clone Automation }

   pull Automation
 
   Copy-Item "$automationDir\ArxProjects.ps1" -Destination "$profileDir\Projects.ps1" -fo
   powershell.exe
}