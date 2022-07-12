param location string = resourceGroup().location
param k8sVersion string = '1.22.6'
param acrName string = 'acrMSReactor'
param aksName string = 'aksClusterMSReactor'

resource acrResource 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' ={
  location:location
  name:acrName
  sku:{ 
    name: 'Basic' 
  }
  
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }

  sku: {
    name: 'Basic'
    tier: 'Free'
  }
  
  properties: {
    kubernetesVersion: k8sVersion
    dnsPrefix: aksName
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        enableAutoScaling: true
        minCount: 1
        maxCount: 5
        vmSize: 'Standard_B4ms'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    addonProfiles:{
      azurepolicy: {
        enabled: true
      } 
    }
  }
}
