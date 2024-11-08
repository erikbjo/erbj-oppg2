#!/bin/sh
# This script exports the deliverable from the repository
# A .zip-file with the following name, files and folders: Name the zip file with the ntnu username and oppg2,
# such as: erbj-oppg2.zip In the zip file there must be a folder with the same name as the zip file: ntnuusername-oppg2
# Note: removing the .git folder, see https://github.com/erikbjo/erbj-oppg2 for git history

OWN_USERNAME=erbj
OPPGAVE=oppg2
FOLDER=$OWN_USERNAME-$OPPGAVE

# copy files
cp -r . $FOLDER

# remove files
rm -rf $FOLDER/.git
rm -rf $FOLDER/.idea

rm -rf $FOLDER/deployments/.terraform
rm -rf $FOLDER/deployments/*.tfvars
rm -rf $FOLDER/deployments/.terraform.lock.hcl

rm -rf $FOLDER/global/.terraform
rm -rf $FOLDER/global/terraform.tfstate
rm -rf $FOLDER/global/terraform.tfstate.backup
rm -rf $FOLDER/global/*.tfvars
rm -rf $FOLDER/global/.terraform.lock.hcl

# zappa
zip -r $FOLDER.zip $FOLDER

# clean up
rm -rf $FOLDER