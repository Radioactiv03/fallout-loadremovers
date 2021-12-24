state("falloutw")
{
    // Fallout 1 (no vars)
}

state("FALLOUT2")
{
    // Fallout 2 (no vars)
}
state("falloutwHR")
{
    // Fallout 1 (no vars)
}

state("fallout2HR")
{
    // Fallout 2 (no vars)
}

exit
{
    timer.IsGameTimePaused = true;
}

isLoading
{
    return false;
}
