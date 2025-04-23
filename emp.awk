{
    if ($2 > 6000 && $3 > 4) {
        pay = $2 * $3
        print $1, pay
        total_pay += pay
        count++
    }
}
END {
    print "Total employees:", count
    if (count > 0)
        print "Average pay:", total_pay / count
    else
        print "Average pay: 0"
}