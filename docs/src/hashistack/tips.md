# Tips and Tricks

There are some things that can be done to make working with the
hashistack more streamlined, and some general tricks that have been
learned over time.

## Aliases for Common Functions

You can source the following file and it sets up convenient aliases
for logging in and getting tokens for nomad and consul:

```
export NOMAD_ADDR=https://nomad.s.voidlinux.org
export VAULT_ADDR=https://vault.s.voidlinux.org
export CONSUL_HTTP_ADDR=https://consul.s.voidlinux.org


vlogin() {
    vault login -method=ldap username=maldridge
}

ntok() {
    if ! nomad acl token self -token "$(jq -r .data.secret_id < ~/.nomad-token)" > /dev/null 2>&1 ; then
        vault read -format json nomad/creds/management > ~/.nomad-token
    fi

    NOMAD_TOKEN=$(jq -r .data.secret_id < ~/.nomad-token)
    export NOMAD_TOKEN
}

nkeepalive() {
    ntok

    while vault lease renew "$(jq -r .lease_id < ~/.nomad-token)" > /dev/null 2>&1 ; do
        sleep 300
    done
}

ctok() {
    if ! consul acl token read -id "$(jq -r .data.accessor < ~/.consul-token)" > /dev/null 2>&1 ; then
        vault read -format json consul/creds/root > ~/.consul-token
    fi

    CONSUL_HTTP_TOKEN=$(jq -r .data.token < ~/.consul-token)
    export CONSUL_HTTP_TOKEN
}
```

Note that if you are not a member of netauth/dante you will likely
need to change your roles in the aliases, and you need to change the
username in `vlogin()` to match your netauth username.

You can also background the keepalive function above to keep a nomad
token going for the entire lifetime of your vault token:

```
$ nkeepalive &
[1] 8679
```

Take note of this number, as it is how you can stop the keepalive
process later should you wish to stop it preemptively.  If you use
bash, you can also stop the process by checking the output of `jobs`.

## Debugging a Service Task

Service tasks operate just like a task running on the host, and can be
remotely attached to using the nomad CLI.  Here's an example of
attaching to a running service container and looking around:

  1. First you need the allocation ID, which you can get by getting
     the status of the top level job.

     ```
     $ nomad job status minio
     ID            = minio
     Name          = minio
     Submit Date   = 2021-01-22T00:45:33-08:00
     Type          = service
     Priority      = 50
     Datacenters   = VOID
     Namespace     = infrastructure
     Status        = running
     Periodic      = false
     Parameterized = false

     Summary
     Task Group  Queued  Starting  Running  Failed  Complete  Lost
     app         0       0         1        109     13        2

     Allocations
     ID        Node ID   Task Group  Version  Desired  Status   Created    Modified
     187e21b6  e27ec674  app         8        run      running  4d12h ago  4d12h ago
     ```

  2. The allocation ID in this case is `187e21b6`.  We can remotely
     connect to the job now using `nomad alloc exec`:

     ```
     $ nomad alloc exec -i -t 187e21b6 /bin/sh
     #
     ```

     The `-i` option specifies that this is to be an interactive
     session and to connect standard I/O, and the `-t` specifies
     terminal behavior.  The executable invoked must exist in the
     task's namespace, and must be specified by absolute path.

  3. When finished with the interactive session you can exit by
     closing the shell, which will return you to your local prompt.
     Note that the shell depends on the validity of your nomad token,
     so you may need to renew your token if you expect to remain
     attached to a debug session for a long interval.

## Debugging a batch/periodic task

The steps for debugging a batch periodic task are slightly different
from debugging a service task.  You need to change the entrypoint to
keep the container running while you're attached to it:

```diff
                image = "eeacms/rsync"
                -        args = [
                -          "rsync", "-vurk",
                -          "--delete-after",
                -          "-e", "ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts",
                -          "void-buildsync@b-hel-fi.node.consul:/mnt/data/pkgs/", "/pkgs/"
                -        ]
                +        entrypoint = ["/bin/sleep", "3600"]
                +        # args = [
                +        #   "rsync", "-vurk",
                +        #   "--delete-after",
                +        #   "-e", "ssh -i /secrets/id_rsa -o UserKnownHostsFile=/local/known_hosts",
                +        #   "void-buildsync@b-hel-fi.node.consul:/mnt/data/pkgs/", "/pkgs/"
                +        # ]
```

This changes the entrypoint to simply sleep, and after submitting the
job to the cluster and optionally forcing a periodic launch with
`nomad job periodic force <job>`, you can inspect and attach to the
job as shown above.  Note that this only gives you an hour to debug,
if you need more time than that, change the value in the sleep
command.
