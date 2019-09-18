# Version 1.9.20

### Bug fixes
None.

### New features
None.

# Version 1.9.10

### Bug fixes
None.

### New features
None.

# Version 1.9.00

### Bug fixes
None.

### New features
None.

# Version 1.8.00

### Bug fixes
None.

### New features
None.

# Version 1.7.10

### Bug fixes
- MASUI's OTP channel selection screen was dismissed as soon as channel was selected which caused unexpected behaviour returning an internal OTP processing error to the original request. The Mobile SDK now prompts the internal OTP processing error on the channel selection screen, and the channel selection screen will only be dismissed upon cancellation of OTP process, and/or successful generation of OTP for the selected channel. [DE366491]

### New features
None.

# Version 1.7.00

### Bug fixes
None.

### New features
None.

# Version 1.6.10

### Bug fixes
None.

### New features
None.

# Version 1.6.00

### Bug fixes
None.

### New features
- `MASUI` supports `Samsung SDS Nexsign Integration` for biometric authentication in default login screen when it is enabled. [US423714]

# Version 1.5.00

NOTE: From this version on the frameworks changed to Dynamic instead of Static library

### Bug fixes
None.

### New Features
- The SDK supports dynamic framework. All you need to do is update your Xcode settings. [US367604]

# Version 1.4.00

### Bug fixes
- The cancel button was missing on OTP Channel selection screen and OTP Credential screen [DE258664]

### New Features
- Change to SFSafariViewController for all social login [US279228]
- Complete revamp of login screen with new design 


# Version 1.3.01

### Bug fixes
- Auto-correction on default login screen's username field is removed. [DE255185]

### New features
- Default login screen can now be prompted as needed through ```[MASUser presentLoginViewControllerWithCompletion:];```.
- Default session lock screen is added; ```[MASUser presentSessionLockScreenViewController:]```.
- ```MASBaseLoginViewController``` is introduced to allow better customization of the default login screen.


# Version 1.2.03

### Bug fixes
- None

### New features
- None


# Version 1.2.00

### Bug fixes

- Version number and version string returned incorrect values. [MCT-437]

### New features

- "Cancel" button to cancel the authentication process on default login screen was added. [MCT-439]

### Deprecated methods

- None.


# Version 1.1.00

### Bug fixes

- .

### New features

- .

### Deprecated methods

- .


 [mag]: https://docops.ca.com/mag
 [mas.ca.com]: http://mas.ca.com/
 [docs]: http://mas.ca.com/docs/
 [blog]: http://mas.ca.com/blog/

 [releases]: ../../releases
 [contributing]: /CONTRIBUTING.md
 [license-link]: /LICENSE

