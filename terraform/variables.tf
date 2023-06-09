variable "consul_server" {
  type = string
}

variable "consul_address" {
  type = string
}

variable "consul_port" {
  type = number
}

variable "consul_token" {
  type      = string
  sensitive = true
}
