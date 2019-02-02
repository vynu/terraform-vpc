terraform {
  required_version = ">= 0.11.2"

  backend "consul" {
    address         = "localhost:8500"
    path            = "tf/state/vpc-create"
    access_token    = "supersecure"
    lock            = true
  }
}
