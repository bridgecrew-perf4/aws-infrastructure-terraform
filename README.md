# AWS-Infrastructure-Terraform # 

1.  PREPARE YOUR LOCAL ENVIRONMENT

    1.1 Please ensure you have the following tools installed

            Terraform => v0.14.0
            Ansible => v2.9.6
            Ansible-playbook =>2.9.6
            
    1.2 Export the following environment variables by executing: 

            export AWS_SECRET_ACCESS_KEY=xxxxx                  # Your secret access key 
            export AWS_ACCESS_KEY_ID=xxxxx                      # Your access key id 
            export var_env=small-ansible-infrastructure         # Environment size (eg. small-ansible-infrastructure, large-ansible-infrastructure) 
            export var_dev_environment                          # Environment type (eg. production, stage, demo )
            export var_name=octopus                             # Tenant name 
            export var_region=eu-west   -1                      # (eg. eu-central-1, eu-west-1 )
            export var_chat=1                                   # include chat service ( eg. 1 or 0 ) 
            export var_analytics=1                              # include analytics service ( eg. 1 or 0 ) 
            export var_subscription=1                           # include subscription service ( eg. 1 or 0 ) 
            export var_comments=1                               # include comment service ( eg. 1 or 0 )         
            export var_ecommerce=1                              # include ecommerce service ( eg. 1 or 0 )      
            export var_ums=1                                    # include ums service ( eg. 1 or 0 )      
            export var_webpay=1                                 # include webpay service ( eg. 1 or 0 )  
            export var_signaling=1                              # include signaling service ( eg. 1 or 0 )                              
            
2. CREATE ENVRONMENT     

        ------- Create environment "small-ansible-infrastructure" -------
        
        ansible-playbook deploy-aws-infrastructure.yml
        
3. TERMINATE ENVIRONMENT

        ------- Terminate environment "small-ansible-infrastructure" -------
        
        ansible-playbook terminate-aws-infrastructure.yml
