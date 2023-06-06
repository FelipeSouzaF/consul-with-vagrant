data_dir = "/opt/consul"

client_addr = "0.0.0.0"

ui_config{
    enabled = true
}

server = true

bind_addr = "0.0.0.0"

advertise_addr = "{{ GetInterfaceIP `eth0` }}"

bootstrap_expect = 1

encrypt = "${GOSSIP_KEY}"

verify_incoming = true

verify_outgoing = true
