
# About this project
The goal of this project is to provide a central place to share ideas for streamlining dev box setup and provide sample scripts for common dev scenarios. It's likely you will want to take the scripts here and modify them to fit your particular needs. When you make those changes if you think others would benefit please consider submitting a PR. Before you contribute please see the [Contribution Guidelines](CONTRIBUTING.md).

These scripts leverage two popular open source projects.
- Boxstarter [boxstarter.org](http://boxstarter.org)
- Chocolatey [chocolatey.org](http://chocolatey.org)

## How to run the scripts
Before you begin, please read the [Legal](#Legal) section.  

To run a setup script, click a link in the table below from your target machine. This will download Boxstarter, and prompt you for Boxstarter to run with Administrator privileges (which it needs to do its job). Clicking yes in this dialog will cause the script to begin. You can then leave the job unattended and come back when it's finished.
 
|Click link to run  |Description  |
|---------|---------|
|<a href='http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/Microsoft/windows-dev-box-setup-scripts/master/https://raw.githubusercontent.com/Microsoft/windows-dev-box-setup-scripts/master/dev_app.ps1?token=AK0OHpRu7iHVJgnn7DsbBumVp2C4ljleks5a9LuJwA%3D%3D'>Desktop App</a>     | Windows Desktop App Development (Visual Studio, Windows SDK) |
|<a href='http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/Microsoft/windows-dev-box-setup-scripts/master/dev_web.ps1?token=AK0OHhoec2cUUr7i0KVnUReiLhzNPGxXks5a9LugwA%3D%3D'>Web</a> | Web (VS Code, Multiple Browsers)        |
|<a href='http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/Microsoft/windows-dev-box-setup-scripts/master/dev_web_nodejs.ps1?token=AK0OHg--lXI4lmyAFY_wN2CKxWnUaaSRks5a8VJjwA%3D%3D'>Web NodeJS</a>     | Web Dev with NodeJS (Web + NodeJS LTS)        |
|     | Xamarin (Visual Studio, Xamarin, Android SDK) |
|    | Machine Learning        |
|     | Containers (Kubernetes, etc...)        |
|     | More Coming Soon!        |

## Working with Chocolatey for Organizations?
No problem, you can still use these scripts. You'll need to modify the script to reference your internal package store.  Here are instructions for doing so: 

[ADD INSTRUCTIONS]

## Setting up a VM
Windows 10 VM setup instructions
1. Use Hyper-V's [Quick Create](https://blogs.technet.microsoft.com/virtualization/2017/01/20/a-closer-look-at-vm-quick-create/) to set up a VM 
2. Once signed in to your VM, visit this project in a web browser and click one of the script links in the Readme

# Legal
Please read before using scripts.   

#### Using our scripts downloads third party software 
When you use our sample scripts, these will direct to Chocolately to install the packages.  
By using Chocolatey to install a package, you are accepting the license for the application, executable(s), or other artifacts delivered to your machine as a result of a Chocolatey install. This acceptance occurs whether you know the license terms or not. Read and understand the license terms of any package you plan to install prior to installation through Chocolatey. If you do not want to accept the license of a package you are installing, you need to uninstall the package and any artifacts that end up on your machine as a result of the install.


#### Our samples are provided AS-IS without any warranties of any kind
Chocolately has implemented security safeguards in their process to help protect the community from malicious or pirated software, but any use of our scripts is at your own risk.  Please read the Chocolately's legal terms of use and the Boxstarter project license as well as how the community repository for Chocolatey.org is maintained.  

Our project is subject to the MIT License and we make no warranties, express or implied of any kind.   In no event is Microsoft or contributing copyright holders be liable for any claim, damages or other liability arising from out of or in connection with the use of the project software or the use of other dealings in the project software. 

# Contributing
Do you want to contribute? We would love your help. Here are our <a href="CONTRIBUTING.md">contribution guidelines</a>.
