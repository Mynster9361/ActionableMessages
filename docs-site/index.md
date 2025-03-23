---
layout: default
title: ActionableMessages
---

# ActionableMessages PowerShell Module

A PowerShell module for creating Microsoft Actionable Messages.

## Installation

```powershell
Install-Module -Name ActionableMessages -Scope CurrentUser
```

## Quick Start

```powershell
$card = New-ActionableMessage -ThemeColor "#0078D7"
Add-ActionTextBlock -InputObject $card -Text "Hello, World!"
$jsonCard = ConvertTo-Json $card -Depth 10
```

## Documentation

* [Command Reference](reference/index.md)
* [Examples](reference/examples.md)
* [GitHub Repository](https://github.com/Mynster9361/ActionableMessages)