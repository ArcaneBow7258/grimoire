+++
date = '2025-04-01T02:28:08Z'
draft = false
title = 'UTW / Century'
description = "Commands and basically solutions to the Century wargame"
+++
# Century
1. Doing the Slack: century1:century1
2. $psversiontable : century2:10.0.14393.7604
	1. $PSVersion doesn't work in version 1, also GetHost is not reliable (only host PS)
	2.  Get-Host is useful but not here
3. Invoke-WebRequest and dir gives u everything
	1. use lowercase
	2. century3:invoke-webrequest443
4. dir is alias for Get-ChildItem
	1. a simple (dir).count gets vtotal
	2. century4:123
5. century5:6265
	1. to go into folders with spaces, encapsulate path in single quotes
6. century6: underthewire3347
	1. (Get-CimInstance Win32_NTDomain | ?{$_.Status -eq "OK"}).DomainName
	2. `[System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain()`
	3. $env:USERDNSDOMAIN
		1. also :COMPUTERNAME and :USERNAME
7. century7:197
	1. same as for #4
	2. use -Directory flag
	3. for files, gci -File
8. century8:7points
	1. gci - Recurse
9. century9:696
	1. Get-Content .\unique.txt | Sort-Object -unique | Measure-Object -line
		1. or type and sort as cmd's
10. century10:pierid
	1. $file = gc Word_file.txt
	2. $file.split(' )
	3. Select-Object -Index 160 or you could do \[160\] for 161st if u have a variable
11. century11:windowsupdates110
	1. Get-Service -> lists all services
	2. findstr / Select-String -> findstr works better
		1. findstr "Update"
		2. service name is wuauserv
	3. Get-WmiObject win32_service is more verbsose than Get-Service
		1. pipe into | Select Name, Description
	4. Select SPecific:
		1. Get-WmiObject win32_service \| ?{\$\_.NAME -like "wuauserv"} \| Select Description | $\_.Description
		2. ($desc).Description.split(" ") | Select-Object -Index 9,8
12. century12:secret_sauce
	1. -Force with dir
	2.  Get-ChildItem | Get-ChildItem -Recurse -File -Hidden | Where-Object {$\_.Name -ne 'desktop.ini'}
13. century13:i_authenticate_things
	1. Manner of waves:
	2. Get-ADComputer gets information about computer
		1. needs -Properties Description to get desc
		2. also initial run needs -Filter "\*" to get all
	3. Alternatively:
		1. Get-ADDomainController to get name first
14. cenutry14:755
	1. How i did it:  $file = gc file -> gc.split(" ") | Measure-Object -line
	2. Measure-Object -Word exists
15. century15:158
	1. (Select-String -Path .\countpolos -Pattern "polo" -AllMatches).Matches.count)