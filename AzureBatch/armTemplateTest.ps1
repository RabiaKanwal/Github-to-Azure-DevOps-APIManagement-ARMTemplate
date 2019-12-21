param (
	[Parameter(Mandatory=$true)]
	[string]$TemplatePath 
)

$templateARM = Get-Content $TemplatePath -Raw -ErrorAction SilentlyContinue
$template = ConvertFrom-Json -InputObject $templateARM -ErrorAction SilentlyContinue
$templateElements = $template.psobject.Properties.name.tolower()

Describe 'ARM Template Validation' {
	Context 'File Validation' {
		It 'Template ARM File Exists' {
			Test-Path $TemplatePath -Include '*.json' | Should Be $true
		}

		It 'Is a valid JSON file' {
			$templateARM | ConvertFrom-Json -ErrorAction SilentlyContinue | Should Not Be $Null
	  }
  }
    Context 'Template Content Validation' {
      It "Contains all required elements" {
          $Elements = '$schema',
                      'contentVersion',
                      'outputs',
                      'parameters',
                      'resources'                                
            $templateProperties = $template | Get-Member -MemberType NoteProperty | % Name
            $templateProperties | Should Be $Elements
        }
        It "Creates the expected resources" {
            $Elements = 'Microsoft.Storage/storageAccounts'
            $templateResources = $template.Resources.type
            $templateResources | Should Be $Elements
        }
  
    }
}
