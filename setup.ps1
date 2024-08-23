$rg = get-AzResourceGroup

New-AzResourceGroupDeployment `
  -Name adfDeployment `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile arm/parameters-sql.json `
  -TemplateParameterFile arm/template-sql.json