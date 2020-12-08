# VMware.LifecycleMatrix

A Powershell module to interact with the VMware Product Lifecycle Matrix website (<https://lifecycle.vmware.com>)

This module is not supported by VMware, and comes with no warranties express or implied. Please test and validate its functionality before using this product in a production environment.

## Installing VMware.LifecycleMatrix

### Powershell Gallery

VMware.LifecycleMatrix is available from the PowerShell Gallery. Run the following command in a PowerShell session to install the module:

```PowerShell
Install-Module VMware.LifecycleMatrix
```

### Manual Install

If for some reason, your system is unable to access PowerShell Gallery to install modules, you can install the module manually:

Open a PowerShell session and run the following command to find all the module installation paths on your system.

```PowerShell
$env:PSModulePath
```

Navigate to one of the paths returned from the command above, and create a new directory for the module

```PowerShell
New-Item VMware.LifecycleMatrix -ItemType Directory
```

Download the `.psd1` and `.psm1` files from <https://github.com/dcoghlan/VMware.LifecycleMatrix/tree/main/module> and save them to the directory created above.

## Loading the module

Once the VMware.LifecycleMatrix module is loaded onto your system, run the following command to import the module for use:

```PowerShell
Import-Module VMware.LifecycleMatrix
```

## What's Available

There are only a couple of cmdlets in this module. To view them all, run the following command:

```PowerShell
Get-Command -Module VMware.LifecycleMatrix
```

Each available cmdlet will return details and examples via the built-in Get-Help cmdlet.

```PowerShell
Get-Help Get-PLMProduct -Full
```

## Sample Usage

### Connect to PLM Server

```Powershell
PS > Connect-PLMServer

AuthServer : auth.esp.vmware.com
PLMServer  : plm.esp.vmware.com
ClientId   : plm-prod-auth
PLMToken   : <removed>
Protocol   : https
```

### Connect to PLM Server and NOT display connection variable

```Powershell
PS > Connect-PLMServer -Quiet
PS>
```

### List all products available on the VMware Product Lifecycle Matrix website

```PowerShell
PS > Get-PLMProduct | ft

Name                                                                              Status    GADate              EOSDate             EOTGDate            EOADate             Policy Notes
----                                                                              ------    ------              -------             --------            -------             ------ -----
App Volumes 2.14 (ESB)                                                            Supported 28/05/2018 00:00:00 28/05/2020 00:00:00 28/05/2021 00:00:00                     EDP
App Volumes 2.15                                                                  Supported 13/12/2018 00:00:00 13/12/2020 00:00:00 13/12/2021 00:00:00                     EDP
App Volumes 2.16                                                                  Supported 14/03/2019 00:00:00 14/03/2021 00:00:00 14/03/2022 00:00:00                     EDP
App Volumes 2.17                                                                  Supported 02/07/2019 00:00:00 02/07/2021 00:00:00 02/07/2022 00:00:00                     EDP
App Volumes 2.18 (ESB)                                                            Supported 16/09/2019 00:00:00 16/09/2021 00:00:00 16/09/2022 00:00:00                     EDP
App Volumes 4                                                                     Supported 14/01/2020 00:00:00 14/01/2022 00:00:00 14/01/2023 00:00:00                     EDP
App Volumes 4 2006                                                                Supported 09/07/2020 00:00:00 09/07/2022 00:00:00 09/07/2023 00:00:00                     EDP
App Volumes 4 2009                                                                Supported 15/10/2020 00:00:00 15/10/2022 00:00:00 15/10/2023 00:00:00                     EDP
Cloud Director App Launchpad 1.0                                                  Supported 09/04/2020 00:00:00 09/04/2022 00:00:00
Cloud Director App Launchpad 2.0                                                  Supported 15/10/2020 00:00:00 15/10/2022 00:00:00
Cloud Director Object Storage Extension 1.5                                       Supported 16/04/2020 00:00:00 16/04/2022 00:00:00
Cloud Director Object Storage Extension 2.0                                       Supported 15/10/2020 00:00:00 15/10/2022 00:00:00
Cloud Provider Pod 1.5                                                            Supported 13/07/2019 00:00:00 31/12/2020 00:00:00                     30/09/2020 00:00:00 EAP
Dynamic Environment Manager 9.9                                                   Supported 17/09/2019 00:00:00 17/09/2021 00:00:00 17/09/2022 00:00:00                     EDP
Dynamic Environment Manager 9.10                                                  Supported 12/12/2019 00:00:00 12/12/2021 00:00:00 12/12/2022 00:00:00                     EDP
Dynamic Environment Manager 9.11                                                  Supported 17/03/2020 00:00:00 17/03/2022 00:00:00 17/03/2023 00:00:00                     EDP
Dynamic Environment Manager 10 2006                                               Supported 11/08/2020 00:00:00 11/08/2022 00:00:00 11/08/2023 00:00:00                     EDP
Dynamic Environment Manager 10 2009                                               Supported 15/10/2020 00:00:00 15/10/2022 00:00:00 15/10/2023 00:00:00                     EDP
ESXi 6.0                                                                          Supported 12/03/2015 00:00:00 12/03/2020 00:00:00 12/03/2022 00:00:00                     EIP
ESXi 6.5                                                                          Supported 15/11/2016 00:00:00 15/11/2021 00:00:00 15/11/2023 00:00:00                     EIP
ESXi 6.7                                                                          Supported 17/04/2018 00:00:00 15/10/2022 00:00:00 15/11/2023 00:00:00                     EIP    {For this product version, an exception to the End of General Support has been applied., For this product version, an exception to the End of Technical Guidance …
ESXi 7.0                                                                          Supported 02/04/2020 00:00:00 02/04/2025 00:00:00 02/04/2027 00:00:00                     EIP
</SNIPPED>
```

### List all products available on the VMware Product Lifecycle Matrix website that have a status of SUPPORTED

```PowerShell
PS > Get-PLMProduct -Supported | ft

Name                                                                              Status    GADate              EOSDate             EOTGDate            EOADate             Policy Notes
----                                                                              ------    ------              -------             --------            -------             ------ -----
App Volumes 2.14 (ESB)                                                            Supported 28/05/2018 00:00:00 28/05/2020 00:00:00 28/05/2021 00:00:00                     EDP
App Volumes 2.15                                                                  Supported 13/12/2018 00:00:00 13/12/2020 00:00:00 13/12/2021 00:00:00                     EDP
App Volumes 2.16                                                                  Supported 14/03/2019 00:00:00 14/03/2021 00:00:00 14/03/2022 00:00:00                     EDP
App Volumes 2.17                                                                  Supported 02/07/2019 00:00:00 02/07/2021 00:00:00 02/07/2022 00:00:00                     EDP
App Volumes 2.18 (ESB)                                                            Supported 16/09/2019 00:00:00 16/09/2021 00:00:00 16/09/2022 00:00:00                     EDP
App Volumes 4                                                                     Supported 14/01/2020 00:00:00 14/01/2022 00:00:00 14/01/2023 00:00:00                     EDP
App Volumes 4 2006                                                                Supported 09/07/2020 00:00:00 09/07/2022 00:00:00 09/07/2023 00:00:00                     EDP
App Volumes 4 2009                                                                Supported 15/10/2020 00:00:00 15/10/2022 00:00:00 15/10/2023 00:00:00                     EDP
Cloud Director App Launchpad 1.0                                                  Supported 09/04/2020 00:00:00 09/04/2022 00:00:00
Cloud Director App Launchpad 2.0                                                  Supported 15/10/2020 00:00:00 15/10/2022 00:00:00
Cloud Director Object Storage Extension 1.5                                       Supported 16/04/2020 00:00:00 16/04/2022 00:00:00
Cloud Director Object Storage Extension 2.0                                       Supported 15/10/2020 00:00:00 15/10/2022 00:00:00
Cloud Provider Pod 1.5                                                            Supported 13/07/2019 00:00:00 31/12/2020 00:00:00                     30/09/2020 00:00:00 EAP
Dynamic Environment Manager 9.9                                                   Supported 17/09/2019 00:00:00 17/09/2021 00:00:00 17/09/2022 00:00:00                     EDP
Dynamic Environment Manager 9.10                                                  Supported 12/12/2019 00:00:00 12/12/2021 00:00:00 12/12/2022 00:00:00                     EDP
Dynamic Environment Manager 9.11                                                  Supported 17/03/2020 00:00:00 17/03/2022 00:00:00 17/03/2023 00:00:00                     EDP
Dynamic Environment Manager 10 2006                                               Supported 11/08/2020 00:00:00 11/08/2022 00:00:00 11/08/2023 00:00:00                     EDP
Dynamic Environment Manager 10 2009                                               Supported 15/10/2020 00:00:00 15/10/2022 00:00:00 15/10/2023 00:00:00                     EDP
ESXi 6.0                                                                          Supported 12/03/2015 00:00:00 12/03/2020 00:00:00 12/03/2022 00:00:00                     EIP
ESXi 6.5                                                                          Supported 15/11/2016 00:00:00 15/11/2021 00:00:00 15/11/2023 00:00:00                     EIP
ESXi 6.7                                                                          Supported 17/04/2018 00:00:00 15/10/2022 00:00:00 15/11/2023 00:00:00                     EIP    {For this product version, an exception to the End of General Support has been applied., For this product version, an exception to the End of Technical Guidance …
ESXi 7.0                                                                          Supported 02/04/2020 00:00:00 02/04/2025 00:00:00 02/04/2027 00:00:00                     EIP
</SNIPPED>
```

### List all products available on the VMware Product Lifecycle Matrix website that have a status of UNSUPPORTED

```Powershell
PS > Get-PLMProduct -Unsupported | ft

Name                                                      Status      GADate              EOSDate             EOTGDate            EOADate             Policy Notes
----                                                      ------      ------              -------             --------            -------             ------ -----
Workspace ONE UEM Console 1905 (SaaS Only)                Unsupported 30/05/2019 00:00:00 30/11/2020 00:00:00                                         EDP
ACE 1.x                                                   Unsupported 04/08/2005 00:00:00                                         31/12/2011 00:00:00 GSP
ACE 2.x                                                   Unsupported 09/05/2007 00:00:00 31/12/2013 00:00:00                     31/12/2011 00:00:00 GSP
AirWatch Console 9.1                                      Unsupported 26/04/2017 00:00:00 26/10/2018 00:00:00                                         EDP    {For older AirWatch Console end of general support dates, refer to the AirWatch Console End of Genera…
AirWatch Console 9.2                                      Unsupported 21/09/2017 00:00:00 21/03/2019 00:00:00                                         EDP    {For older AirWatch Console end of general support dates, refer to the AirWatch Console End of Genera…
AirWatch Console 9.3                                      Unsupported 14/03/2018 00:00:00 14/09/2019 00:00:00                                         EDP    {For older AirWatch Console end of general support dates, refer to the AirWatch Console End of Genera…
```

### List a specific product by name

```Powershell
PS > Get-PLMProduct -Name 'vSphere Replication 5.1'

Name     : vSphere Replication 5.1
Status   : Unsupported
GADate   : 10/09/2012 00:00:00
EOSDate  : 24/08/2016 00:00:00
EOTGDate : 24/08/2018 00:00:00
EOADate  :
Policy   : EIP
Notes    : {For this product version, an exception to the End of General Support has been applied., For this product version, an exception to the End of Technical Guidance has been applied.}
```

### List products that contain a specific string in the name

```Powershell
PS > Get-PLMProduct -Name '*replication*' | ft

Name                           Status      GADate              EOSDate             EOTGDate            EOADate             Policy Notes
----                           ------      ------              -------             --------            -------             ------ -----
vSphere Replication 6.0        Supported   12/03/2015 00:00:00 12/03/2020 00:00:00 12/03/2022 00:00:00                     EIP
vSphere Replication 6.1        Supported   10/09/2015 00:00:00 12/03/2020 00:00:00 12/03/2022 00:00:00                     EIP
vSphere Replication 6.5        Supported   15/11/2016 00:00:00 15/11/2021 00:00:00 15/11/2023 00:00:00                     EIP    {For this product version, an exception to the End of General Support has been applied., For this product version, an exception to the End of Technical Guidance has been applied.}
vSphere Replication 8.1        Supported   17/04/2018 00:00:00 15/11/2021 00:00:00 15/11/2023 00:00:00                     EIP    {For this product version, an exception to the End of General Support has been applied., For this product version, an exception to the End of Technical Guidance has been applied.}
vSphere Replication 8.2        Supported   09/05/2019 00:00:00 15/11/2021 00:00:00 15/11/2023 00:00:00                     EIP
vSphere Replication 8.3        Supported   02/04/2020 00:00:00 01/04/2023 00:00:00 01/04/2024 00:00:00                     APP
Continuent for Replication 4.0 Unsupported 17/04/2015 00:00:00 17/04/2017 00:00:00                     04/05/2016 00:00:00 EAP
Continuent for Replication 5.0 Unsupported 07/12/2015 00:00:00 07/12/2017 00:00:00                     04/05/2016 00:00:00 EAP
vSphere Replication 5.1        Unsupported 10/09/2012 00:00:00 24/08/2016 00:00:00 24/08/2018 00:00:00                     EIP    {For this product version, an exception to the End of General Support has been applied., For this product version, an exception to the End of Technical Guidance has been applied.}
vSphere Replication 5.5        Unsupported 22/09/2013 00:00:00 22/09/2018 00:00:00 22/09/2020 00:00:00                     EIP
vSphere Replication 5.6        Unsupported 14/04/2014 00:00:00 22/09/2018 00:00:00 22/09/2020 00:00:00                     EIP
vSphere Replication 5.8        Unsupported 09/09/2014 00:00:00 22/09/2018 00:00:00 22/09/2020 00:00:00                     EIP
```

### List all SUPPORTED products that contain a specific string in the name

```Powershell
PS > Get-PLMProduct -Name '*replication*' -Supported | ft

Name                    Status    GADate              EOSDate             EOTGDate            EOADate Policy Notes
----                    ------    ------              -------             --------            ------- ------ -----
vSphere Replication 6.0 Supported 12/03/2015 00:00:00 12/03/2020 00:00:00 12/03/2022 00:00:00         EIP
vSphere Replication 6.1 Supported 10/09/2015 00:00:00 12/03/2020 00:00:00 12/03/2022 00:00:00         EIP
vSphere Replication 6.5 Supported 15/11/2016 00:00:00 15/11/2021 00:00:00 15/11/2023 00:00:00         EIP    {For this product version, an exception to the End of General Support has been applied., For this product version, an exception to the End of Technical Guidance has been applied.}
vSphere Replication 8.1 Supported 17/04/2018 00:00:00 15/11/2021 00:00:00 15/11/2023 00:00:00         EIP    {For this product version, an exception to the End of General Support has been applied., For this product version, an exception to the End of Technical Guidance has been applied.}
vSphere Replication 8.2 Supported 09/05/2019 00:00:00 15/11/2021 00:00:00 15/11/2023 00:00:00         EIP
vSphere Replication 8.3 Supported 02/04/2020 00:00:00 01/04/2023 00:00:00 01/04/2024 00:00:00         APP
```

### List all products where the name begins with a specified string

```Powershell
PS > Get-PLMProduct -Name 'nsx*' | ft

Name                                             Status      GADate              EOSDate             EOTGDate            EOADate Policy Notes
----                                             ------      ------              -------             --------            ------- ------ -----
NSX Advanced Load Balancer 18.2                  Supported   04/03/2019 00:00:00 31/08/2021 00:00:00 31/08/2021 00:00:00         EAP
NSX Advanced Load Balancer 20.1                  Supported   30/07/2020 00:00:00 31/07/2022 00:00:00 31/07/2022 00:00:00         EAP
NSX Defender 9                                   Supported   29/10/2020 00:00:00 31/12/2023 00:00:00 31/12/2024 00:00:00         EAP
NSX Detonator 9                                  Supported   29/10/2020 00:00:00 31/12/2023 00:00:00 31/12/2024 00:00:00         EAP
NSX Firewall 3.1                                 Supported   29/10/2020 00:00:00 30/10/2022 00:00:00 30/10/2023 00:00:00         APP
NSX Firewall with Advanced Threat Prevention 3.1 Supported   29/10/2020 00:00:00 30/10/2022 00:00:00 30/10/2023 00:00:00         APP
NSX for vSphere 6.3                              Supported   02/02/2017 00:00:00 02/02/2020 00:00:00 02/02/2021 00:00:00         APP
NSX for vSphere 6.4                              Supported   16/01/2018 00:00:00 16/01/2022 00:00:00 16/01/2023 00:00:00         APP
NSX-T Data Center 2 Major Release Series         Supported   07/09/2017 00:00:00 19/09/2021 00:00:00 19/09/2022 00:00:00         APP
NSX-T Data Center 2.4                            Supported   28/02/2019 00:00:00 07/09/2020 00:00:00 07/09/2021 00:00:00         APP
NSX-T Data Center 2.5                            Supported   19/09/2019 00:00:00 19/09/2021 00:00:00 19/09/2022 00:00:00         APP
NSX-T Data Center 3 Major Release Series         Supported   07/04/2020 00:00:00 07/04/2023 00:00:00 07/04/2024 00:00:00         APP
NSX-T Data Center 3.0                            Supported   07/04/2020 00:00:00 07/04/2022 00:00:00 07/04/2023 00:00:00         APP
NSX-T Data Center 3.1                            Supported   30/10/2020 00:00:00 30/10/2022 00:00:00 30/10/2023 00:00:00         APP
NSX for Multi-Hypervisor 4.1                     Unsupported 15/10/2013 00:00:00 15/10/2015 00:00:00                             EAP
NSX for Multi-Hypervisor 4.2                     Unsupported 19/08/2014 00:00:00 15/10/2016 00:00:00                             EAP
NSX for vSphere 6.0                              Unsupported 15/10/2013 00:00:00 15/10/2015 00:00:00                             EAP
NSX for vSphere 6.1                              Unsupported 11/09/2014 00:00:00 15/01/2017 00:00:00                             EAP
NSX for vSphere 6.2                              Unsupported 20/08/2015 00:00:00 20/08/2018 00:00:00 20/08/2019 00:00:00         APP
NSX-T 1.0                                        Unsupported 03/05/2016 00:00:00 03/05/2018 00:00:00                             EAP
NSX-T 1.1                                        Unsupported 02/02/2017 00:00:00 07/09/2018 00:00:00                             EAP
NSX-T 2.0                                        Unsupported 07/09/2017 00:00:00 07/09/2019 00:00:00                             EAP
NSX-T 2.1                                        Unsupported 21/12/2017 00:00:00 07/09/2019 00:00:00                             EAP
NSX-T Data Center 2.2                            Unsupported 05/06/2018 00:00:00 18/09/2019 00:00:00                             EAP
NSX-T Data Center 2.3                            Unsupported 18/09/2018 00:00:00 28/02/2020 00:00:00                             EAP
```

### Search all products and display any which has a date within the next 8 days from the current date

```Powershell
PS > Get-PLMProduct | Get-PLMInterestingEvent -Days 8 | ft

Name                         Status    GADate              EOSDate             EOTGDate            EOADate Policy Notes
----                         ------    ------              -------             --------            ------- ------ -----
App Volumes 2.15             Supported 13/12/2018 00:00:00 13/12/2020 00:00:00 13/12/2021 00:00:00         EDP
User Environment Manager 9.6 Supported 13/12/2018 00:00:00 13/12/2020 00:00:00 13/12/2021 00:00:00         EDP
```

### Search all products and display any which has a date from the previous 8 days to the current date

```Powershell
PS > Get-PLMProduct | Get-PLMInterestingEvent -Days -8 | ft

Name                                       Status      GADate              EOSDate             EOTGDate            EOADate Policy Notes
----                                       ------      ------              -------             --------            ------- ------ -----
Horizon 7.5 ESB                            Supported   29/05/2018 00:00:00 30/11/2020 00:00:00 22/03/2023 00:00:00         EDP
Workspace ONE UEM Console 1905 (SaaS Only) Unsupported 30/05/2019 00:00:00 30/11/2020 00:00:00                             EDP
```

### Search all products and display any which has a date between the current date and the future date specified

```Powershell
PS > (get-date).date

Tuesday, 8 December 2020 00:00:00

PS > Get-PLMProduct | Get-PLMInterestingEvent -date $(Get-date -date "26/1/2021") | ft

Name                         Status    GADate              EOSDate             EOTGDate            EOADate             Policy Notes
----                         ------    ------              -------             --------            -------             ------ -----
App Volumes 2.15             Supported 13/12/2018 00:00:00 13/12/2020 00:00:00 13/12/2021 00:00:00                     EDP
Cloud Provider Pod 1.5       Supported 13/07/2019 00:00:00 31/12/2020 00:00:00                     30/09/2020 00:00:00 EAP
Fusion 11                    Supported 24/09/2018 00:00:00 19/12/2020 00:00:00                                         PDP
Smart Assurance 9.5          Supported 26/09/2017 00:00:00 20/12/2020 00:00:00                     03/09/2020 00:00:00 EAP
Smart Assurance 9.6          Supported 21/01/2019 00:00:00 21/01/2021 00:00:00                     03/09/2020 00:00:00 EAP
Smart Experience 3.1         Supported 24/04/2017 00:00:00 31/12/2020 00:00:00                                         EAP    {For this product version, an exception to the End of General Support has been applied.}
User Environment Manager 9.3 Supported 04/01/2018 00:00:00 04/01/2020 00:00:00 04/01/2021 00:00:00                     EDP
User Environment Manager 9.6 Supported 13/12/2018 00:00:00 13/12/2020 00:00:00 13/12/2021 00:00:00                     EDP
VMware Enterprise PKS 1.7    Supported 16/04/2020 00:00:00 16/01/2021 00:00:00                                         N-2    {The listed lifecycle policy is N-2, but their dates align with Pivotals N-2 Lifecycle Policy of 9 months support.}
vRealize Automation 7.4, 7.5 Supported 20/09/2018 00:00:00 17/12/2020 00:00:00                                         EAP
vRealize Business for Cloud… Supported 20/09/2018 00:00:00 17/12/2020 00:00:00                                         EAP
vRealize Network Insight 4.0 Supported 20/12/2018 00:00:00 20/12/2020 00:00:00                                         EAP
vRealize Network Insight 4.1 Supported 11/04/2019 00:00:00 20/12/2020 00:00:00                                         EAP
vRealize Network Insight 4.2 Supported 18/07/2019 00:00:00 20/12/2020 00:00:00                                         EAP
vRealize Orchestrator 7.4, … Supported 19/09/2018 00:00:00 17/12/2020 00:00:00                                         EAP    {For this product version, an exception to the End of General Support has been applied.}
vRealize Suite Lifecycle Ma… Supported 10/07/2018 00:00:00 17/12/2020 00:00:00                                         EAP    {For this product version, an exception to the End of General Support has been applied.}
Workstation 15 Pro and Work… Supported 24/09/2018 00:00:00 19/12/2020 00:00:00                                         PDP
```

### Search all products and display any which has a date between the current date and the historical date specified

```Powershell
PS > (get-date).date

Tuesday, 8 December 2020 00:00:00

PS > Get-PLMProduct | Get-PLMInterestingEvent -date $(Get-date -date "26/11/2020") | ft

Name                                       Status      GADate              EOSDate             EOTGDate            EOADate Policy Notes
----                                       ------      ------              -------             --------            ------- ------ -----
Horizon 7.5 ESB                            Supported   29/05/2018 00:00:00 30/11/2020 00:00:00 22/03/2023 00:00:00         EDP
Workspace ONE UEM Console 1905 (SaaS Only) Unsupported 30/05/2019 00:00:00 30/11/2020 00:00:00                             EDP
```
