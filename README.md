CloudKitDemo
============

Demonstrates key features of CloudKit, including user discovery.

This CloudKit demo app will initially discover the iCloud user running the app. If you tap the the "Find Contacts" button, it will discover the list of other users that have run the app, assuming they have opted in to discovery.  Some CloudKit calls such as user discovery can be rate limited and the app demonstrates how to detect if the call was rate limited.
