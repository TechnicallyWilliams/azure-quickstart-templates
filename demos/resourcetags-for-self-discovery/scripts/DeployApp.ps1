param(
    [Parameter(Mandatory = $true)][string]$APP_VERSION)

$containerName = "demo-container"
$appName = "helloworld"
$regIdentity = "/subscriptions/<subscriptionId>/resourcegroups/tags-for-self-discovery/providers/Microsoft.ManagedIdentity/userAssignedIdentities/demouseridentity"

$resourceGroup = az group list --tag solution-id=self-discovery-demo
$rgName = $resourceGroup.name

$acr = az resource list --tag resource-id=demo-container-registry | ConvertFrom-Json
$acrName = $acr.name
if (!$acr) {
    throw "Unable to find eligible container registry!"
}

$appEnvironment = az resource list --tag resource-id=demo-containerappenvironment | ConvertFrom-Json
$appEnvironmentName = $appEnvironment.name
if (!$appEnvironment) {
    throw "Unable to find eligible container app environment!"
}

$imageName = "$acrName`.azurecr.io/$appName`:$APP_VERSION"
printf "Image name: %s\n" $imageName
az containerapp create -n $containerName -g $rgName `
    --image $imageName --environment $appEnvironmentName `
    --cpu 0.5 --memory 1.0Gi `
    --ingress external `
    --registry-identity $regIdentity `
    --target-port 80 `
    --registry-server "$acrName.azurecr.io" `
    --user-assigned $regIdentity 

if ($LastExitCode -ne 0) {
    throw "An error has occured. Unable to create container apps."
}
