#!groovy

import jenkins.model.*
import hudson.util.*;
import jenkins.install.*;

def instance = Jenkins.getInstanceOrNull()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)