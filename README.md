# Sample Deployment - Basic

This sample demonstrates how to use the [Snap CD Terraform Provider](https://registry.terraform.io/providers/schrieksoft/snapcd/latest/docs) to define and manage infrastructure modules.

## Prerequisites

Before deploying this sample, complete the following steps from the [Quickstart Guide](https://docs.snapcd.io/quickstart/):

1. **Create a User Account** - Sign up at [snapcd.io](https://snapcd.io)
2. **Create an Organization** - Set up your organization on first login
3. **Generate Credentials** - Create either:
   - A personal access token for your user, OR
   - A Service Principal with `Organization.Owner` permissions
4. **Register and Deploy a Runner** - Follow the runner deployment instructions
5. **Create a Stack** - Create a Stack (e.g., "samples") via the portal or API

## Variables

This deployment requires the following variables:

| Variable | Description | How to Obtain |
|----------|-------------|---------------|
| `client_id` | The Client ID for authentication | From your Service Principal or personal access token settings in the [snapcd.io](https://snapcd.io) portal |
| `client_secret` | The Client Secret for authentication (sensitive) | Generated when creating your Service Principal or personal access token |
| `organization_id` | Your Snap CD Organization ID | Found in your organization settings at [snapcd.io](https://snapcd.io) |
| `runner_name` | The name of your registered Runner | The name you gave your Runner when registering it |
| `stack_name` | The name of the Stack to deploy to | The name of the Stack you created (e.g., "samples") |

### Setting Variables

Create a `terraform.tfvars` file (excluded from git by default):

```hcl
client_id       = "your-client-id"
client_secret   = "your-client-secret"
organization_id = "your-organization-id"
runner_name     = "your-runner-name"
stack_name      = "samples"
```

Alternatively, use environment variables:

```bash
export TF_VAR_client_id="your-client-id"
export TF_VAR_client_secret="your-client-secret"
export TF_VAR_organization_id="your-organization-id"
export TF_VAR_runner_name="your-runner-name"
export TF_VAR_stack_name="samples"
```

## What This Sample Creates

This sample creates the following Snap CD resources:

1. **Namespace** (`sample-basic`) - A logical grouping within your Stack

2. **VPC Module** - A mock VPC module that demonstrates:
   - Literal input parameters (`vpc_name`, `vpc_cidr_block`, `public_subnet_cidr`, `private_subnet_cidr`)
   - Environment variables passed to the module (`SOME_ENV_VAR`)
   - A lifecycle hook (`init_before_hook`) that runs before initialization

3. **Database Module** - A mock database module that demonstrates:
   - Literal input parameters (`database_name`, `database_sku`)
   - Input from another module's output (`private_subnet_id` from the VPC module)

## Usage

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply
```

## Architecture

```
Stack (e.g., "samples")
└── Namespace (sample-basic)
    ├── Module: vpc
    │   ├── Params: vpc_name, vpc_cidr_block, public_subnet_cidr, private_subnet_cidr
    │   ├── EnvVars: SOME_ENV_VAR
    │   └── Outputs: private_subnet_id (consumed by database)
    │
    └── Module: database
        ├── Params: database_name, database_sku
        └── Params (from output): private_subnet_id ← vpc.private_subnet_id
```

## Key Concepts Demonstrated

- **Module Inputs from Literals** - Hardcoded values passed as parameters
- **Module Inputs from Outputs** - Wiring one module's output to another module's input, creating dependencies
- **Environment Variables** - Passing environment variables to module execution
- **Lifecycle Hooks** - Running custom commands during module lifecycle (`init_before_hook`)
- **Auto-upgrade/Auto-reconfigure** - Modules automatically respond to source and input changes
