$rg = get-AzResourceGroup

New-AzResourceGroupDeployment `
  -Name adfDeployment `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile arm/parameters-adf.json `
  -TemplateParameterFilearm/template-adf.json