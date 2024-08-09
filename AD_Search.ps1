###Search via CN
function getCN()
{
    ###Provide target CN partial
    $LastName = Read-Host "Enter partial or full last name to search for (i.e. wick)"

    ###Call ASDI to filter search on object category, class, by SAMAccountName.
    $search = [adsisearcher]"(&(ObjectCategory=Person)(ObjectClass=User)(CN=*$LastName*))"
    $users = $search.FindAll()
    
    ###For each qualifying object collect and print out relevant attributes.
    foreach($user in $users) {
        $CN = $user.Properties['CN']
        $DP = $user.Properties['Department']
        $title = $user.Properties['Title']
        $manager = $user.Properties['Manager']
        $notes = $user.Properties['Notes']
        $SAM = $user.Properties['SAMAccountName']
        $enabled = $user.Properties['enabled']
        "<---------------------->"
        "CN: $CN"
        "Department: $DP"
        "Title: $title"
        "Notes: $notes"
        "Manger: $manager"
        "SAM: $SAM"
        "Enabled?: $enabled"
    }
}

###Search via SAM
function getSAM()
{
    ###Provide target SAMAccountName.
    $sSAM = Read-Host "Enter target SAM"

    ###Call ASDI to filter search on object category, class, by SAMAccountName.
    $search = [adsisearcher]"(&(ObjectCategory=Person)(ObjectClass=User)(sAMAccountName=*$sSAM*))"
    $users = $search.FindAll()
    
    ###For each qualifying object collect and print out relevant attributes.
    foreach($user in $users) {
        $CN = $user.Properties['CN']
        $DP = $user.Properties['Department']
        $title = $user.Properties['Title']
        $manager = $user.Properties['Manager']
        $notes = $user.Properties['Notes']
        $SAM = $user.Properties['SAMAccountName']
        $enabled = $user.Properties['enabled']
        "<---------------------->"
        "CN: $CN"
        "Department: $DP"
        "Title: $title"
        "Notes: $notes"
        "Manger: $manager"
        "SAM: $SAM"
        "Enabled?: $enabled"
    }
}


$search_attribute = Read-Host "
Press (s) for sAMAccountName
Press (n) for CommonName
Press (q) to exit

"
switch ($search_attribute) {
    "s" {
        getSAM
        }
    "n" {
        getCN
        }
    "q" {
        exit
        }
}

pause

###ROADMAP/WISHLIST###
#Wildcard/search capabilities
#Suggested SAMAccountName targets if target isn't found
#Error handling
#empty search return handling
#Banner!
#Command line interface w/ options
