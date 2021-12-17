#!/bin/sh

: "${ACTION:=renew}"
: "${SERVER:=https://acme-v02.api.letsencrypt.org/directory}"
: "${DO_PROPAGATION_TIMEOUT=900}"

export DO_PROPAGATION_TIMEOUT

handle_path() {
    vault kv list "$1" | tail -n +3 | while read -r path ; do
        case "$path" in
            */)
                mkdir -p "$1/$path"
                handle_path "$1/$path"
                ;;
            *)
                vault kv get -field contents "$1$path" > "$1$path"
                ;;
        esac
    done
}

printf "Retrieving existing data from Vault\n"
mkdir -p secret/lego/data
handle_path secret/lego/data
cp -r secret/lego/data pre-run

lego \
    --accept-tos \
    --email maldridge@voidlinux.org \
    --path secret/lego/data \
    --dns digitalocean \
    --dns.resolvers 8.8.8.8:53 \
    --domains '*.voidlinux.org' \
    --domains '*.s.voidlinux.org' \
    --server $SERVER \
    $ACTION

if ! diff -rq pre-run secret/lego/data ; then
    printf "Uploading new data to Vault\n"
    find secret/lego/data -type f -exec vault kv put {} contents=@{} \;
fi
