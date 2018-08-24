## Contributing to Windows Dev Box Setup Scripts

The goal for **Windows Dev Box Setup Scripts** is to help developers get their dev box up and going quickly.

## Before you begin

We're grateful for any and all contributions.  Before you submit a PR we ask that you consider the following points.

* Please create or comment on an existing issue to let us know you're interested in working on something before you start the work. Not only does this avoid multiple people unexpectedly working on the same thing at the same time but it also enables the community to discuss the particulars with you. It's less work for everyone, in the long run, to establish this up front.
* When adding to a setup script, the addition should be useful to the majority of developers working with the dev stack the script is intended for.


## A good pull request

Every contribution has to come with:

* Before making the change, **please open an issue** or comment on an existing issue, and start discussing with the community to see if the idea/feature is interesting enough.

* For both new scripts and script changes please test the entire script on Windows 10.

The core team will test the change to validate it before merging it.


## Repository Structure

Recipe scripts are named with **dev_[MAJOR_AREA]_[MINORAREA]**.
The Minor Area is optional.

Examples
- dev_web_nodejs
- dev_app_android 
- dev_ml

Examples of Major Areas
- web
- app
- ml (machine learning)
- iot

The recipe scripts are intended to be short.  Most of script logic should live in helper scripts which live in the **scripts** folder.  You can add to existing helper scripts or make new helper scripts.

If you make a new recipe script that includes additional manual steps please create a new folder which includes your new script and a Readme with these instructions.

## Testing a script change
Testing script changes is best done on a clean machine.  One way to do this without modifying your primary environment is via a Virtual Machine.

Here's an example of how to set up a test workflow
1. [Install Hyper-V Manager](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)
1. Create a new VM using [Quick Create](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/quick-create-virtual-machine)
1. Save a [checkpoint](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/checkpoints) as your 'clean' restore point

When you've made script changes to your fork you can run the updated script in this clean VM.  In this VM open a browser window and paste the 1-click link which will run your modified recipe script.

`http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/GITHUB_DOMAIN/windows-dev-box-setup-scripts/YOUR_BRANCH/dev_web_nodejs.ps
`

When you've finished testing, in Hyper-V Manager reset this VM to the clean checkpoint so it's ready the next time you test a script.



Thank you!