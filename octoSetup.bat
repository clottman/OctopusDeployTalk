:: takes one parameter which is the name of the environment to use in Octopus. 
:: Example usage in Administrator command prompt:   octopusSetup.bat QA

:: Before using, replace: MY_OCTOPUS_SERVER_URL, MY_OCTOPUS_SERVER_DEPLOY_USERNAME, OCTOPUS_SERVER_PASSWORD, and TARGET_ROLE and save script for reuse.
:: Then, only Environment will need to be provided each time the script is run. 

:: make code not output to console
@echo off

:: If no parameter provided, ask the user what environment to use 
IF %1.==. GOTO No1

:: else
set EnvironmentName=%1

GOTO EnvironmentSet

:No1
  set /p EnvironmentName= What environment would you like to use? 
GOTO EnvironmentSet

:EnvironmentSet

echo Running octopus setup for environment %EnvironmentName%

:: make rest of code output to console before commands run
@echo on 


"C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" create-instance --instance "Tentacle" --config "C:\Octopus\Tentacle.config"
"C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" new-certificate --instance "Tentacle" --if-blank
"C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" configure --instance "Tentacle" --reset-trust
"C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" configure --instance "Tentacle" --home "C:\Octopus" --app "C:\Octopus\Applications" --port "10933" --noListen "True"
"C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" service --instance "Tentacle" --stop
"C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" polling-proxy --instance "Tentacle" --proxyEnable "False" --proxyUsername "" --proxyPassword "" --proxyHost "" --proxyPort ""
"C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" service --instance "Tentacle" --start
"C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" register-with --instance "Tentacle" --server "MY_OCTOPUS_SERVER_URL" --name %computername% --username "MY_OCTOPUS_SERVER_DEPLOY_USERNAME" --password "OCTOPUS_SERVER_PASSWORD" --comms-style "TentacleActive" --server-comms-port "10943" --force --environment %EnvironmentName% --role "TARGET_ROLE" --policy ""
"C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" service --instance "Tentacle" --install --start
