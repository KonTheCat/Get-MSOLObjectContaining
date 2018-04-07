function Get-MSOLObjectContaining 
{

<#
.SYNOPSIS
    Find MSOL Object that has the email in its address attributes. Need to be connected to O365 Exchange and Azure AD. 
.DESCRIPTION
    Find MSOL Object that has the email in its address attributes. Currently covers deleted users, mailboxes, distro groups (this also covers mail enabled security groups), mail enabled users, contacts and O365 groups. 
    Is a re-written form of Get-MSOLFind by Nathan Bressette https://gallery.technet.microsoft.com/office/Find-where-an-email-76950d31/, my contribution limited to explicitly 
    requesting O365 groups rather than all groups, adding the parameter support and re-writing for simple expandability.  
.EXAMPLE
    Get-MSOLObjectContaining -Email test@test.com
#>

    [CmdletBinding()]
    Param(
    [Alias("Email")]
    [Parameter(Mandatory=$True)]
    [string]$Address
)
#append "smtp:"
$Address = "smtp:" + $Address

#search deleted users 
$DeletedOwners = Get-MSOLUser -All -ReturnDeletedUsers | Where-Object {$_.ProxyAddresses -like $Address}
If ($DeletedOwners)
    {
        write-host "The address you are looking for is assigned to deleted object(s) named" $DeletedOwners.DisplayName -ForegroundColor DarkGreen -BackgroundColor Black
        write-host "Now continuiing search of non-deleted items (it may be assigned to multiple owners)" -ForegroundColor DarkGreen -BackgroundColor Black
    }
    ELse 
        {
            write-host "The address does not belong to a deleted user, now searching non-deleted items" -ForegroundColor DarkGreen -BackgroundColor Black
        }

#search mailboxes
$MailboxOwners = Get-Mailbox -ResultSize Unlimited | Where-Object {$_.EmailAddresses -like $Address}
if ($MailboxOwners)
    {
        Write-Host "The email address belongs to a mailbox named " $MailboxOwners.DisplayName -ForegroundColor DarkGreen -BackgroundColor Black
        $MailboxOwners | Format-List
    }

#search distribution groups
$GroupOwner = Get-DistributionGroup -ResultSize Unlimited | Where-Object {$_.EmailAddresses -like $Address}
if ($GroupOwner)
    {
        Write-Host "The email address belongs to a distribution group named " $GroupOwner.DisplayName -ForegroundColor DarkGreen -BackgroundColor Black
        $GroupOwner | Format-List
    }

#search mail enabled users
$MailUserOwner = Get-MailUser -ResultSize Unlimited | Where-Object {$_.EmailAddresses -like $Address}
if ($MailUserOwner)
    {
        Write-Host "The email address belongs to a mail enabeld user named " $MailUserOwner.DisplayName -ForegroundColor DarkGreen -BackgroundColor Black
        $MailUserOwner | Format-List
    }

#search mail contacts
$ContactOwner = Get-MailContact -ResultSize Unlimited | Where-Object {$_.EmailAddresses -like $Address}
if ($ContactOwner)
    {
        Write-Host "The email address belongs to a mail contact named " $ContactOwners.DisplayName -ForegroundColor DarkGreen -BackgroundColor Black
        $ContactOwner | Format-List
    }

#search O365 Groups 
$OffGroup = Get-UnifiedGroup | where-object {$_.EmailAddresses -like $address}
if ($OffGroup) 
    {
        Write-Host "The address belongs to an Office 365 Group named" $OffGroup.DisplayName -ForegroundColor DarkGreen -BackgroundColor Black
        $OffGroup | Format-list 
    }
} #end of Get-MSOLObjectContaining
