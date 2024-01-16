#!groovy

import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.Jenkins

println "--> enabling CSRF protection"

def instance = Jenkins.getInstanceOrNull()
instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
instance.save()