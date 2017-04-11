
# enregistrement de la VM aupres de Red Hat si besoin
# subscription-manager register --auto-attach

# The easiest way to install Ansible is by adding a third-party repository named EPEL (Extra Packages for Enterprise Linux), which is maintained over at http://fedoraproject.org/wiki/EPEL. You can easily add the repo by running the following command:
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Installation de Ansible
yum -y install ansible

# check de la version d Ansible
ansible --version
