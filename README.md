# Google Cloud setup for Nadrama

We have provided a `setup.sh` script to create a Service Account and
Role Bindings in your Google Cloud project, so Nadrama can connect 
and launch/manage resources in it.

Simply run `./setup.sh` in your shell. It will:
1. List your projects
2. Ask you to enter one of those project IDs
3. Create a new Service Account
4. Create role bindings for that Service Account

If you're receiving an error about auth before step 1,
please run `gcloud auth login`, login, then re-run `./setup.sh`.

Once complete, please type `exit` and close the Cloud Shell browser tab/window, and return to Nadrama to continue the setup process.
