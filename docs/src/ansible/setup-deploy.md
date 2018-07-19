## Deploying a Playbook

Deploying a playbook to the Ansible managed infrastructure is done
with the `ansible-playbook` command.  An example invocation to update
the buildmaster is shown below:

```shell
$ ansible-playbook -DK build.yml --limit vm1.a-lej-de.m.voidlinux.org
```

Breaking down the above command line:

  * `-D`: Provide a diff of the changes that are made.
  * `-K`: Prompt for the sudo password
  * `build.yml`: The playbook that we want to run
  * `--limit`: Restrict running of this playbook to the following
    host(s)
  * `vm1.a-lej-de.m.voidlinux.org`: The hostname of the specific
    server that runs the buildmaster.

Here's what a full run of this command looks like:

```shell
$ ansible-playbook -DK build.yml --limit vm1.a-lej-de.m.voidlinux.org
SUDO password: 

PLAY [buildmaster] ***************************************************************************

TASK [Gathering Facts] ***********************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Configure hosts] *************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Configure hostname] **********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Install iptables] ************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Install iptables-reload command] *********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Configure dhcpcd] ************************************************************
--- before: /etc/dhcpcd.conf
+++ after: /home/maldridge/.ansible/tmp/ansible-local-3289rle0c9_z/tmp_37j0_hr/dhcpcd.conf.j2
@@ -10,7 +10,7 @@
 
 	noipv6
 interface eth1
-	nopipv4
+	noipv4
 
 	static ip6_address=2a01:4f8:212:34cc::01d:b/64
 	static domain_name_servers=2a01:4f8:0:a0a1::add:1010

changed: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Enable dhcpcd] ***************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Enable wpa_supplicant hook] **************************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Add dhcpcd iptables hook] ****************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Enable dhcpcd iptables hook] *************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Make iptables.d] *************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Configure base rules for IPv4 firewall] **************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Make ip6tables.d] ************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [network : Configure base rules for IPv6 firewall] **************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [acmetool : Install acmetool] ***********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [acmetool : Create acmetool data root] **************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [acmetool : Create acmetool directories] ************************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=accounts)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=certs)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=conf)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=desired)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=keys)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=live)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=tmp)

TASK [acmetool : Install acmetool responses file] ********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [acmetool : Check for quickstart flag] **************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [acmetool : Run quickstart] *************************************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [acmetool : Install acmetool configuration] *********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [acmetool : Configure wanted certificates] **********************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=build.voidlinux.eu)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=sources.voidlinux.eu)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=repo.voidlinux.eu)

TASK [acmetool : Ensure cron.d exists] *******************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [acmetool : Install renewal crontab] ****************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [acmetool : Install acmetool firewall rules] ********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install nginx] *****************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Configure nginx] ***************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install dhparam.pem] ***********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Create the webroot] ************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Create sites-available] ********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Create sites-enabled] **********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Enable nginx] ******************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Configure nginx firewall rules] ************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Configure nginx firewall rules] ************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [crond : Install cronie] ****************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [crond : Enable cronie] *****************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Create the void-repo group] **********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install the buildmaster firewall rules] **********************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install the buildmaster firewall rules (v6)] *****************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install virtualenv & deps] ***********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Create the BuildBot Master user] *****************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Create the BuildMaster Root Directory] ***********************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install Buildbot] ********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Make Buildbot More Terse] ************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Create BuildMaster Subdirectories] ***************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=scripts)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=public_html)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=templates)

TASK [buildmaster : Copy un-inheritable Buildbot Assets] *************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=bg_gradient.jpg)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=default.css)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=favicon.ico)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=robots.txt)

TASK [buildmaster : Copy Buildbot Bootstrap Database] ****************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install GitHub Webhook Password] *****************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Configure BuildMaster] ***************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install Static Scripts] **************************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=__init__.py)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=ShellCommandChangeList.py)

TASK [buildmaster : Install Buildbot Master Configuration] ***********************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : include_vars] ************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : include_vars] ************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Configure BuildSlave References] *****************************************
--- before: //home/void-buildmaster//buildmaster/scripts/user_settings.py
+++ after: /home/maldridge/.ansible/tmp/ansible-local-3289rle0c9_z/tmpuaj4n11l/user_settings.py.j2
@@ -9,7 +9,7 @@
         'BootstrapArgs': '-N',
         'slave_name': 'x86_64_void',
         'slave_pass': 'REDACTED',
-        'admin': 'xtraeme'
+        'admin': 'gottox'
     },
     {
         'name': 'i686-primary',
@@ -21,7 +21,7 @@
         'BootstrapArgs': '-N',
         'slave_name': 'i686_void',
         'slave_pass': 'REDACTED',
-        'admin': 'xtraeme'
+        'admin': 'gottox'
     },
     {
         'name': 'armv6l-primary',
@@ -33,7 +33,7 @@
         'BootstrapArgs': '-N',
         'slave_name': 'cross-rpi_void',
         'slave_pass': 'REDACTED',
-        'admin': 'xtraeme'
+        'admin': 'gottox'
     },
     {
         'name': 'armv7l-primary',
@@ -45,7 +45,7 @@
         'BootstrapArgs': '-N',
         'slave_name': 'cross-armv7l_void',
         'slave_pass': 'REDACTED',
-        'admin': 'xtraeme'
+        'admin': 'gottox'
     },
     {
         'name': 'x86_64-musl-primary',

changed: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install BuildBot Service (1/2)] ******************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install BuildBot Service (2/2)] ******************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Enable BuildBot Service] *************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Configure webserver] *****************************************************

TASK [nginx : Create folder for external nginx locations] ************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install site descriptor] *******************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Enable site] *******************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install firewall rules for resolvers] ******************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install firewall v6 rules for resolvers] ***************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install root location block] *********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Create the Signing User] *************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Create .ssh for void-repomaster] *****************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install Signing Key] *****************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Create bin/ directory for void-repomaster] *******************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install Signing and Repo-Management Scripts] *****************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=xbps-sign-repos)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=xbps-clean-repos)

TASK [buildmaster : Install Signing Cronjob] *************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install rsync] ***********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildmaster : Install Sync Keys] *******************************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=None)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=None)
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [root-mirror-shim : Create Repo Directory] **********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [root-mirror-shim : Create xlocate group] ***********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [root-mirror-shim : Create Static Mirror Directories] ***********************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=distfiles)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=live)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=logos)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=static)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=current)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=xlocate)

TASK [root-mirror-shim : Mount the package filesystem into the mirror] ***********************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [void-updates : Install void-updates] ***************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [void-updates : Create the voidupdates user] ********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [void-updates : Install Update Check Cron Job] ******************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [void-updates : Link Results] ***********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [mirror-base : Create the reposync group] ***********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [mirror-base : Create the reposync user] ************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [rsyncd : Install rsync] ****************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [rsyncd : Install rsync firewall rules] *************************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=iptables.d)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=ip6tables.d)

TASK [rsyncd : Create rsyncd.conf.d] *********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [rsyncd : Template rsyncd.conf] *********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [rsyncd : Enable rsyncd] ****************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Install Prerequisites] ***************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Create the mirror dataroot directory] ************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Configure firewall rules] ************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Configure webserver] *****************************************************

TASK [nginx : Create folder for external nginx locations] ************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install site descriptor] *******************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Enable site] *******************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install firewall rules for resolvers] ******************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install firewall v6 rules for resolvers] ***************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Include rsyncd user secrets] *********************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Configure rsyncd] ********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Configure rsyncd secrets] ************************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Install sync service secret] *********************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Install mirror sync service (1/4)] ***************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Install mirror sync service (2/4)] ***************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Install mirror sync service (3/4)] ***************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [live-mirror : Install mirror sync service (4/4)] ***************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [sources_site : Create sources link] ****************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [sources_site : Configure webserver] ****************************************************

TASK [nginx : Create folder for external nginx locations] ************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install site descriptor] *******************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Enable site] *******************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install firewall rules for resolvers] ******************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [nginx : Install firewall v6 rules for resolvers] ***************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

RUNNING HANDLER [network : dhcpcd] ***********************************************************
changed: [vm1.a-lej-de.m.voidlinux.org]

PLAY [buildslave] ****************************************************************************

TASK [Gathering Facts] ***********************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildslave : Install BuildBot Slave and Dependencies] **********************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildslave : Create Buildslave user (void-buildslave)] *********************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildslave : Create Buildsync user (void-buildsync)] ***********************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildslave : Create void-buildsync .ssh] ***********************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildslave : Install sync key] *********************************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildslave : Create Builder Directories] ***********************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=x86_64)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=i686)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv6l)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv7l)

TASK [buildslave : Enforce permissions on hostdir] *******************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=DE-1)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=DE-1)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=DE-1)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=DE-1)

TASK [buildslave : include_vars] *************************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildslave : Configure buildbot-slave] *************************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=x86_64)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=i686)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv6l)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv7l)

TASK [buildslave : Create buildbot-slave info directories] ***********************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=x86_64)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=i686)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv6l)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv7l)

TASK [buildslave : Configure buildbot host description] **************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=x86_64)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=i686)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv6l)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv7l)

TASK [buildslave : Configure buildbot admin description] *************************************
--- before: //home/void-buildslave//void-builder-x86_64/info/admin
+++ after: /home/maldridge/.ansible/tmp/ansible-local-3289rle0c9_z/tmpq5hidygh/admin.j2
@@ -1 +1 @@
-Juan RP <xtraeme@voidlinux.eu>
+Enno Boland <gottox@voidlinux.eu>

changed: [vm1.a-lej-de.m.voidlinux.org] => (item=x86_64)
--- before: //home/void-buildslave//void-builder-i686/info/admin
+++ after: /home/maldridge/.ansible/tmp/ansible-local-3289rle0c9_z/tmpny2jz3zs/admin.j2
@@ -1 +1 @@
-Juan RP <xtraeme@voidlinux.eu>
+Enno Boland <gottox@voidlinux.eu>

changed: [vm1.a-lej-de.m.voidlinux.org] => (item=i686)
--- before: //home/void-buildslave//void-builder-armv6l/info/admin
+++ after: /home/maldridge/.ansible/tmp/ansible-local-3289rle0c9_z/tmpb6hfxdu2/admin.j2
@@ -1 +1 @@
-Juan RP <xtraeme@voidlinux.eu>
+Enno Boland <gottox@voidlinux.eu>

changed: [vm1.a-lej-de.m.voidlinux.org] => (item=armv6l)
--- before: //home/void-buildslave//void-builder-armv7l/info/admin
+++ after: /home/maldridge/.ansible/tmp/ansible-local-3289rle0c9_z/tmpaw5ppogt/admin.j2
@@ -1 +1 @@
-Juan RP <xtraeme@voidlinux.eu>
+Enno Boland <gottox@voidlinux.eu>

changed: [vm1.a-lej-de.m.voidlinux.org] => (item=armv7l)

TASK [buildslave : Configure xbps-src] *******************************************************
ok: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildslave : Configure local build mirror] *********************************************
skipping: [vm1.a-lej-de.m.voidlinux.org]

TASK [buildslave : Create Service Directories] ***********************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=x86_64)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=i686)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv6l)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv7l)

TASK [buildslave : Configure Runit] **********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=x86_64)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=i686)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv6l)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv7l)

TASK [buildslave : Enable BuildSlave] ********************************************************
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=x86_64)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=i686)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv6l)
ok: [vm1.a-lej-de.m.voidlinux.org] => (item=armv7l)

PLAY RECAP ***********************************************************************************
vm1.a-lej-de.m.voidlinux.org : ok=115  changed=4    unreachable=0    failed=0
```

The end of the play will always have a "Play Recap" which will show
what hosts finished in what state.  Always check and if necessary
re-apply for hosts that are in failed state.

Applying Ansible playbooks requires unrestricted root or access to a
service user on each node.  Members of netauth/dante can run playbooks
manually.
