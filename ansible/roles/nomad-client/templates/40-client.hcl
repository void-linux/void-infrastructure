#jinja2: trim_blocks: "true", lstrip_blocks: "true"
client {
  enabled = true
  network_interface = "void0"
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
