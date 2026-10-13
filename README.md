# 2026-Veraguas-Microsoft-IaC — Terraform (Azure)

Infraestructura como Código (IaC) con **Terraform** para desplegar el stack del
hackathon **Copa 2026 Veraguas** en **Azure**.

## ¿Qué despliega?

| Recurso | Tipo | Nombre |
|---------|------|--------|
| Log Analytics Workspace | `azurerm_log_analytics_workspace` | `hackathon-copa-2026-team-{id}-law` |
| Application Insights | `azurerm_application_insights` | `hackathon-copa-2026-team-{id}-appi` |
| Frontend Web App | `azurerm_linux_web_app` (Node.js `24-lts`) | `hackathon-copa-2026-team-{id}-frontend` |
| Backend Web App (API) | `azurerm_linux_web_app` (.NET `10.0`) | `hackathon-copa-2026-team-{id}-api` |

Además **lee** (como `data`) recursos preexistentes del entorno compartido:

- `data.azurerm_resource_group.team` → `rg-team-{id}` (fuente de verdad de la **región**)
- `data.azurerm_service_plan.plan_frontend` → `plan-front-{plan_index}` en `rg-hackathon-shared`
- `data.azurerm_service_plan.plan_backend` → `plan-back-{plan_index}` en `rg-hackathon-shared`

### Lógica de `plan_index` (planes compartidos)

```hcl
plan_index = format("%02d", floor((var.team_id - 1) / 2) + 1)
```

Los **equipos consecutivos comparten plan** (2 equipos por plan). Ejemplo:
`team_id = 12` y `team_id = 13` → ambos usan `plan_index = 06`.

## Estructura del repositorio

```
main.tf                  # Recursos (LAW, App Insights, 2 Web Apps) y datos
providers.tf             # Requiere Terraform >= 1.5.0 y azurerm ~> 4.0
variables.tf             # team_id (con validación)
locals.tf                # plan_index derivado de team_id
outputs.tf               # URLs, hostnames, connection strings, IDs
deploy.ps1               # Script de despliegue (PowerShell) con import de recursos
terraform.tfvars.example # Ejemplo de configuración
.gitignore               # Ignora estado, tfvars reales y planes
```

## Requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) `>= 1.5.0`
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (`az`)
- Una sesión de Azure activa y pertenencia al grupo `grupo-copa-{team_id}`

## Despliegue

### Opción A — Script (recomendada, valida membresía e importa recursos)

```powershell
# PowerShell (requiere az login previo)
./deploy.ps1 -TeamId 13
```

El script:
1. Valida que `az` y `terraform` estén instalados.
2. Comprueba que el usuario autenticado pertenezca a `grupo-copa-{TeamId}`.
3. Ejecuta `terraform init` y selecciona el workspace `team-{TeamId}`.
4. **Importa** al estado los recursos que ya existan en Azure (evita recrear).
5. Genera y aplica el plan.

### Opción B — Manual

```bash
cp terraform.tfvars.example terraform.tfvars   # editar team_id
terraform init
terraform validate
terraform plan    -var="team_id=13"
terraform apply   -var="team_id=13" -auto-approve
terraform output                                # ver URLs y outputs
```

## Outputs disponibles

```bash
terraform output frontend_url
terraform output backend_url
terraform output -raw application_insights_connection_string   # sensible
```

Ver `outputs.tf` para el listado completo (URLs, hostnames, IDs de observabilidad).

## Estado remoto (recomendado para equipos)

Por defecto el estado es **local** (`terraform.tfstate`). Para trabajo en equipo se
recomienda estado remoto en **Azure Blob Storage** con bloqueo. Ejemplo:

```hcl
# backend.tf  (descomentar y ajustar tras crear la storage account)
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-hackathon-shared"
#     storage_account_name = "<STORAGE_ACCOUNT>"
#     container_name       = "tfstate"
#     key                  = "team-<TEAM_ID>.tfstate"
#   }
# }
```

Tras crearlo: `terraform init -migrate-state`.

## Formato de commits (convencionales)

```
terraform: descripción del cambio
vars: actualización de variables
provider: cambio de proveedor/versión
plan: ajuste de plan de recursos
fix: corrección de configuración
feat: nuevo recurso
```
