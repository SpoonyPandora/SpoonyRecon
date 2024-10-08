###This script will allow you to change password of target user without RSAT. It takes advantage of the ADSI type accelerator for searching usernames and changing password values.

###GLOBAL VARIABLES

$domain = Read-Host "Input domain (exclude trailng backslash)"
$user = Read-Host "Input username (sAMAccountName)"
$old_Pass = Read-Host -AsSecureString "Input old password (case sensitive)"
$new_Pass = Read-Host -AsSecureString "Input new password (case sensitive)"
$confirm_new_Pass = Read-Host -AsSecureString "Confirm new password"

###GLOBAL FUNCTIONS

function Verify-User {
  $search = [adsisearcher]"(&(ObjectCategory=Person)(ObjectClass=User)(sAMAccountName=$user))"
  $false = ''
  if ($search) {true}
    Write-Host "sAMAccountName verified, continuning..."
  else
    Write-Host "User account $domain\$user does not exist."
    Pause
}

function Compare-passwordValues {
  $BSTR_p1 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($new_Pass)
  $BSTR_p2 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirm_new_Pass)
  $PlainPassword_p1 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR_p1)
  $PlainPassword_p2 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR_p2)
  $comparison_check = ($PlainPassword_p1 -eq $PlainPassword_p2)
  If ($comparison_check -eq "True") {
    Write-Host "New password confirmed..."
    }
  Else {
    Write-Host "New and confirm password values do not match!"
    Pause
    Exit}
}

function Change-userPassword {
  Write-Host "Verifying user..."
  $verify_User = [adsisearcher]"(&(objectClass=user)(ObjectCategory=person)(userPrincipalName=$user))"
  If (-Not $verify_User) {
    Write-Host "User not found, exiting."
    Exit}
  Else {
    Write-Host "User found, requesting password change..."
    Try {
      ([ADSI]"LDAP://CN=$user,CN=Users,DC=$domain,DC=com").ChangePassword('$old_Pass','new_Pass')}
    Catch {
      Write-Host "Error when changing user password: $_"
      Exit}
    Write-Host "Password change for user $domain\$user successful!"
    Exit}
}

###Check for matching $new_Pass and $confirm_new_Pass values via Compare-passwordValues. Pass user value to Verify-User, confirm user against AD, if valid then change password.

Compare-passwordValues -ErrorAction Stop
Verify-User -ErrorAction Stop
Change-userPassword


###ROADMAP/WISHLIST
#Confirm new password values match. Need to call .NET to decrypt strings.
#Bundle everything into functions.
#Error handling.
#Allow manipulation of distinguished name values for more accuracy.

###KNOWN ISSUES
#User verification will return false positives for non-existent usernames.
