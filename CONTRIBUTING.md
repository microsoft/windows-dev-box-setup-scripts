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

Scripts are named with dev_[MAJOR_AREA]_[MINORAREA].
The Minor Area is optional. Currently the scripts are completely self contained - there is no script chaining. It would be useful to move to a tree model, and we'll update these instructions if/when that happens.

Examples
- dev_web_nodejs
- dev_app_android 
- dev_ml

Current Major Areas
- web
- app
- ml (machine learning)
- iot
- backend

Minor Area is open

If you have a change request for Major Area please let us know by filing an issue.

If the script has additional steps please create a folder for your script and include a Readme with these instructions.

Thank you!