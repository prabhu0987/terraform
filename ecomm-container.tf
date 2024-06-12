# Pulls the image

resource "docker_image" "ecomm" {
  name = "prabhupallala/ecomm"
}

# start a container
resource "docker_container" "ecomm-container" {
  image = docker_image.ecomm.image_id
  name  = "ecomm-container"

ports {
    internal = 80
    external = 8081
    ip       = "0.0.0.0"
  }
}
