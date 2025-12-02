data "snapcd_stack" "sample_full" {
  name = var.stack_name
}

data "snapcd_runner" "sample_full" {
  name = var.runner_name
}