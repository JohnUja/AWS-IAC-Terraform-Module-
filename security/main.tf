resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Security group for frontend instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH from any where 

  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Http from anywhere 

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All traffic
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Security group for backend instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH from anywhere
  }
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id] # Allow traffic from frontend security group
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"                                # All traffic
    security_groups = [aws_security_group.frontend_sg.id] # Allow traffic from frontend security group
  }
}

  