<#
    Antes de rodar esse script altere atribução da variável $Domain
    Verifique o caminho e nome so arquivo base .csv de padrão está:
        c:\NovosUsuarios\NovosUsarios.csv
#>

Import-Module ActiveDirectory

#alterar para o nome do seu domínio
$Domain = "info.local"

$ADUsers = Import-csv C:\powershell_\NovosUsuarios.csv  -Delimiter(';')

Write-Output $ADUsers

foreach ($User in $ADUsers)
{	
	$Username 	= $User.login
	$Password 	= $User.senha
	$Firstname 	= $User.primeiro_nome
	$Lastname 	= $User.sobre_nome
	$OU 		= $User.ou
    $email      = $User.email
    $Expires = $User.fimdaturma


	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 Write-Warning "Usuário $Username já existe no Active Directory."
	}
	else
	{

		New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@$Domain" `
            -Name $Firstname `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Firstname $Lastname" `
            -Path $OU `
            -EmailAddress $email `
            -AccountExpirationDate $Expires `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $False
            
	}
}
