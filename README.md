
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

## Working with Chocolatey in an organization?
Does your organization have strong policies against using the internet? Are you deploying software in air-gapped networks? No problem, Chocolatey is [an offline solution that has zero call home](https://chocolatey.org/security#chocolatey-client), and the best part is you [can create packages and host them internally for free]((https://chocolatey.org/docs/how-to-setup-offline-installation)) (see [What is Chocolatey?](https://chocolatey.org/docs/getting-started#what-is-chocolatey) and [Set Up Chocolatey for Organizational/Internal Use](https://chocolatey.org/docs/how-to-setup-offline-installation)). Yes, you read that right, you can take advantage of Chocolatey's infrastructure without any cost! It is important to point out that Chocolatey itself installs with the [Community Package Repository](https://chocolatey.org/packages) already set as a default source repository to allow ease of installs for the greater community, but it is a simple adjustment to remove that and add your own internal sources.

As an organization, you are not likely keen to reach out to the internet. That's fine, with just a few modifications, you can still take advantage of these scripts:

1. Ensure you have the Chocolatey nupkg itself on your internal package repository. This is done in the first few sections of the [organizational deployment guide](https://chocolatey.org/docs/how-to-setup-offline-installation).
1. You may need to also grab the [Boxstarter packages](https://chocolatey.org/packages?q=id%3Aboxstarter) and put them on your internal repository (on each package page in the left menu you will find a download link that will download the nupkg file). The packages may also need to be [internalized](https://chocolatey.org/docs/how-to-recompile-packages) before being put on your internal repository to remove any runtime internet access.
1. Review the script you want to use. Take note of the package names. You will need to either [internalize those packages](https://chocolatey.org/docs/how-to-recompile-packages) or create your own packages with embedded binaries or pointed to internal resources.
1. In the script prior to any calls to Chocolatey, you need to add the following code:
    ~~~powershell
    # Ensure the community repository is removed
    choco source remove --name="'chocolatey'"

    # Sources - Add your internal repositories (add other options like auth/allow self service as needed - https://chocolatey.org/docs/commands-source):
    choco source add --name="'internal_server'" --source="'http://somewhere.internal/chocolatey'" --priority="'1'" --bypass-proxy --user bob --password something
    choco source add --name="'internal_file_share'" --source="'\\fileshare\chocolatey'" --priority="'2'" --bypass-proxy
    #TODO: Add other sources here
    ~~~
1. Alternatively, you could add the following to the end of all of the package installation/upgrade calls:
    ~~~powershell
    --source="'location_name[; location_uri]'"
    ~~~
1. Unfortunately, you may not be able to take advantage of Boxstarter's one-click installer links that are available in the "How to run the scripts" section above. You can still use [an alternative means of running those scripts](http://www.boxstarter.org/InstallingPackages) that still works quite well! Please see the note below for additional addendums.

**NOTE:** At this time, you may find that Boxstarter's one-click installer is hosted externally. It may use the community repository to get those [Boxstarter packages](https://chocolatey.org/packages?q=id%3Aboxstarter) deployed. You may need to set up the one-click installer or [use an alternative means of running your scripts](http://www.boxstarter.org/InstallingPackages) to ensure Boxstarter is using internal locations as well. We'll provide more details on how to do this later (and possibly fixes to Boxstarter itself to allow this)!

## No administrative access?
Are you in an environment where you don't have any administrative access on your machine? No problem, you can still take advantage of Chocolatey and manage "portable" software. You can also use a VM where you may have administrative access (see next section).

For alternative means of deploying "portable" software and installing Chocolatey without administrative access, please see [Non-Administrative Install](https://chocolatey.org/install#non-administrative-install). Unfortunately you won't be able to take advantage of Boxstarter, but you will find resources and an example script that gives you a quick setup of Chocolatey and installation of a few packages.

**NOTE:** It's really important to point out that Chocolatey is not going to magically allow you to install software that requires administrative access to install (at least not with the open source edition), so you will need to find packages that are portable or create those and push them to the community repository or your internal sources.

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
