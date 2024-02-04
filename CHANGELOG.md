# Change Log


---
## version 0.6.4
- Add:  airdrop activity for the last 7 days shows timestamps. Macos::Artifacts::airDrop
- Add: applications installed in current users account. Macos::Artifacts::Apps::userInstalledApplications
- Fixed: IO error with Macos::Artifacts::Apps::applications when plist file didn't exist
- Fixed: IO error with Macos::Artifacts::Files::systemLaunchAgents when is a symlink or doesn't exist


---
## version 0.6.3
- Update: minor syntax change for System Extensions
- Fixed: error with Apps::InstallHistory US-ASCII error


---
## version 0.6.2
- Fixed: workaround for listing files in user directory where listing items in the .Trash resulted in an error

---
## version 0.6.1
- Fixed: checking plist to make sure they are valid before reading them with CFPropertyList

---
## version 0.6.0
- Add: `help` to output options. User `Macos::Artifacts::Help::options`

---
## version 0.5.2
- Add: `state` list of open network connections
- Add: `files` directory output for /private/tmp
- Add: `files` directory output for /Users/Shared

---
## version 0.5.0
- Add: `apps` module


---
## version 0.4.3
- Add: processCPU to `state` module
- Add:  processMemoery to `state` module


---
## version 0.4.2
- Add: crontab to `files` module
- Add: hosts file to `files` module


---
## version 0.4.1
- Add: Preference files for system and users

---
## version 0.4.0
- UPDATE: refactor


---
## version 0.3.0
- UPDATE: break `logs` module out to it's own file


---
## version 0.2.2
- UPDATE: break `state` module out to it's own file


---
## version 0.2.0
- ADD: `state` module


---
## version 0.1.5
- ADD: `logs` module


---
## version 0.1.0
- Initial release
