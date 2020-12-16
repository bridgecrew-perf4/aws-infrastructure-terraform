locals {
  public_count = var.enabled && var.type == "public" ? length(var.availability_zones) : 0
  bucket_count = length(var.s3bucket_name)
  policy_file  = templatefile("policy.json", { name = var.var_name, dev_environment = var.var_dev_environment })

  ingress_rules_main = [{
    port        = 22
    cidr_blocks = ["217.24.19.64/29", "82.117.216.88/30", "15.188.31.234/32"]
    },
    {
      port        = 15672
      cidr_blocks = ["217.24.19.64/29", "82.117.216.88/30"]
    },
    {
      port        = 10050
      cidr_blocks = ["217.24.19.64/29", "82.117.216.88/30", "34.254.36.247/32", "50.16.146.15/32"]
    },
    {
      port        = 0
      cidr_blocks = ["200.1.0.0/16"]
    },
    {
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  ingress_rules_db = [{
    port        = 5432
    cidr_blocks = ["200.1.0.0/16", "217.24.19.64/29", "82.117.216.88/30"]
    },
    {
      port        = 10050
      cidr_blocks = ["217.24.19.64/29", "82.117.216.88/30", "34.254.36.247/32", "50.16.146.15/32"]
  }]

  i_type = [var.i_type_octopus, var.i_type_transcoder]
}