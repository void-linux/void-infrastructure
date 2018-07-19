## Installation

To apply the Ansible playbooks you need to install Ansible.  To do
this make sure you have python and virtualenv available.  Void's
configuration expects python from the 3.x branch on the control host.
Any version of python is acceptable on the target machines, but for
consistency reasons the system python is 2.7 series.

The first step is to install and check Ansible.  Within the `ansible/`
directory run the following commands.  The virtual environment must
live in a subdirectory called 'venv' as this path is referenced by
`ansible.cfg`.

```shell
$ virtualenv venv
$ source venv/bin/activate
$ pip install -r requirements.txt
```

Once installed, verify that you have `ansible` available within path:

```shell
$ ansible --version
```

The version should match exactly:

```shell
$ ansible --version
ansible 2.5.5
```
