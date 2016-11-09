iOS Switch Movie Grid Coding Exercise
=================

## Test description
https://docs.google.com/document/d/1wrKiZq8mevGO0zs9sAsbKD8o0ocCmLynRjIdGso-JN0/edit#

## Features
- pull to refresh support
- offline support (movies are saved to the Realm)
- easy JSON->Realm mapping via Realm+JSON
- automatic CollectionView cells insertion/removal animation (the movies list changes is done on background thread after network request, collectionView view will react automatically to the model changes)
- server request activity indication
- error message is shown when no internet connection or server returned an error
- portrait and landscape modes support
- universal app, all devices are supported
- font awesome is used for all the icons used in the app, the only application asset is the application icon

## Test environment
Simulators:
iPhone 6, iPhone 6+, iPhone 7+, iPad Air

Devices:
iPhone SE iOS 10.02
