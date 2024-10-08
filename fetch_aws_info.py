import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

def fetch_ec2_instances():
    ec2 = boto3.client('ec2')
    response = ec2.describe_instances()
    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            if instance['State']['Name'] == 'running':
                instances.append(instance['InstanceId'])
    return instances

def fetch_s3_buckets():
    s3 = boto3.client('s3')
    response = s3.list_buckets()
    buckets = [bucket['Name'] for bucket in response['Buckets']]
    return buckets

def fetch_billing_info():
    # Billing information requires appropriate permissions
    # Make sure you have enabled Cost Explorer
    ce = boto3.client('ce')
    response = ce.get_cost_and_usage(
        TimePeriod={
            'Start': '2023-10-01',  # Update this to the desired start date
            'End': '2023-10-31'     # Update this to the desired end date
        },
        Granularity='MONTHLY',
        Metrics=['UnblendedCost']
    )
    return response

def main():
    try:
        print("Fetching running EC2 instances...")
        ec2_instances = fetch_ec2_instances()
        print("Running EC2 Instances:", ec2_instances)

        print("Fetching S3 buckets...")
        s3_buckets = fetch_s3_buckets()
        print("S3 Buckets:", s3_buckets)

        print("Fetching billing information...")
        billing_info = fetch_billing_info()
        print("Billing Information:", billing_info)

    except (NoCredentialsError, PartialCredentialsError):
        print("AWS credentials not found. Please configure your credentials.")
    except Exception as e:
        print("An error occurred:", str(e))

if __name__ == "__main__":
    main()
