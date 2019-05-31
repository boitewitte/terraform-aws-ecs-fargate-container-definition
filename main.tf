terraform {
  required_version = ">= 0.12"
}

locals {
  is_valid = (
    var.enabled == true &&
    ( var.memory != null || var.memory_reservation != null) &&
    var.name != null &&
    var.image != null
  )

  main = {
    name = var.name
    image = var.image
  }

  memory = merge(
    var.memory != null
      ? { memory = var.memory }
      : { },
    var.memory_reservation != null
      ? { memoryReservation = var.memory_reservation }
      : {}
  )

  port_mappings = (
    var.port_mappings != null
      ? { portMappings: { containerPort = var.port_mappings["container_port"] } }
      : { }
  )

  health_check = (
    var.health_check != null
      ? {
          healthCheck = {
            command = var.health_check["command"],
            timeout = var.health_check["timeout"],
            interval = var.health_check["interval"],
            retries = var.health_check["retries"],
            startPeriod = var.health_check["start_period"]
          }
        }
      : {}
  )

  environment_variables = (
    var.environment != null
      ? { environment = var.environment }
      : { }
  )

  secrets = (
    var.secrets != null
      ? { secrets = var.secrets }
      : { }
  )

  environment = merge(
    var.cpu != null ? { cpu = var.cpu } : {},
    var.essential != null ? { essential = var.essential } : {},
    var.entry_point != null ? { entryPoint = var.entry_point } : {},
    var.command != null ? { command = var.command } : {},
    var.working_directory != null ? { workingDirectory = var.working_directory } : {},
    local.environment_variables,
    local.secrets
  )

  log_configuration_is_valid = (
    var.log_driver != null &&
    (
      var.log_driver == "awslogs" ||
      var.log_driver == "splunk"
    )
  )

  log_options = var.log_options != null && length(keys(var.log_options)) > 0 ? { options = var.log_options } : {}
  log_secret_options = var.log_secret_options != null ? { secretOptions = var.log_secret_options } : {}

  log_configuration = (
    local.log_configuration_is_valid == true
      ? merge(
        { logDriver = var.log_driver },
        local.log_options
      )
      : {}
  )


  storage_logging = merge(
    var.readonly_root_filesystem != null ? { readonlyRootFilesystem = var.readonly_root_filesystem } : {},
    var.mount_points != null ? { mountPoints = var.mount_points } : {},
    var.volumes_from != null ? { volumesFrom = var.volumes_from } : {},
    local.log_configuration_is_valid == true ? { logConfiguration = local.log_configuration } : {}
  )

  security = var.user != null ? { user = var.user} : {}

  resource_limits = merge(
    var.ulimits != null ? { ulimits = var.ulimits } : {}
  )

  docker_labels = var.docker_labels != null ? { dockerLabels = var.docker_labels } : {}

  linux_parameters = merge(
    var.linux_capabilities != null ? { capabilities = var.linux_capabilities } : {},
    var.linux_init_process_enabled != null ? { initProcessEnabled = var.linux_init_process_enabled } : {},
  )

  linux = length(keys(local.linux_parameters)) > 0 ? { linuxParameters = local.linux_parameters } : {}

  container = merge(
    var.container_depends_on != null ? { dependsOn = var.container_depends_on } : {},
    var.container_start_timeout != null ? { startTimeout = var.container_start_timeout } : {},
    var.container_stop_timeout != null ? { stopTimeout = var.container_stop_timeout } : {},
  )

  interactive = var.interactive != null ? { interactive = var.interactive } : {}

  pseudo_terminal = var.pseudo_terminal != null ? { pseudoTerminal = var.pseudo_terminal } : {}

  definition = merge(
    local.main,
    local.memory,
    local.port_mappings,
    local.health_check,
    local.environment,
    local.storage_logging,
    local.security,
    local.resource_limits,
    local.docker_labels,
    local.linux,
    local.container,
    local.interactive,
    local.pseudo_terminal
  )

  json = jsonencode(local.definition)
}

resource "null_resource" "started" {
  triggers = {
    is_valid = local.is_valid
    definition = local.json
  }
}
