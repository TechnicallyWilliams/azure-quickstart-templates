param(
    [Parameter(Mandatory = $true)][string]$APP_VERSION)

$ErrorActionPreference = "Stop"

$APP_NAME = "helloworld"
$ENV = "dev"

$acr = az resource list --tag resource-id=demo-container-registry environment=$ENV | ConvertFrom-Json

if (!$acr) {
    throw "Unable to find eligible container registry!"
}

$AcrName = $acr.name

az acr login --name $AcrName
if ($LastExitCode -ne 0) {
    throw "An error has occured. Unable to login to acr $AcrName."
}

$shouldBuild = $true
$tags = az acr repository show-tags --name $AcrName --repository $APP_NAME | ConvertFrom-Json
if ($tags) {
    if ($tags.Contains($APP_VERSION)) {
        $shouldBuild = $false
    }
}

if ($shouldBuild -eq $true) {

    # Import public mcr image into deployed ACR resource
    $imageName = "$APP_NAME`:$APP_VERSION"
    Write-Host "Image name: $imageName"
    az acr import -n $AcrName --source mcr.microsoft.com/azuredocs/containerapps-helloworld -t $imageName

    if ($LastExitCode -ne 0) {
        throw "An error has occured. Unable to build image."
    }
}
