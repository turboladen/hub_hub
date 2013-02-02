cd /usr/src && \
sudo wget http://dl.fedoraproject.org/pub/epel/5Server/x86_64/epel-release-5-4.noarch.rpm && \
sudo rpm -ivh epel-release-5-4.noarch.rpm && \
sudo yum -y install python26 python26-PyYAML python26-paramiko python26-jinja2 python-simplejson
