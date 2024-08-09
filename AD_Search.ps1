###Main menu
function showMenu()
{
    $selection = Read-Host "
        Press (s) for sAMAccountName
        Press (n) for CommonName
        Press (q) to exit
        "
    switch ($selection) {
        "s" {
            getSAM
        }
        "n" {
            getCN
        }
        "q" {
            exit
        }
        default {
            "Try again..."
            ShowMenu
        }
    }
}


###Search via last name via CN atrribute
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
    Write-Host "
    End of search results..."
    Pause
    ShowMenu
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
    Write-Host "
    End of search results..."
    Pause
    ShowMenu
}

ShowMenu

###ROADMAP/WISHLIST###
#Suggested SAMAccountName targets if target isn't found
#Error handling
#Empty search return handling
#Banner!
