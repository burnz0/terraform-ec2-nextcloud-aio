locals {
  tags = merge(
    {
      "env"     = "dev"
      "project" = "nextcloud-aio"
    },
    var.tags
  )
}
