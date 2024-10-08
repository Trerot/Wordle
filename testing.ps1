$guess = "daddy"
$answer = 'sodic'
$AnswerCharArray = $answer.ToCharArray()
$GuessCharArray = $guess.ToCharArray()
$resultHash = @{}
# green and gray loop
for ($i = 0; $i -lt $answer.Length; $i++) {
    $answercount = ($answer | Select-String $guess[$i] -AllMatches).Matches.count
    $guesscount = ($guess | Select-String $guess[$i] -AllMatches).Matches.count
    # the greens
    if ($answer[$i] -eq $guess[$i]) {
        $resultHash.add(
            $i, [PSCustomObject]@{
                Letter = $answer[$i]
                color  = 'green'
                index  = $i
            })
    }
    # the grays
    elseif ($guess[$i] -notin $AnswerCharArray) {
        $resultHash.add(
            $i, [PSCustomObject]@{
                Letter = $answer[$i]
                color  = 'gray'
                index  = $i
            })
    }
    # this is straight up singular no worries yellow.
    elseif ($answercount -eq 1 -and $guesscount -eq 1 ) {
        $resultHash.add(
            $i, [PSCustomObject]@{
                Letter = $answer[$i]
                color  = 'yellow'
                index  = $i
            })
    }
    else {
# this is the rest, i dont know how to do it in the same loop.
    }

}
$remainders = (1,2,3,4,5).where({$_ -notin $resultHash.Keys})
# next loop. $resulthash.keys has the set numbers.
foreach ($i in $remainders) {
    # now im only checking the remainders.
    $answercount = ($answer | Select-String $guess[$i] -AllMatches).Matches.count
    $guesscount = ($guess | Select-String $guess[$i] -AllMatches).Matches.count
    if($answercount -eq 1 -and $guesscount -ge 2 -and $guess[$i] -in $resultHash.Values.letter){
        # gray.
    }
    if($answercount -eq 2 -and $guesscount -eq 2 -and $guess[$i] -in $resultHash.Values.letter){
        # yellow 
        # one of them is green or gray or yellow. I think this has to be yellow. 
    }
    if($answercount -eq 3 -and $guesscount -eq 1 -and $guess[$i] -notin $resultHash.Values.letter){
        # Yellow
        # 3, 1 bet. yellow only posibily, since its not gray or green.
    }
    if($answercount -eq 3 -and $guesscount -eq 2 -and $guess[$i] -notin $resultHash.Values.letter){
        # 3, 2 bet. none are green, 
    }



}
$resultHash