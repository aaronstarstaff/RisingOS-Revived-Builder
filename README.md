# RisingOS-Revived-Builder

**RisingOS-Revived-Builder** is a **self-hosted Continuous Integration (CI) build server** designed for RisingOS Revived maintainers. This project is proudly sponsored by [@Arman-ATI](https://github.com/Arman-ATI) and [@keosh1](https://github.com/keosh1)

## License

This project is licensed under the MIT License. For more details, please refer to the [LICENSE](LICENSE) file.

## Getting Started

To start using RisingOS-Revived-Builder, follow these steps:

1. **Become and authorized user**
   - Create [pull request](https://github.com/RisingOS-Revived-devices/RisingOS_Revived-Builder/commit/71c0ea1a3e5f38cba5164f423ac812307bcb2790) to authorized_users.json to add yourself as an authorized user.
  
2. **Navigate to the Actions Tab:**
   - Go to the **Actions** tab in the repository.

3. **Select the RisingOS-Revived-Builder Workflow:**
   - Choose the **RisingOS-Revived-Builder** workflow from the list.

4. **Run the Workflow:**
   - Click the **Run workflow** button.
   - Fill in the required information in the provided fields.
   - Execute the workflow and wait for your build to start. Note that it may take some time if there are ongoing builds.

5. **Monitor Build Progress:**
   - Once the build begins, you can monitor its progress and view logs, on successs/failure you'll be notified on telegram.

6. **Access Build Outputs:**
   - The successful builds will be uploaded to gofile, if you plan to publish it, you have push it to RisingOS-Revived sourceforge.

## Note

- **Do not add `vendorsetup.sh`:** Include all necessary components in the `.dependencies` file.
- **Build Limits:** Normal maintainers are limited to 3 builds per device, while core members have unlimited builds.

## Credits

- **Resync Script:** Special thanks to the team at [crave](https://github.com/accupara/docker-images/blob/master/aosp/common/resync.sh) for the base resync script.
