# Macos::Artifacts

## Summary:
macOS Artifacts outputs a lot of information. From static facts about a machine (serial number, os version), to outputs of file directories that may be useful for discovery or reconnaissance (launchagents and launchdaemons), to the current state of installed system extensions.

Output is simple text making it able to be scraped up by an MDM or EDR solution to aid in an investigation. You can copy and save to a .yaml format if you want syntax highlighting, though the output format is not strictly yaml.

---
## Installation:

`sudo gem install macos-artifacts`

---
## Usage:

`require 'macos/artifacts'`

```ruby
Macos::Artifacts::Help::options

Macos::Artifacts::computerName
Macos::Artifacts::serial
Macos::Artifacts::version
Macos::Artifacts::build
Macos::Artifacts::kernel
Macos::Artifacts::modelName
Macos::Artifacts::modelID
Macos::Artifacts::chip
Macos::Artifacts::architecture
Macos::Artifacts::memory
Macos::Artifacts::hardwareUID
Macos::Artifacts::publicIP
Macos::Artifacts::privateIP
Macos::Artifacts::sipStatus
Macos::Artifacts::filevaultStatus
Macos::Artifacts::firewallStatus
Macos::Artifacts::screenlockStatus
Macos::Artifacts::lockStatus
Macos::Artifacts::softwareUpdates
Macos::Artifacts::airDrop

Macos::Artifacts::Apps::applications
Macos::Artifacts::Apps::packagesReceipts
Macos::Artifacts::Apps::installHistory
Macos::Artifacts::Apps::appInstallLocations
Macos::Artifacts::Apps::userInstalledApplications

Macos::Artifacts::Files::systemLaunchAgents
Macos::Artifacts::Files::systemLaunchDaemons
Macos::Artifacts::Files::userLaunchAgents
Macos::Artifacts::Files::listUsersAccountDirectory
Macos::Artifacts::Files::systemApplicationSupport
Macos::Artifacts::Files::userApplicationSupport
Macos::Artifacts::Files::libraryPreferences
Macos::Artifacts::Files::userLibraryPreferences
Macos::Artifacts::Files::cronTabs

Macos::Artifacts::Files::etcHosts
Macos::Artifacts::Files::usrLocal
Macos::Artifacts::Files::usrLocalBin
Macos::Artifacts::Files::usrLocalSbin
Macos::Artifacts::Files::usersShared
Macos::Artifacts::Files::privateTmp
Macos::Artifacts::Files::scriptInstallLocations

Macos::Artifacts::State::users
Macos::Artifacts::State::adminUsers
Macos::Artifacts::State::systemExtensions
Macos::Artifacts::State::processCPU
Macos::Artifacts::State::processMemory
Macos::Artifacts::State::openNetworkConnections
Macos::Artifacts::State::networkInterfaces
```



```yaml
#Example output of all Macos::Artifacts commands
Host Name: nics-mac
Serial: X57CLJ67CV
Version: 13.5.1
Build: 22F82
Kernel: 22.5.0
Model Name: MacBook Pro
Model ID: MacBookPro18,3
Chip: Apple M1 Pro
Architecture: arm64
Memory: 16 GB
Hardware UID: 6AE03561-13A4-5218-BA2A-87FF9075FA91
Public IP: 172.76.37.139
Private IP: 192.68.68.68
SIP Status: enabled
FireVault Status: On
Firewall Status: Off
Screen Lock Status: screenLock delay is immediate
Activation Lock Status: Disabled
Software Updates:
  Auto Updates: 1
  Auto Download: 1
  Auto Install: 1
  Install Config Data: 1
  Install Critical Updates: 1
```



For all options run the below and check the output.

```ruby
Macos::Artifacts::Help::options
```

