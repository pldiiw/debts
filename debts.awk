#!/usr/bin/awk -f

BEGIN { FS = "," }

$1 == "pld" { p += $2 }
$1 == "val" { v += $2 }
{ "date -d "$3" +%B" | getline month
  monthly[month][$1] += $2
  categorically[$1][$4] += $2 }

END { print "Val spent "v"€"
      print "PLD spent "p"€"
      if ( p - v > 0 )
        print "PLD owe "p - v"€ to val."
      else if ( p - v < 0 )
        print "Val owe "v - p"€ to PLD."
      else
        print "Accounts are balanced."

      print ""

      if ( verbose == 1 ) {
        print "Here's the detail:"

        print "  Spendings per month:"
        for ( month in monthly ) {
          print "    In "month":"
          for ( who in monthly[month] ) {
            print "      "who" spent "monthly[month][who]"€."
          }
        }

        print "  Spendings by category:"
        for ( who in categorically ) {
          print "    By "who":"
          for ( category in categorically[who] ) {
            print "      "categorically[who][category]"€ in "category"."
          }
        }
      }
    }
