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
        $uppercaseAlphabet = 65..90 | ForEach-Object { [char]$_ }
        $lowercaseAlphabet = 97..122 | ForEach-Object { [char]$_ }
        # and i need to import all the words
        $global:WordList = Get-Content .\NyTimesWordleList.json | ConvertFrom-Json

        # and i need the colors
        $yellow = "`e[33m"
        $green = "`e[32m"
        $lightGray = "`e[37m"
        $darkGray = "`e[90m"
        $reset = "`e[0m"

        # and for each game, i need an Answer
        $Answer = $WordList | Get-Random
        # for testing purposes i set it manually
        $Answer = 'DUDES'
        $AnswerCharArray = $answer.ToCharArray()
        # welcome banner of some sort
        Write-host 'Welcome to wordle'

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
            $Guess = read-host -Prompt "Guess $guessCounter/$maxguess! Enter a 5 letter word"
            if (New-WordleGuess -word $Guess) {
                $coloredWord = ""
                $GuessCharArray = $Guess.ToCharArray()

                for ($i = 0; $i -lt $GuessCharArray.Count; $i++) {
                    if ($AnswerCharArray[$i] -eq $GuessCharArray[$i]) {
                        # write-host 'this is GREEN'
                        $coloredWord += "${green}$($GuessCharArray[$i])${reset}"
                    }
                    else {
                        #this should do the yellows and grays
                        if ($AnswerCharArray -contains $GuessCharArray[$i]) {
                            #  write-host 'this is YELLOW.'
                            $coloredWord += "${yellow}$($GuessCharArray[$i])${reset}"
                            # missig logic for multiples
                        }
                        else {
                            # write-host 'this is GRAY'
                            $coloredWord += "${darkGray}$($GuessCharArray[$i])${reset}"
                            if ($GuessCharArray[$i] -notin $grays) {
                                [void]$grays.add($GuessCharArray[$i])
                                # list of letters that its not containing

                            }
                            

                        }
                    }

                }
                $coloredWord
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
            write-host "To many guesses, your at $guessCounter/$maxguess if you continue now!"
            write-host 'optional feature i might add. add more guessses. is that fun? like add 6 or whatnot'
        }
        
        # should be 5 characters long
        # should be in wordlist

    }
    
    end {
        
    }
}