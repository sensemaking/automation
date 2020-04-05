Add-Type -TypeDefinition @"
public enum Project
{
   None = 0,
   Automation = 1,
   Common = 2,
   Authoring = 4,
   PlatformCommon = 8,
   Rules = 16,
   Swaps = 32,
   AreasOfInterest = 64,
   PlatformHandlers = 128,
   RuleAuthoring = 256,
   DataTransfer = 512,
   OptimiseRx = 1024,
   Accounts = 2048,
   PointOfCare = 4096,
   OrxInfrastructure = 8192,
   OrxCommon = 16384,
   DataWarehouse = 32768,
   Reports = 65536,
   Perch = 131072,
   PointOfCareHandler = 262144,
   RuleAuthoringHandler = 524288,
   UserServiceHandler = 1048576,
   PointOfCareMessageService = 2097152,
   Analytics = 4194304,
   Smokes = 8388608,
   UserService = 16777216,
   Translator = 33554432,
   Messaging = 67108864,
   SnomedTermEditor = 134217728,
   SnomedTermEditorUI = 268435456,
   ClinicalAuthoring = 536870912,
   All = Automation + Common + Messaging + Authoring + PlatformCommon + Rules + Swaps + AreasOfInterest + PlatformHandlers +
         RuleAuthoring + DataTransfer + OptimiseRx + Accounts + PointOfCare + OrxInfrastructure + OrxCommon + DataWarehouse +
         Reports + Perch + PointOfCareHandler + RuleAuthoringHandler + UserServiceHandler + PointOfCareMessageService + Analytics +
         Smokes + UserService + Translator + SnomedTermEditor + SnomedTermEditorUI + ClinicalAuthoring
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
      [Project]::RuleAuthoring = [PSCustomObject]@{Directory = "~\fdb-rx-rule-authoring"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-rx-rule-authoring\RuleAuthoringService.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-rule-authoring.git" };
      [Project]::DataTransfer = [PSCustomObject]@{Directory = "~\fdb-orx-data-transfer"; HasJs = $false; CodeSolution = $null; VsSolution = $null; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-data-transfer.git" };
      [Project]::OptimiseRx = [PSCustomObject]@{Directory = "~\fdb-optimiseRx"; HasJs = $false; CodeSolution = $null; VsSolution = $null; Script = "~\fdb-optimiseRx\Scripting\ORx.psm1"; Git = "git@github.com:HearstHealthInternational/fdb-optimiseRx.git" };
      [Project]::Accounts = [PSCustomObject]@{Directory = "~\fdb-orx-accounts"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-orx-accounts\Accounts.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-accounts.git" };
      [Project]::PointOfCare = [PSCustomObject]@{Directory = "~\fdb-orx-pointofcare"; HasJs = $false; CodeSolution = $null; VsSolution = "~\fdb-orx-pointofcare\PointOfCare.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-pointofcare.git" };
      [Project]::OrxInfrastructure = [PSCustomObject]@{Directory = "~\fdb-optimiseRxInfrastructure"; HasJs = $false; CodeSolution = $null; vsSolution = $null; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-optimiseRxInfrastructure.git" };
      [Project]::OrxCommon = [PSCustomObject]@{Directory = "~\fdb-orx-common"; HasJs = $false; CodeSolution = $null; vsSolution = $null; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-common.git" };
      [Project]::DataWarehouse = [PSCustomObject]@{Directory = "~\fdb-orx-data-warehouse"; HasJs = $false; CodeSolution = $null; vsSolution = $null; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-data-warehouse.git" };
      [Project]::Reports = [PSCustomObject]@{Directory = "~\fdb-orx-reports"; HasJs = $false; CodeSolution = $null; vsSolution = $null; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-reports.git" };
      [Project]::Perch = [PSCustomObject]@{Directory = "~\fdb-rx-perch"; HasJs = $false; CodeSolution = $null; vsSolution = "~\fdb-rx-perch\CanaryLaunch.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-perch.git" };
      [Project]::PointOfCareHandler = [PSCustomObject]@{Directory = "~\fdb-rx-pocservice.handler"; HasJs = $false; CodeSolution = $null; vsSolution = "~\fdb-rx-pocservice.handler\OptimiseRxPoCService.Handler\OptimiseRxPoCService.Handler.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-pocservice.handler.git" };
      [Project]::RuleAuthoringHandler = [PSCustomObject]@{Directory = "~\fdb-rx-rule-authoring-handler"; HasJs = $false; CodeSolution = $null; vsSolution = "~\fdb-rx-rule-authoring-handler\Rx-RuleAuthoringService-Handler\Rx-RuleAuthoringService-Handler.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-rule-authoring-handler.git" };
      [Project]::UserServiceHandler = [PSCustomObject]@{Directory = "~\fdb-rx-user-service-handler"; HasJs = $false; CodeSolution = $null; vsSolution = "~\fdb-rx-user-service-handler\RxUserService.Handler.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-rx-user-service-handler.git" };
      [Project]::PointOfCareMessageService = [PSCustomObject]@{Directory = "~\OptimiseRxPoCMessageService"; HasJs = $false; CodeSolution = $null; vsSolution = "~\OptimiseRxPoCMessageService\OptimiseRxPoCMessageService.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/OptimiseRxPoCMessageService.git" };
      [Project]::Analytics = [PSCustomObject]@{Directory = "~\fdb-orx-analytics"; HasJs = $false; CodeSolution = $null; vsSolution = $null; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-analytics.git" };
      [Project]::Smokes = [PSCustomObject]@{Directory = "~\fdb-orx-smokes"; HasJs = $false; CodeSolution = $null; vsSolution = "~\fdb-orx-smokes\Smokes.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-smokes.git" };
      [Project]::UserService = [PSCustomObject]@{Directory = "~\fdb-optimiseRx\GpCommissioning\UserService"; HasJs = $false; CodeSolution = $null; vsSolution = "~\fdb-optimiseRx\GpCommissioning\UserService\UserService.sln"; Script = $null; Git = $null };
      [Project]::Translator = [PSCustomObject]@{Directory = "~\fdb-orx-translate"; HasJs = $false; CodeSolution = $null; vsSolution = "~\fdb-orx-translate\Translator.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-translate.git" };
      [Project]::SnomedTermEditor = [PSCustomObject]@{Directory = "~\fdb-orx-snomed-term-editor"; HasJs = $false; CodeSolution = "~\fdb-orx-snomed-term-editor\Host\Ui\Web\src"; vsSolution = "~\fdb-orx-snomed-term-editor\SnomedTermEditor.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-snomed-term-editor.git" };
      [Project]::SnomedTermEditorUI = [PSCustomObject]@{Directory = "~\fdb-orx-snomed-term-editor-ui"; HasJs = $false; CodeSolution = $null; vsSolution = "~\fdb-orx-snomed-term-editor-ui\SnomedTermEditorUi.sln"; Script = $null; Git = "git@github.com:HearstHealthInternational/fdb-orx-snomed-term-editor-ui.git" };
      [Project]::ClinicalAuthoring = [PSCustomObject]@{Directory = "~\fdb-rx-clinical-authoring"; HasJs = $false; CodeSolution = "~\fdb-rx-clinical-authoring\Host\Ui\Web\src"; vsSolution = "~\fdb-rx-clinical-authoring\ClinicalAuthoring.sln"; Script = $null; Git = "git@ssh.dev.azure.com:v3/FirstDatabankUK/OptimiseRx/fdb-rx-clinical-authoring" };
   }
} 
function global:Update-OrxProjects { 
   $automationDir =((get-projects).GetEnumerator() | where { $_.Name -eq "Automation" }).Value.Directory 
   $profileDir = Split-Path $PROFILE
   
   if(!(Test-Path $automationDir)){ clone Automation }

   pull Automation
 
   Copy-Item "$automationDir\OrxProjects.ps1" -Destination "$profileDir\Projects.ps1" -fo
   powershell.exe
}