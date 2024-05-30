resource "time_offset" "initial_secret" {
  triggers = {
    secret_rotation = time_rotating.initial_secret.id
  }
  offset_days = var.expire_secret_after
}

resource "time_offset" "overlapping_secret" {
  triggers = {
    secret_rotation = time_rotating.overlapping_secret.id
  }
  offset_days = var.expire_secret_after + 45
}

resource "time_rotating" "initial_secret" {
  rotation_days = var.expire_secret_after - var.rotate_secret_days_before_expiry
}

resource "time_rotating" "overlapping_secret" {
  rotation_days = (var.expire_secret_after + 45) - var.rotate_secret_days_before_expiry
}