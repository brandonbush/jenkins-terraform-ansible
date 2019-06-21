# jenkins-terraform-ansible
This project was a proof of concept to determine how to pass Terraform variables to Ansible to provision and . The idea was to use Terraform to provision a server and subsequently allow Ansible to bootstrap the image.

# Running this
Jenkins needs to be installed and configured to use Terraform using the AWSCLI. I source `/etc/profile` in my Jenkinsfile to make things easy to have Terraform and awscli on the PATH, but you'll also need to run `aws configure` for the Jenkins user or otherwise set the AWS access keys.

# Why I built This
Our team was deciding on a usage model for using Terraform and Ansible together and this was one way we decided to try out. The general idea that went into it was to split our Ansible runs into two categories: **instance bootstrapping** and **configuration drift management**.

## Why bootstrap with Ansible and not just use Terraform and User Data?
The big issue with using User Data and Terraform is that if User Data changes in _any_ way (Terraform compares a hash of the file to the hash of the file in state), Terraform will **destroy and recreate the instance**. This behavior is not always desirable, especially when coupled with modules being deployed across environments. While we could also use Terraform with Launch Templates to get around some of that behavior, Launch Templates are not always feasible either.

## Instance Bootstrapping
As evidenced by the bootstrap directory in this project, these playbooks run to bootstrap an instance and get it ready for use. Many articles online suggested using a `local-exec` Terraform block to run an Ansible playbook, but this was not a clean solution as there needed to be a [wait function built in to make sure an instance was ready](https://github.com/hashicorp/terraform/issues/2661#issuecomment-201513634). There would also be an issue if we were using launch templates and ASGs, as the scaling event in AWS would happen outside of the Terraform execution.[1]
 
### Pros:
* Easy to maintain inventory up to the minute. We wouldn’t have to worry about an instance being provisioned but not being bootstrapped.
* Bootstrap playbooks would not need to be idempotent, so we would have more flexibility in running them.
 
### Cons:
* The provisioning step isn’t directly tied to the build pipeline, so if an instance fails bootstrapping the pipeline will still have succeeded. We would want to think about how we might set up better health checks as a result.
* Could get unwieldy if we had a number of different servers with very small bootstrapping differences between them
 
[1] One big alternative here is to create a pipeline step to use Terraform state to build our Ansible Dynamic Inventory, but again the issue with Auto-Scaling comes up. A possible solution would be to have a Lambda function listening on scaling events that kicks off an Ansible run, but using `ansible-pull` was easier.

## Configuration Drift Management
These Ansible runs are kicked off every allotted time increment, perhaps daily, as a separate Jenkins job. We can then use Ansible's EC2 Dynamic Inventory without worrying about messing with Terraform state. The possibilities are endless for how we could configure things, but our thoughts went to mapping AWS tags to Ansible roles. 
 
### Pros:
* Keeps our infrastructure from drifting
* We don’t have to write our own Terraform state dynamic inventory code, or try to repurpose someone else’s
 
### Cons:
* Tag management becomes critical
* Ansible runs will have to be idempotent (which is Ansible best practice, but requires extra thought/effort)
