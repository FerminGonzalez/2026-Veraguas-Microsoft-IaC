variable "team_id" {
  type        = number
  description = "Identificador numerico del equipo en el hackathon Copa 2026. Se usa para nombrar los recursos (rg-team-{id}, app names) y para calcular el plan_index compartido."

  validation {
    condition     = var.team_id >= 1 && floor(var.team_id) == var.team_id
    error_message = "team_id debe ser un numero entero mayor o igual a 1."
  }
}

# Nota: NO se define variable "location" a proposito.
# La ubicacion se toma de data.azurerm_resource_group.team.location
# (el RG rg-team-{id} ya existe y es la fuente de verdad de la region).
# Del mismo modo, plan_index no es variable sino un local derivado de team_id
# (ver locals.tf), por lo que no puede desviarse accidentalmente.
