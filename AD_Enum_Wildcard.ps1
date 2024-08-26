### Wildcard search against your own specified object class and common name string. Don't use this, it sucks.

$class = Read-Host "Desired object class"
$string = Read-Host "Enter string to search against"

$searcher = [adsisearcher]"(&(objectclass=$class)(name=*$string*))"
$group = $searcher.FindAll()
$searcher.FindAll() | Measure-Object

if ($group -ne $null) {
    foreach ($object in $group) {
        $CN = $object.Properties["distinguishedname"][0]
        Write-Host "Object found: $CN"
        $member = $object.Properties["member"]
        if ($member -ne $null) {
            Write-Host "    Member(s): $member 
        "
        }
    }
} else {
    Write-Host "Object not found searching against wildcard string '$string'."
}

