# EX294 RED HAT CERTIFIED ADVANCED SYSTEM ADMINISTRATOR IN ANSIBLE

&nbsp;

&nbsp;

&nbsp;

&nbsp;

**I. CORE COMPONENTS OF ANSIBLE**  
    [1. Inventories](#1-inventories)  
    2. Modules  
    3. Variables  
    4. Facts  
    5. Loops  
    6. Conditional tasks  
    7. Plays  
    8. Handling task failure  
    9. Playbooks  
    10. Configuration files  
    11. Roles  
    [12. Use provided documentation to look up specific information about Ansible modules and commands](#12-use-provided-documentation-to-look-up-specific-information-about-ansible-modules-and-commands)  
&nbsp;

**II. CONFIGURE ANSIBLE**  
    [13. Create and modify ansible.cfg](#13-create-and-modify-ansiblecfg)  
    14. Modify ansible-navigator.yml  
    [15. Create a static host inventory file](#15-create-a-static-host-inventory-file)  
    [16. Create and use static inventories to define groups of hosts](#16-create-and-use-static-inventories-to-define-groups-of-hosts)  
&nbsp;

**III. CONFIGURE ANSIBLE MANAGED NODES**  
    17. Create and distribute SSH keys to managed nodes  
    18. Configure privilege escalation on managed nodes  
    19. Deploy files to managed nodes  
&nbsp;

**IV. RUN PLAYBOOKS**  
    20. Know how to run playbooks with ansible-navigator and ansible-playbook  
    21. Use ansible-navigator to find new modules in available Ansible Content Collections and use them  
    22. Use ansible-navigator to create inventories and configure the Ansible environment  
&nbsp;

**V. BASIC SOURCE CONTROL OPERATIONS USING GIT**  
    23. Clone a Git repository  
    24. Add files to a Git repository  
&nbsp;

**VI. VISUAL STUDIO CODE**  
    25. Create playbooks and push them to a Git repository  
    26. Configure ansible-navigator  
    27. Run playbooks using an Ansible development container  
&nbsp;

**VII. CREATE ANSIBLE PLAYS AND PLAYBOOKS**  
    28. Know how to work with commonly used Ansible modules  
    29. Use variables to retrieve the results of running a command  
    30. Use conditionals to control play execution  
    31. Configure error handling  
    32. Create playbooks to configure systems to a specified state  
&nbsp;

**VIII. ROLES AND ANSIBLE CONTENT COLLECTIONS**
    33. Create and work with roles  
    34. Install roles and use them in playbooks  
    35. Install Content Collections and use them in playbooks  
    36. Obtain a set of related roles, supplementary modules, and other content from content collections, and use them in a playbook  
&nbsp;

**IX. AUTOMATE STANDARD RHCSA TASKS USING ANSIBLE MODULES**  
    37. Software packages and repositories  
    38. Services  
    39. Firewall rules  
    40. File systems  
    41. Storage devices  
    42. File content  
    43. Archiving  
    44. Task scheduling  
    45. Security  
    46. Users and groups  
&nbsp;

**X. MANAGE CONTENT**  
    47. Create and use templates to create customized configuration files  
    48. Use Ansible Vault in playbooks to protect sensitive data  
&nbsp;

**Appendixes**  
    [a. Configuration Management](#a-configuration-management)  
    [b. Installing Ansible](#b-installing-ansible)  
    [c. Using ad hoc commands](#c-using-ad-hoc-commands)  



&nbsp;

&nbsp;

&nbsp;

&nbsp;

---

## I. CORE COMPONENTS OF ANSIBLE

---




&nbsp;

### 1. Inventories

- **inventory**: defines the managed nodes you automate and the variables associated with those hosts. You can also specify groups. Groups allow you to reference multiple associated hosts to target for your automation or to define variables in bulk. Once you define your inventory, you use patterns to select the hosts or groups you want Ansible to run against.  

- **static inventory**: list hosts, hosts groups, and host variables (not recommended)  

- **default static inventory** :  `/etc/ansible/hosts`  

- **implicit hosts**: `localhost`  

- **implicit groups**: `all`, `ungrouped`  

- **implicit variable**: `hostvars`  
 
- **groups**: set of hosts which share some criteria, like:  
    + function: web, db, ...  
    + geography: europe, spain,...  
    + staging: test, development, production,...  

- parameter **`-i`** and command **`ansible-inventory`** to show hosts, groups and variables  

    ```
    # to use all o some hosts from inventory "file"

    ansible -i file  all  --list-hosts    

    ansible -i file  ungrouped  --list-hosts
    
    ansible -i file  <pattern>  --list-hosts
    ```

    ```
    # to show hosts and variables defined for the hosts & groups

    ansible-inventory  -i file  --list
    
    ansible-inventory  -i file  --graph
    ```

- **dynamic inventory**: script to discover hosts supporting `--list` and `--host` args,  

    ```
    chmod   +x listingdyn.py
    
    ansible -i listingdyn.py  all  --list-hosts
    ```

- set a inventory directory to use **multiple inventory files**, static and / or dynamic, with:  `-i dir`  




&nbsp;

### 2. Modules  




&nbsp;

### 3. Variables  




&nbsp;

### 4. Facts  




&nbsp;

### 5. Loops  




&nbsp;

### 6. Conditional tasks  




&nbsp;

### 7. Plays  




&nbsp;

### 8. Handling task failure  




&nbsp;

### 9. Playbooks  




&nbsp;

### 10. Configuration files  




&nbsp;

### 11. Roles  




&nbsp;

### 12. Use provided documentation to look up specific information about Ansible modules and commands  

- **ansible-doc** command for getting modules arguments, and *ansible is all about modules*  

    ```
    # list all installed modules
    
    ansible-doc  -l
    
    ansible-doc  -l  ansible.posix   # list only modules in "ansible.posix" collection
    
    ansible-doc  -F                  # includes path to the python source code .py
    
    
    # get detailed help
    
    ansible-doc  module
    
    ansible-doc  module  -s          # best friend ansible writer command

    ansible-dop  package -s | grep "(required)"     # mandatory arguments when using package mod
    ```


&nbsp;

&nbsp;

&nbsp;

&nbsp;

---

## II. CONFIGURE ANSIBLE  

---





&nbsp;

### 13. Create and modify ansible.cfg   

- **ansible** has 3 layers of configuration, most to less preferred:  
    + *project directory*: self contained environment that includes everything needed to work in a specific project  
        + **ansible.cfg**  
        + inventory  
        + variable files  
        + files used to include tasks  
        + playbooks  
    + *home directory*: allow one user to work with its specific settings  
    + *system level*: using `/etc/ansible/ansible.cfg` (default configuration) and `/etc/ansible/hosts` (default inventory)  

- usual **minimum settings** in `/etc/ansible/ansible.cfg`  

    ```
    # MINIMUM SETTINGS
    
    [defaults]

    remote_user=ansible

    inventory=file

    host_key_checking=false
    
    
    
    [privilege_escalation]
    
    become=true
    
    become_method=sudo
    
    become_user=root
    
    become_ask_pass=false
    ```

- other usual **settings**,  
    + `module_name=raw` , sets default module instead of `command`  
    + `command_warnings=false` , do not display warning messages  

- **ansible-config** command to view *actual* configuration that is / will be used,  

    ```
    ansible-config  view       # show ansible.cfg content used

    ansible-config  dump       # show all settings, and distingish customized from default values

    ansible-config  list       # show extended help about settings, but not actual values
    ```



&nbsp;

### 15. Create a static host inventory file  

- **static inventory**, list hosts, hosts groups, and variables (not recommended). Using INI format:

    ```
    # DEFAULT STATIC INVENTORY                    /etc/ansible/hosts 

                                                  # HOSTS-------------------------------
    192.168.4.1                                   # IP host
        
    host[001:010]                                 # template
    server[1:6].example.com                       # template
  

                                                  # VARIABLES-------------------------------
    server7.example.com      dns1=ggl.com         # host-only variable definition
    server[3:4].example.com  dns1=yho.com         # host-range variable definition
    
    [backup]
    server7.example.com      dns1=loc.com         # host-only variable definition inside a group
                                                  # overrides previous host variable definition
                                                  # because is defined later
    ```



&nbsp;

### 16. Create and use static inventories to define groups of hosts  

- **static inventory**, list hosts, hosts groups, and variables (not recommended). Using INI format:

    ```
    # DEFAULT STATIC INVENTORY                    /etc/ansible/hosts 

                                                  # GROUPS-------------------------------
    [web]                                         # group definition
    192.168.4.100                                 # host member not previously defined
    server2.example.com                           # host member 
    server[4:5].example.com                       # host range 
    
    [db]                                          # group definition
    server5.example.com

    [backup]
    server7.example.com
    
    [majorsrv:children]                           # group with other groups as member
    backup
    web
    db

                                                  # VARIABLES-------------------------------
    [backup:vars]                                 # group variable definition
    dns1=rdx.com                                  # less priority than host-only definition
  
    [majorsrv:vars]                               # parent group variable definition
    dns1=www.com                                  # less priority than children groups definitions
    ansible_user=ansible
    ansible_password=@nsbile123
    ansible_connection=winrm
    ansible_winrm_server_cert_validation=ignore        
    ```



&nbsp;

&nbsp;

&nbsp;

&nbsp;

---

## Appendixes  

---




&nbsp;

### a. Configuration Management  

- **ansible**: agentless configuration management solution, based on *python* and *YAML*

- **devops**: typical cycle where *ansible* is suitable for managing the infraestructure to support the new code (RELEASING + CONFIGURING + MONITORING) lije other tools like *puppet*, *chef*, and *saltstack*:
    1. coding
    2. building
    3. testing
    4. packaging
    5. *releasing*
    6. *configuring*
    7. *monitoring*

- **CONTROLLER NODE** pushes tasks code to **MANAGED NODES**

    |the **CONTROLLER NODE**             |the **MANAGED NODE**                    |
    |------------------------------------|----------------------------------------|
    |needs to be linux                   |no agent is needed                      |
    |execute ansible software            |executes tasks (modules code)           |
    |the operator issues ansible commands|is addressed by the controller node     |
    |provides remote access to managed nodes: *ssh*, *winRM* and/or *API access*|-|

- **playbooks** contains one or more *plays* written in YAML. Tend to be *idempotent* and *self containing*

- **plays** contains one or more *tasks* executed on the *managed nodes*

- **tasks** are implemented using *modules*

- **modules** are pieces of *python code* that do the actual work on the *managed nodes*

- **plugins** extend ansible functionality

- "ansible work" uses *ansible engine* (CLI) and / or *ansible tower* (GUI) based on AWS opensource

- In the controller node, ansible generates Python scripts, which are executed on the managed hosts using ssh

- "idempotent" means that same result is achieved with more than one execution

- "ansible way" of coding:
    + *keep it simple*
    + *make it readable*
    + *use a declarative approach* (describe desired target state)
    + *use specific solutions* (use *modules* vs *commands*)
    

- "Ansible version" is different from "ansible_core" version:

    | ANSIBLE VERSION  | ansible_core VERSION |
    |------------------|----------------------|
    | 2.10             | 2.10                 |
    | 3                | 2.10                 |
    | 4                | 2.11                 |
    | 5                | 2.12                 |
    | 6                | 2.13                 |
    | **7**            | **2.14**             |
    | 8                | 2.15                 |
    | 9                | 2.16                 |
    | 10               | 2.17                 |
    | 11               | 2.18                 |
    | 12               | 2.19                 |
    | 13               | 2.20                 |
    | 14               | 2.21                 |




&nbsp;

### b. Installing Ansible  

- **controller node** requirements to run the ansible software
    + Python 3.x  (default)
    + SSH client  (default)
    + *access to an ansible repository*
    + *user credentials with SSH & sudo permissions on managed host*

    ```
    # RHEL 9, EPEL RELEASE
    
    subscription-manager register                                                   # not mandatory
    subscription-manager repos --enable=codeready-builder-for-rhel-9-$(arch)-rpms   # not mandatory
                        # codeready-builder is needed for some EPEL packages but is not for ansible
    
    dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    dnf install ansible
    ```


    ```
    # RHEL 8, sistema licenciado para ansible
        
    subscription-manager repos --list
    subscription-manager repos --enable=ansible-2-for-rhel-8-x86_64-rpms
    
    yum install ansible
    ```


    ```
    # CENTOS 8, EPEL RELEASE
    
    yum install epel-release
    yum install ansible
    ```


    ```
    # PYTHON PIP
    
    yum install -y python3-pip
    alternatives --set python /usr/bin/python3

    ansible_user$ pip3 install ansible --user
    ```


- **managed nodes** requirements to be managed
    + Python 3.x (default)
    + SSH server (default)
    + *user with SSH & sudo permissions*

- user **ansible_user**, must be able to SSH into the host, and to run commands as root:

    ```
    # in controller node, as 'ansible_user': to SSH the managed node with private-public key pair

    ansible_user$  ssh-keygen
    ansible_user$  ssh-copy-id mng_node_1
    ansible_user$  ssh-copy-id mng_node_2
    ansible_user$  ssh-copy-id ...
    
    ansible_user$  ssh-agent /bin/bash
    ansible_user$  ssh-add
    ```


    ```
    # in managed node, as 'root': to sudo

    root# echo "ansible_user  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible

                             #on_all_HOSTS=(as_all_USERS) without_passwd:all_COMMANDS
    ```




&nbsp;

### c. Using ad hoc commands  

- **ad hoc commands** quick tasks without having to create any playbook  

    | MODULE            | DESCRIPTION                                                                   |
    |-------------------|-------------------------------------------------------------------------------|
    | **raw**           | *without using python*, runs arbitrary command using **SSH** (no idempotent)  |
    | **command**       | default module, runs arbitrary command *without shell* (no idempotent)        |
    | **shell**         | runs arbitrary command *using shell*  (no idempotent)                         |
    | **copy**          | copy files os lines of text                                                   |
    | **yum**           | manage packages on RHEL                                                       |
    | **packages**      | manage packages                                                               |
    | **service**       | manage *systemd* ans *System-V* services                                      |
    | **ping**          | check ig host is in a manageable state (not only ICMP ping)                   |
    

- **Examples**

    ```
    ansible    all      -m user    -a "name=lisa  home=/lisa"
               \_/      \_____/    \________________________/
              hosts      module           arguments

    ansible    all      -m command -a "id=lisa"
    

    ansible    -u root  -i inventory ansible3   --ask-pass   -m raw   -a "yum install python3"
    
    ansible    all                                            -m copy  -a 'content="hello" dest="/etc/motd"'
    
    ansible    all    -m yum      -a "name=nmap state=latest"
    
    ansible    all    -m service  -a "name=httpd state=started enabled=yes"
    
    ansible    all    -m yum      -a "list=httpd"

    ansible    all    -m shell    -a "rpm -qa|grep ansible"
    ```

- Running ad-hoc commands from **shell scripts**

1. scripts must be made executable, using `chmod +x myscript.sh`

2. to be started by just by the name, scripts must be located inside a path defined in **`$PATH`** environment variable. Otherway, the script must be started as `/path_to_the_script/myscript.sh`, like in `./myscript.sh`

3. $PATH includes `/usr/local/bin` and `~/.local/bin` as well as `usr/bin` and `~/bin`

4. the script must include the she-bang (setting which program runs the script) as it first line:
    ```
    #!/bin/bash
    
    ansible host1  -u root  -m raw  -a "dnf install python3 -y"
    ansible host1  -u root  -m raw  -a "adduser ansible_user"
    ansible host1  -u root  -m raw  -a 'echo "ansible_user  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible'
    ```