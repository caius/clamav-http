job "scan" {
  datacenters = ["dc1"]
  type = "service"

  group "app" {
    count = 1

    network {
      port "http" {
        to = 80
      }
    }

    service {
      name     = "http"
      port     = "http"
      provider = "nomad"
    }

    task "http" {
      driver = "docker"

      config {
        image = "quay.io/ukhomeofficedigital/acp-clamav-http"
        ports = ["http"]

        # The "auth_soft_fail" configuration instructs Nomad to try public
        # repositories if the task fails to authenticate when pulling images
        # and the Docker driver has an "auth" configuration block.
        auth_soft_fail = true
      }
      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }
    }
  }
}
