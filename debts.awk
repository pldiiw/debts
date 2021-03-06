#!/usr/bin/awk -f

BEGIN { FS = "," }

$1 == "pld" { p += $2 }
$1 == "val" { v += $2 }
{ date = "date -d "$3" '+%B %Y'"
  date | getline month_and_year
  close(date)
  monthly[month_and_year][$1] += $2
  categorically[$1][$4] += $2 }

END { print "Val spent "v"€"
      print "PLD spent "p"€"
      if ( p < v )
        print "PLD owe "v - p"€ to val."
      else if ( p > v )
        print "Val owe "p - v"€ to PLD."
      else
        print "Accounts are balanced."

      if ( verbose == "y" ) {
        print "\nHere's the detail:"

        print "  Spendings per month:"
        for ( month_and_year in monthly ) {
          print "    In "month_and_year":"
          total_for_month = 0
          for ( who in monthly[month_and_year] ) {
            spent = monthly[month_and_year][who]
            print "      "who" spent "spent"€."
            total_for_month += spent
          }
          print "      Total: "total_for_month"€."
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
