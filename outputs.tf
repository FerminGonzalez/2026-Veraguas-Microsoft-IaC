# Outputs de la infraestructura del equipo (Copa 2026).
# Se consumen con: terraform output <nombre>

# --- Resource Group (fuente de verdad de la region) ---
output "resource_group_name" {
  description = "Nombre del resource group del equipo."
  value       = data.azurerm_resource_group.team.name
}

output "location" {
  description = "Region de Azure donde se despliega la infraestructura del equipo."
  value       = data.azurerm_resource_group.team.location
}

# --- Frontend Web App (Node.js 24-lts) ---
output "frontend_app_name" {
  description = "Nombre de la Web App del frontend."
  value       = azurerm_linux_web_app.frontend-app.name
}

output "frontend_default_hostname" {
  description = "Hostname por defecto del frontend (sin esquema)."
  value       = azurerm_linux_web_app.frontend-app.default_hostname
}

output "frontend_url" {
  description = "URL publica del frontend."
  value       = "https://${azurerm_linux_web_app.frontend-app.default_hostname}"
}

# --- Backend Web App (.NET 10.0) ---
output "backend_app_name" {
  description = "Nombre de la Web App del backend (API)."
  value       = azurerm_linux_web_app.backend-app.name
}

output "backend_default_hostname" {
  description = "Hostname por defecto del backend (sin esquema)."
  value       = azurerm_linux_web_app.backend-app.default_hostname
}

output "backend_url" {
  description = "URL publica de la API del backend."
  value       = "https://${azurerm_linux_web_app.backend-app.default_hostname}"
}

# --- Observabilidad ---
output "application_insights_name" {
  description = "Nombre del recurso Application Insights."
  value       = azurerm_application_insights.team_app_insights.name
}

output "application_insights_connection_string" {
  description = "Connection string de Application Insights (sensible; no usar en logs)."
  value       = azurerm_application_insights.team_app_insights.connection_string
  sensitive   = true
}

output "application_insights_app_id" {
  description = "App ID (instrumentation) de Application Insights."
  value       = azurerm_application_insights.team_app_insights.app_id
}

output "log_analytics_workspace_name" {
  description = "Nombre del Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.team.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID del Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.team.id
}

output "plan_index" {
  description = "Indice de plan calculado a partir de team_id (compartido entre 2 equipos consecutivos)."
  value       = local.plan_index
}
