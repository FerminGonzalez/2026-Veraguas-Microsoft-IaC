# 2026-Veraguas-Microsoft-IaC - Terraform Infrastructure

## Propósito
Infraestructura como Código (IaC) para despliegue en Azure del stack del hackathon 2026 Veraguas.

## Tecnologías
- **Terraform** (HCL)
- **Azure**: App Service, Azure SQL, Functions, Cosmos DB
- **Provisiona**: Frontend + Backend Web Apps, Log Analytics, Application Insights

## Recursos provisionados (Terraform)
```hdata
# Recursos principales definidos:
- azurerm_linux_web_app "frontend-app"       # Node.js 24-lts
- azurerm_linux_web_app "backend-app"        # .NET 10.0
- azurerm_log_analytics_workspace "team"     # PerGB2018, retención 30 días
- azurerm_application_insights "team_app_insights" # Monitor web
- data.azurerm_service_plan "plan_frontend"  # Plan frontal
- data.azurerm_service_plan "plan_backend"   # Plan backend
- data.azurerm_resource_group "team"          # rg-team-{id}
```

## Archivos Terraform principales
```
main.tf                  - Recursos (LAW, App Insights, 2 Web Apps) y datos
providers.tf             - Proveedor Azure (~> 4.0) + required_version >= 1.5.0
variables.tf             - team_id (con descripción y validación)
locals.tf                - plan_index derivado de team_id
outputs.tf               - URLs, hostnames, connection strings, IDs
deploy.ps1               - Script de despliegue PowerShell (con import de recursos)
README.md                - Guía completa de despliegue
terraform.tfvars.example - Ejemplo de configuración
.gitignore               - Ignora estado, tfvars reales y planes
```

## Por completar / Mejorar
1. ✅ **variables.tf**: `team_id` con descripción y bloque `validation`.
2. ✅ **outputs.tf**: outputs completos (URLs, hostnames, IDs, connection string sensible).
3. ✅ **terraform.tfvars.example**: creado.
4. ⬜ **Backend state**: estado remoto en Azure Blob Storage (ejemplo comentado en README).
5. ✅ **Provider version**: bloqueado `~> 4.0` + `required_version >= 1.5.0`.
6. ✅ **README.md** y **.gitignore** creados.

> Validado con `terraform validate` (v1.9.8): **Success! The configuration is valid.**
> y normalizado con `terraform fmt`.

## Comandos habituales
```bash
# Inicializar y validar
terraform init
terraform validate
terraform plan

# Aplicar y destruir
terraform apply
terraform destroy

# Formateo
terraform fmt
```

## Formato de commits (Convencionales)
```
git commit -m "terraform: descripción del cambio"

tipos sugeridos:
- terraform: cambios en configuración de infraestructura
- vars: actualización de variables
- provider: actualización de proveedor/versión
- plan: ajustes en plan de recursos
- fix: corrección de configuración o error
- feat: nuevo recurso o servicio añadido
```

## Estado actual
- ✅ Terraform configurado para Azure Web Apps + App Insights + Log Analytics
- ✅ Versiones de Node (`24-lts`) y .NET (`10.0`) definidas
- ✅ `team_id` definida con descripción y validación
- ✅ `outputs.tf` completo (URLs, hostnames, IDs, connection string)
- ✅ `.gitignore`, `terraform.tfvars.example` y `README.md` creados
- ✅ `terraform fmt` aplicado y `terraform validate` → **válido**
- ⬜ Backend state remoto: ejemplo documentado en README (pendiente de storage account)
