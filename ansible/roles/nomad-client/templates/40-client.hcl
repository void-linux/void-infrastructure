#Jinja2: trim_blocks: "true", lstrip_blocks: "true"
client {
  enabled = true
  network_interface = "void0"
  cni_path = "/usr/libexec/cni"
  gc_interval = "10m"

  reserved {
    cpu = 250
    memory = 512

    reserved_ports = "{{nomad_reserved_ports|default([])|join(",")}}"
  }

  host_volume "netauth_config" {
    path = "/etc/netauth"
    read_only = true
  }

  host_volume "hostlogs" {
    path = "/var/log"
    read_only = false
  }

  host_volume "dockersocket" {
    path = "/run/docker.sock"
    read_only = true
  }
{% for volume in nomad_host_volumes|default([]) %}

  host_volume "{{volume.name}}" {
    path = "{{volume.path}}"
    read_only = {{volume.read_only|bool|lower}}
  }
{% endfor %}
{% if nomad_meta|default(false) %}

  meta {
{% for key, value in nomad_meta.items() %}
    {{key}} = "{{value}}"
{% endfor %}
  }
{% endif %}
}

vault {
  enabled = true
  address = "http://active.vault.service.consul:8200"
}

plugin "docker" {
  config {
    extra_labels = ["*"]
  }
}
