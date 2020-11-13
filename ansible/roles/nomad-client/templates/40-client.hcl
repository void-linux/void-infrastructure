#jinja2: trim_blocks: "true", lstrip_blocks: "true"
client {
  enabled = true
  network_interface = "void0"
  cni_path = "/usr/libexec/cni"

  host_volume "netauth_config" {
    path = "/etc/netauth"
    read_only = true
  }

  host_volume "netauth_certificates" {
    path = "/var/lib/netauth"
    read_only = true
  }
{% for volume in nomad_host_volumes|default([]) %}

  host_volume "{{volume.name}}" {
    path = "{{volume.path}}"
    read_only = {{volume.read_only|bool|lower}}
  }
{% endfor %}
}

vault {
  enabled = true
  address = "http://active.vault.service.consul:8200"
}
