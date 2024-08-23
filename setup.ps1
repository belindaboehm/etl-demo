$rg = get-AzResourceGroup

# deploy ADF
New-AzResourceGroupDeployment `
  -Name adfDeployment `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile arm/template-adf.json `
  -TemplateParameterFile arm/parameters-adf.json

# deploy SQL
New-AzResourceGroupDeployment `
    -Name sqlDeployment `
    -ResourceGroupName $rg.ResourceGroupName `
    -TemplateFile arm/template-sql.json `
    -TemplateParameterFile arm/parameters-sql.json