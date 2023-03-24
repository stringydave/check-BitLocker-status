# check-bitlocker-status
 check Bitlocker Status if Laptop


I just wanted something simple which I could use in scripts running on workstations to tell if
	a) it's a laptop
	b) Bitlocker is on (as it should be)

I don't at this stage care about Bitlocker Status on Desktops - because they're less likely to get lost, or Servers because I'll check them another way

I was going to get it to only show status if it's a laptop, but I can't figure out how to get PowerShell to work that way (yet), so we'll just output the type and status and process it elsewhere.