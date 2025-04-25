# Authenticate org

Github Action for authenticating a Salesforce org

## Usage

<!-- Start usage -->
```yaml
- uses: actions/checkout@v4
    with:
        # The auth URL for use with sf org login
        # Required: true
        # Default: ''
        auth-url: ''
        
        # Alias for the authenticated org
        # Required: false
        # Default: ''
        alias: ''

        # Set the authenticated org as the default username that all commands run against.
        # Required: false
        # Default: false
        setDefaultUsername: ''

        # Set the authenticated org as the default dev hub org
        # Required: false
        # Default: false
        setDefaultDevhubUsername: ''
```
<!-- end usage -->

## Henvendelser

Spørsmål knyttet til koden eller prosjektet kan stilles som issues her på GitHub.

## For NAV-ansatte

Interne henvendelser kan sendes via Slack i kanalen #platforce.
