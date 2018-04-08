# Get-MSOLObjectContaining
Sometimes it is not quite clear just what user/shared mailbox/distribution group is holding an email address. This script will help answer that question.

DESCRIPTION
Find MSOL Object that has the email in its address attributes. Currently covers deleted users, mailboxes, distro groups (this also covers mail enabled security groups), mail enabled users, contacts and O365 groups. 
Is a re-written form of Get-MSOLFind by Nathan Bressette https://gallery.technet.microsoft.com/office/Find-where-an-email-76950d31/, my contribution limited to explicitly requesting O365 groups rather than all groups, adding the parameter support and re-writing for simple expandability.  

Usage - needs to be dot-sourced, does not handle authentication into MSOL or Office365 so that needs to be done beforehand. 
