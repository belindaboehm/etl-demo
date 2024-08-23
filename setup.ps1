$rg = get-AzResourceGroup

### generate random suffix
[string]$suffix =  -join ((48..57) + (97..122) | Get-Random -Count 7 | % {[char]$_})
Write-Host "Your randomly-generated suffix for Azure resources is $suffix"
Write-Host ""

#### ADF
write-host "deploying data factory resource..."
$adfName = 'adf-demo-'$suffix
New-AzResourceGroupDeployment `
  -Name adfDeployment `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile arm/template-adf.json `
  -TemplateParameterFile arm/parameters-adf.json `
  -name $adfName

#### SQL server + database
write-host "deploying sql server + database resources..."
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

$sqlName = 'sql-demo-'$suffix
New-AzResourceGroupDeployment `
    -Name sqlDeployment `
    -ResourceGroupName $rg.ResourceGroupName `
    -TemplateFile arm/template-sql.json `
    -TemplateParameterFile arm/parameters-sql.json `
    -administratorLoginPassword $sqlPassword
    -Name $sqlName


#### Storage account
write-host "deploying storage account resources..."

New-AzResourceGroupDeployment `
    -Name adlsDeployment `
    -ResourceGroupName $rg.ResourceGroupName `
    -TemplateFile arm/template-adls.json `
    -TemplateParameterFile arm/parameters-adls.json `


# Upload files
# write-host "Loading data..."
# $storageAccount = Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName -Name $dataLakeAccountName
# $storageContext = $storageAccount.Context
# Get-ChildItem "./data/*.csv" -File | Foreach-Object {
#     write-host ""
#     $file = $_.Name
#     Write-Host $file
#     $blobPath = "$file"
#     Set-AzStorageBlobContent -File $_.FullName -Container "files" -Blob $blobPath -Context $storageContext
# }