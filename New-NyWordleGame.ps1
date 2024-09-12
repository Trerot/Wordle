# this function validates if word is in wordlist, or if 
function New-WordleGuess {
    param (
        [ValidateScript({
                switch ($_.length) {
                    { $_ -lt 5 } { Throw "word length $_ is to few, it must be exactly 5" }
                    { $_ -eq 5 } { $true }
                    { $_ -gt 5 } { Throw "word length $_ is to long, it must be exactly 5" }
                }
                if ($global:wordlist -contains $_) {
                    $true
                }
                else {
                    Throw 'Word not in $Wordlist'
                }
                if ($Global:GuessedWords -contains $_) {
                    Throw "allready guessed $_"
                }
                else {
                    $true
                }
            })]
        [parameter(Mandatory = $true)]
        [string]$word
    )
    # now i know its a string with 5 letters in word list. 
    # add the word to guessed words and send the word out of the function for usage.
    [void]$Global:GuessedWords.add($word)
    $word
}

function New-NyWordleGame {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        # to start with, i need the alphabet.
        #$uppercaseAlphabet = 65..90 | ForEach-Object { [char]$_ }
        # $lowercaseAlphabet = 97..122 | ForEach-Object { [char]$_ }
        # and i need to import all the words
        $global:WordList = Get-Content .\NyTimesWordleList.json | ConvertFrom-Json

        # and i need the colors
        $yellow = "`e[33m"
        $green = "`e[32m"
        # $lightGray = "`e[37m"
        $darkGray = "`e[90m"
        $reset = "`e[0m"

        # and for each game, i need an Answer
        $Answer = $WordList | Get-Random
        # for testing purposes i set it manually
        #$Answer = 'daddy'
        $AnswerCharArray = $answer.ToCharArray()
        # welcome banner of some sort
        clear-host
        write-host "The great Game of Wordle!"
        $grid = "-----", "-----", "-----", "-----", "-----", "-----"
        $grid
        Write-host 'ready, set, go!'

        $guessCounter = 1
        $MaxGuess = 6
        # guessed word, avoid people guessnig same word multiple times 
        $Global:GuessedWords = New-Object -TypeName System.Collections.ArrayList
        # list of grays 
        $grays = New-Object -TypeName System.Collections.ArrayList
    }
    
    process {
        # it starts here
        while ($guesscounter -le $MaxGuess) {
            $skip = $null
            $Guess = read-host -Prompt "Guess $guessCounter/$maxguess! Enter a 5 letter word"
            if (New-WordleGuess -word $Guess) {
                $coloredWord = ""
                $uncoloredword = New-Object -TypeName System.Collections.ArrayList
                $GuessCharArray = $Guess.ToCharArray()
                #do something hear about 
                for ($i = 0; $i -lt $GuessCharArray.Count; $i++) {
                    if ($AnswerCharArray[$i] -eq $GuessCharArray[$i]) {
                        # write-host 'this is GREEN'
                        $coloredWord += "${green}$($GuessCharArray[$i])${reset}"
                        $uncoloredword.add( $GuessCharArray[$i])
                    }
                    else {
                        #this should do the yellows and grays
                        if ($AnswerCharArray -contains $GuessCharArray[$i]) {
                            #  write-host 'this is YELLOW.'
                            $answerMatches = ($AnswerCharArray | select-string $GuessCharArray[$i] -AllMatches).Matches.count

                            $guessMatches = ($GuessCharArray | select-string $GuessCharArray[$i] -AllMatches).Matches.count
                            # so if the answer contains 2, and the guess contains 1, only make the first one yellow. best bet is to set a $skip if matches a letter
                            if ($skip) {
                                $coloredWord += "${darkGray}$($GuessCharArray[$i])${reset}"
                                $uncoloredword.add( $GuessCharArray[$i])
                                $skip = $null
                            }
                            else {
                                if ( $answerMatches -eq 1 -and $guessMatches -eq 2 ) {
                                    if ($uncoloredword -contains $GuessCharArray[$i]) {
                                        # contains a green
                                        $skip = $GuessCharArray[$i]
                                        $coloredWord += "${darkGray}$($GuessCharArray[$i])${reset}"
                                    }
                                    else{
                                        # contains 2 yellow.
                                    $skip = $GuessCharArray[$i]
                                    $coloredWord += "${yellow}$($GuessCharArray[$i])${reset}"
                                    }

                                }
                                elseif($guessMatches -gt 2 -and $answerMatches -eq 1){
                                    
                                }

                                else {
                                    $coloredWord += "${yellow}$($GuessCharArray[$i])${reset}"
                                }

                                $uncoloredword.add( $GuessCharArray[$i])
                                # this fails with one green, L, means i get one Green and one Yellow L, even though answer only has 1
                            }
                        }
                        else {
                            # write-host 'this is GRAY'
                            $coloredWord += "${darkGray}$($GuessCharArray[$i])${reset}"
                            $uncoloredword.add( $GuessCharArray[$i])
                            if ($GuessCharArray[$i] -notin $grays) {
                                [void]$grays.add($GuessCharArray[$i])
                                # list of letters that the word is not containing

                            }
                        }
                    }

                }
                Clear-Host
                write-host "The great Game of Wordle!"
                $grid[($guesscounter - 1)] = $coloredWord
                $grid
                $string = ""
                $grays | sort-object | foreach-object { $string += "$_ " } 
                write-host "Not in word: $($string.ToUpper())"
                #ANswer is here!
                if ($Answer -eq $guess) {
                    Write-host "Winner winner chicken dinner"
                    write-host "the answer was $answer and you made it in $guessCounter guesses"
                    break
                }
                $guessCounter ++

            }
        }
        #loop is broken here, so its to long.
        if ($guessCounter -gt $MaxGuess) {
            write-host "Failed!"
            write-host "Answer: $answer"
            # write-host 'optional feature i might add. add more guessses. is that fun? like add 6 or whatnot'
        }
    }
    
    end {
        
    }
}