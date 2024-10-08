$guess = 'sddxd'
#$guess = 'depth'
$answer = 'dudes'


$GreenArray = New-Object -TypeName System.Collections.ArrayList
$YellowArray = New-Object -TypeName System.Collections.ArrayList
$GrayArray = New-Object -TypeName System.Collections.ArrayList
#for those pesky ones. 
$NeutralArray = New-Object -TypeName System.Collections.ArrayList


for ($i = 0; $i -lt $Answer.Length; $i++) {
    $GuessLoc = ($guess | select-string $guess[$i] -AllMatches).matches
    $AnswerLoc = ($answer | select-string $guess[$i] -AllMatches).matches
    
    # this sorts all greens.
    $greens = $answerloc.where({ $_.index -in $GuessLoc.index -and $_.Index -notin $GreenArray.index })
    $greens.foreach({
            $GreenArray.add($_)
        })

    # this sorts all grays
    if ($null -eq $AnswerLoc) {
        $GuessLoc.foreach({
                $GrayArray.add($_)
            })
    }
    # the rest is yellow, or a neutral.
    if ($AnswerLoc -ne $null -and $i -notin $GreenArray.Index -and $i -notin $GrayArray.Index) {
        # non null answerloc, and not in green, must be yellow i think.
        # this just adds all not green and not null.
        # if the guessloc is gt
        $guesslocCounter = 0
        $guessloc.ForEach({
                # this removes dupes
                if ($_.Index -notin $YellowArray.Index) {
                    $YellowArray.add($_)
                }
            })
    }
}

# there can never be more yellows than the amount in the answer.
# there can never be more yellows+ greens than the amount in answer.
# always pop the last yellow.

# this creates the correct amount
# this removes the yellows at the greens
$YellowArray = $YellowArray.where({ $_.index -notin $GreenArray.index })


for ($i = 0; $i -lt $Answer.Length; $i++) {
    $GuessLoc = ($guess | select-string $guess[$i] -AllMatches).matches
    $AnswerLoc = ($answer | select-string $guess[$i] -AllMatches).matches

    $inyellows = $YellowArray.where($_.value -eq $guess[$i])
    $ingreens = $greenArray.where($_.value -eq $guess[$i])
    if ($inyellows.count -gt $AnswerLoc.count) { "something is up here" }
    if (($inyellows.count + $ingreens.count) -gt $AnswerLoc.count) { "something is up here 2" }


}
Enable-NetworkSwitchEthernetPort