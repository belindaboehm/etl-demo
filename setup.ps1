$rg = get-AzResourceGroup

# deploy ADF
New-AzResourceGroupDeployment `
  -Name adfDeployment `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile arm/template-adf.json `
  -TemplateParameterFile arm/parameters-adf.json

# deploy SQL
write-host ""
$sqlPassword = ""
$complexPassword = 0

while ($complexPassword -ne 1)
{
    $SqlPassword = Read-Host "Enter a password to use for the sqlUser login.
    `The password must meet complexity requirements:
    ` - Minimum 8 characters. 
    ` - At least one upper case English letter [A-Z]
    ` - At least one lower case English letter [a-z]
    ` - At least one digit [0-9]
    ` - At least one special character (!,@,#,%,^,&,$)
    ` "

    if(($SqlPassword -cmatch '[a-z]') -and ($SqlPassword -cmatch '[A-Z]') -and ($SqlPassword -match '\d') -and ($SqlPassword.length -ge 8) -and ($SqlPassword -match '!|@|#|%|\^|&|\$'))
    {
        $complexPassword = 1
	    Write-Output "Password $SqlPassword accepted. Make sure you remember this!"
    }
    else
    {
        Write-Output "$SqlPassword does not meet the complexity requirements."
    }
}

New-AzResourceGroupDeployment `
    -Name sqlDeployment `
    -ResourceGroupName $rg.ResourceGroupName `
    -TemplateFile arm/template-sql.json `
    -TemplateParameterFile arm/parameters-sql.json `
    -administratorLoginPassword $sqlPassword