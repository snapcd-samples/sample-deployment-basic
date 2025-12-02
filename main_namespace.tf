resource "snapcd_namespace" "sample" {
  name     = "sample-basic"
  stack_id = data.snapcd_stack.sample_full.id
}