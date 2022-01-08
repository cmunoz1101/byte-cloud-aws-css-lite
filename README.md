listar zonas de disponibilidad por region
aws --profile=default ec2 describe-availability-zones --region us-east-1
aws ec2 describe-availability-zones --region us-east-1 --filters Name=state,Values=available
aws ec2 describe-availability-zones --region us-east-1 --filters Name=state,Values=available  | findstr "ZoneName"
