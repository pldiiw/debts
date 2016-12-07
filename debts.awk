#!/usr/bin/awk -f

BEGIN { FS = "," }
$1 == "pld" { p = p + $2 }
$1 == "val" { v = v + $2 }
END { print "Val spent", v, "€"
      print "PLD spent", p, "€" 
      if ( p - v > 0 )
        print "PLD owe", p - v, "€ to val."
      else if ( p - v < 0 )
        print "Val owe", v - p, "€ to PLD."
      else
        print "Accounts are balanced." }
