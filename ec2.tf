#### 2 Configure EC2 Instances

resource "aws_instance" "nextcloud_instance" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_key_name
  subnet_id     = aws_subnet.public_subnet_1.id

  vpc_security_group_ids = [aws_security_group.nextcloud-sg.id]

  root_block_device {
    volume_size           = "100"
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = file("${path.module}/docker.sh")

  tags = {
    Name = "ecs-instance"
  }
}

resource "aws_eip" "ecs_eip" {
  instance = aws_instance.nextcloud_instance.id
}
