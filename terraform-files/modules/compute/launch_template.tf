data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "phonebook_lt" {
  name_prefix   = "phonebook-lt-"
  image_id      = data.aws_ami.al2023.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [var.ec2_sg_id]
  user_data = base64encode(file(var.user_data_file))
}