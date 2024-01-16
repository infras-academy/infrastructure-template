#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstanceOrNull()

println "--> creating local user 'admin'"

def hudsonRealm = new HudsonPrivateSecurityRealm(false, false, null)


//Todo: load password from vault
//Todo: change root password after this
hudsonRealm.createAccount('mc','mc')
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()