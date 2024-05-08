build {
  name = "drivers"

  sources = [
    "arm.drivers_raspios_lite_armhf",
    "arm.drivers_raspios_lite_arm64"
  ]

  # Create /packer directory
  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline          = ["mkdir /packer", "chmod 777 /packer"]
  }

  # Upload driver source
  provisioner "file" {
    source      = "${path.root}/../rpi/drivers/"
    destination = "/packer/drivers/"
  }

  # Force 32-bit userspace for armhf
  provisioner "shell" {
    only            = [
      "arm.drivers_raspios_lite_armhf"
    ]
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline          = [
      "cat /boot/config.txt",
      "echo 'arm_64bit=0' >> /boot/config.txt"
    ]
  }

  # Reboot armhf
  provisioner "shell" {
    only            = [
      "arm.drivers_raspios_lite_armhf"
    ]
    execute_command   = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    expect_disconnect = true
    inline            = [
      "echo 'Reboot VM'", "reboot"
    ]
  }

  # Build drivers
  provisioner "shell" {
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts = [
      "${path.root}scripts/installers/build-drivers.sh"
    ]
  }
}