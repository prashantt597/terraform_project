resource "aws_security_group" "ec2_sg" {
  name        = var.environment
  description = "Allow SSH, HTTP, and HTTPS for instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Ip-an be replaced
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.environment
  }
}


resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.environment
  }
}

resource "aws_launch_template" "launch_template" {
  name          = var.environment
  image_id      = "ami-09c8132600c548ed5"  # Replace with your AMI ID
  instance_type = "t3.micro"
  key_name      = "hydra"  # Replace with your SSH key name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd

              # Fetch the correct HTML file based on the environment
              cat <<EOT > /var/www/html/index.html
              ${file("${path.module}/../../html/${var.environment}.html")}
              EOT

              # Set permissions
              chmod 644 /var/www/html/index.html
              chown apache:apache /var/www/html/index.html
              EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.environment
    }
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                = var.environment
  vpc_zone_identifier = [var.public_subnet_1_id, var.public_subnet_2_id]
  desired_capacity    = 2
  min_size            = 1
  max_size            = 3

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.environment
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_target_group_attachment" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  lb_target_group_arn    = var.target_group_arn
}
