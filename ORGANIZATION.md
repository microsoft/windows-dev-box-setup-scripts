## Using Chocolatey and Boxstarter in an organization
Does your organization have strong policies against using the internet? Are you deploying software in air-gapped networks? No problem, the Chocolatey client is [an offline solution that has zero call home](https://chocolatey.org/security#chocolatey-client), and the best part is you [can create packages and host them internally for free]((https://chocolatey.org/docs/how-to-setup-offline-installation)) (see [What is Chocolatey?](https://chocolatey.org/docs/getting-started#what-is-chocolatey) and [Set Up Chocolatey for Organizational/Internal Use](https://chocolatey.org/docs/how-to-setup-offline-installation)). Yes, you read that right, there's no charge for this! It is important to point out that Chocolatey itself installs with the [Community Package Repository](https://chocolatey.org/packages) already set as a default source repository to allow ease of installs for the greater community, but it is a simple adjustment to remove that and add your own internal sources.

As an organization, you may not be keen to reach out to the internet. That's fine, with just a few modifications, you can still take advantage of these scripts:

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
