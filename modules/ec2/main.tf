resource "aws_instance" "vm" {
  ami                    = "ami-0f00d706c4a80fd93"
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  
  iam_instance_profile = var.iam_instance_profile
  
  monitoring    = true
  ebs_optimized = true
  
  user_data_replace_on_change = true

  user_data = <<-EOF
              #!/bin/bash
              set -e
              
              # Update system
              yum update -y
              
              # Install Apache web server
              yum install -y httpd
              
              # Create a simple web application
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>IaC Demo - DevSecOps Project</title>
                  <style>
                      * { margin: 0; padding: 0; box-sizing: border-box; }
                      body {
                          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                          min-height: 100vh;
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          padding: 20px;
                      }
                      .container {
                          background: white;
                          border-radius: 20px;
                          padding: 40px;
                          max-width: 800px;
                          box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                      }
                      h1 {
                          color: #667eea;
                          margin-bottom: 20px;
                          font-size: 2.5em;
                      }
                      .badge {
                          display: inline-block;
                          background: #10b981;
                          color: white;
                          padding: 8px 16px;
                          border-radius: 20px;
                          font-weight: bold;
                          margin-bottom: 30px;
                      }
                      .info-grid {
                          display: grid;
                          grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                          gap: 20px;
                          margin: 30px 0;
                      }
                      .info-card {
                          background: #f3f4f6;
                          padding: 20px;
                          border-radius: 10px;
                          border-left: 4px solid #667eea;
                      }
                      .info-card h3 {
                          color: #374151;
                          font-size: 0.9em;
                          margin-bottom: 8px;
                      }
                      .info-card p {
                          color: #667eea;
                          font-weight: bold;
                          font-size: 1.1em;
                      }
                      .features {
                          margin-top: 30px;
                      }
                      .features h2 {
                          color: #374151;
                          margin-bottom: 15px;
                      }
                      .features ul {
                          list-style: none;
                          padding-left: 0;
                      }
                      .features li {
                          padding: 10px 0;
                          border-bottom: 1px solid #e5e7eb;
                          color: #6b7280;
                      }
                      .features li:before {
                          content: "- ";
                          color: #10b981;
                          font-weight: bold;
                          margin-right: 10px;
                      }
                      .footer {
                          margin-top: 30px;
                          text-align: center;
                          color: #9ca3af;
                          font-size: 0.9em;
                      }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>IaC Demo Application</h1>
                      <span class="badge">DEPLOYED VIA CI/CD PIPELINE</span>
                      
                      <p style="color: #6b7280; margin-bottom: 30px;">
                          This application was automatically deployed to AWS using Terraform and GitHub Actions.
                      </p>
                      
                      <div class="info-grid">
                          <div class="info-card">
                              <h3>Infrastructure</h3>
                              <p>AWS EC2</p>
                          </div>
                          <div class="info-card">
                              <h3>Instance Type</h3>
                              <p>t3.micro</p>
                          </div>
                          <div class="info-card">
                              <h3>Region</h3>
                              <p>us-east-1</p>
                          </div>
                          <div class="info-card">
                              <h3>Deployed By</h3>
                              <p>Terraform</p>
                          </div>
                      </div>
                      
                      <div class="features">
                          <h2>Security Features</h2>
                          <ul>
                              <li>VPC Network Isolation (Public/Private Subnets)</li>
                              <li>IAM Role with Least Privilege</li>
                              <li>IMDSv2 Enforced</li>
                              <li>EBS Encryption Enabled</li>
                              <li>VPC Flow Logs Active</li>
                              <li>Security Groups with IP Restrictions</li>
                              <li>CloudWatch Monitoring Enabled</li>
                              <li>Automated Security Scanning (Checkov, Semgrep, Trivy)</li>
                          </ul>
                      </div>
                      
                      <div class="features">
                          <h2>CI/CD Pipeline</h2>
                          <ul>
                              <li>SAST Scanning with Semgrep</li>
                              <li>Dependency Scanning with Trivy</li>
                              <li>IaC Security Scanning with Checkov</li>
                              <li>Automated Terraform Plan & Apply</li>
                              <li>Remote State Management (S3)</li>
                              <li>Manual Deployment Approval</li>
                          </ul>
                      </div>
                      
                      <div class="footer">
                          <p>Part of the 3-Month DevSecOps Journey | Week 8 Project</p>
                          <p>GitHub: leelee222/iac-demo</p>
                      </div>
                  </div>
              </body>
              </html>
              HTML
              
              # Start and enable Apache
              systemctl start httpd
              systemctl enable httpd
              
              # Configure firewall
              systemctl start firewalld || true
              firewall-cmd --permanent --add-service=http || true
              firewall-cmd --reload || true
              
              echo "Application deployment complete!"
              EOF

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 8
  }

  tags = {
    Name = var.instance_name
  }
}
