{
    status = "Pass"
    for (i = 2; i <= NF; i++) {
        if ($i < 45) {
            status = "Fail"
            break
        }
    }
    print $1, status
}