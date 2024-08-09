packer {
  required_plugins {
    git = {
      version = ">= 1.1.3"
      source = "github.com/michalfita/packer-plugin-cross"
    }
  }
}