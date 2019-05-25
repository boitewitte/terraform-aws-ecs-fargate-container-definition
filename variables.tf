variable "enabled" {
  type = bool
  description = "Module is enabled"
  default = true
}

variable "environment" {
  type = list(object({ name = string, value = string }))
  description = "The environment variables to pass to a container."
  default = null
}

variable "command" {
  type = list(string)
  description = "The command that is passed to the container."
  default = null
}

variable "cpu" {
  type = number
  description = "The number of cpu units the Amazon ECS container agent will reserve for the container."
  default = null
}

variable "entry_point" {
  type = list(string)
  description = "The entry point that is passed to the container. "
  default = null
}


variable "essential" {
  type = bool
  description = "If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped."
  default = null
}


variable "name" {
  type = string
  description = "The name of a container."
}

variable "image" {
  type = string
  description = "The image used to start a container. "
}

variable "log_driver" {
  type = string
  description = "The log driver to use for the container."
  default = null
}

variable "log_options" {
  type = map
  description = "The configuration options to send to the log driver."
  default = null
}

variable "log_secret_options" {
  type = list(object({ name = string, valueFrom = string }))
  description = "An object representing the secret to pass to the log configuration."
  default = null
}

variable "memory" {
  type = number
  description = "The hard limit (in MiB) of memory to present to the container."
  default = null
}

variable "memory_reservation" {
  type = number
  description = "The soft limit (in MiB) of memory to reserve for the container."
  default = null
}

variable "port_mappings" {
  type = object({ container_port = number })
  description = "Port mappings allow containers to access ports on the host container instance to send or receive traffic. As this is Fargate, only container_port is allowed"
  default = null
}

variable "health_check" {
  type = object({ command = tuple([string, string]), interval = number, timeout = number, retries = number, start_period = number})
  description = "The health check command and associated configuration parameters for the container."
  default = null
}

variable "working_directory" {
  type = string
  description = "The working directory in which to run commands inside the container."
  default = null
}

variable "secrets" {
  type = list(object({ name = string, valueFrom = string }))
  description = "An object representing the secret to expose to your container."
  default = null
}

variable "readonly_root_filesystem" {
  type = bool
  description = "When this parameter is true, the container is given read-only access to its root file system."
  default = null
}

variable "mount_points" {
  type = object({ sourceVolume = string, containerPath = string, readOnly = bool })
  description = "The mount points for data volumes in your container."
  default = null
}

variable "volumes_from" {
  type = list(object({ sourceContainer = string, readOnly = bool }))
  description = "Data volumes to mount from another container."
  default = null
}

variable "user" {
  type = string
  description = "The user name to use inside the container."
  default = null
}

variable "ulimits" {
  type = list(object({ name = string, hardLimit = number, softLimit = number }))
  description = "A list of ulimits to set in the container."
  default = null
}

variable "docker_labels" {
  type = map
  description = "A key/value map of labels to add to the container."
  default = null
}

variable "linux_capabilities" {
  type = object({ drop = list(string) })
  description = "The Linux capabilities for the container to remove from the default configuration provided by Docker. "
  default = null
}

variable "linux_init_process_enabled" {
  type = bool
  description = "Run an init process inside the container that forwards signals and reaps processes."
  default = null
}

variable "container_depends_on" {
  type = list(object({ containerName = string, condition = string }))
  description = "The dependencies defined for container startup and shutdown."
  default = null
}

variable "container_start_timeout" {
  type = number
  description = "Time duration to wait before giving up on resolving dependencies for a container."
  default = null
}

variable "container_stop_timeout" {
  type = number
  description = "Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own."
  default = null
}

variable "interactive" {
  type = bool
  description = "When this parameter is true, this allows you to deploy containerized applications that require stdin or a tty to be allocated."
  default = null
}

variable "pseudo_terminal" {
  type = bool
  description = "When this parameter is true, a TTY is allocated."
  default = null
}
