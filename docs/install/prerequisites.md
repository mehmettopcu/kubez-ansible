# Dependency Installation

- Only needs to be installed on the deployment node; nodes running in the cluster `do not need to execute this`.
- You can choose either `direct installation` or `script installation`.

## Installation Steps

### Direct Installation

   ```shell
   # (Recommended) Quick installation in China
   curl http://s9.cloud.pixiuio.com/master/setup_env.sh | bash

   # (Optional) GitHub installation, requires internet access
   curl https://raw.githubusercontent.com/pixiu-io/kubez-ansible/master/tools/setup_env.sh | bash
   ```

### Script Installation

   ```text
   # (Recommended) Quick script retrieval in China
   curl http://s9.cloud.pixiuio.com/master/setup_env.sh -o setup_env.sh

   # (Optional) Automatic retrieval; when online, directly fetch the script to local using curl
   curl https://raw.githubusercontent.com/pixiu-io/kubez-ansible/master/tools/setup_env.sh -o setup_env.sh

   # Manual retrieval; use this if automatic retrieval fails, usually due to network issues or missing curl command
   # Copy the project's tools/setup_env.sh and save it as setup_env.sh

   # Execute the installation script
   bash setup_env.sh
   ```

### Verification

   ```shell
   # Running kubez-ansible should produce normal output
   kubez-ansible -h

   # multinode will be automatically generated in the working directory (usually the /root directory)
   ```
