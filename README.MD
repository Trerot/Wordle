- NyTimesWordleList.json has the wordlelist taken from nytimes wordle
https://www.nytimes.com/games-assets/v2/wordle.01277c06b8349a28c4ed9a9282e0b205c6b00cf8.js

- generate a new list using New-WordleWordList.ps1 if you feel like updating the list with something new
- CommonWordList.json has for now 100 words, taken from this page, might update and change its content after a a while 
https://word-lists.com/word-lists/100-most-common-5-letter-words/

## wordle rules
- Green is correct location
- Yellow is wrong location, but word contains the letter
- Gray is word does not contain letter.
- double letter rules.
    - DUDES, correct word is xDxxx, only first D is yellow. second D is gray.
    - DUDES, correct word is xDxDx, you get two yellow D's, since correct word contains two D's but they are both in wrong location
    - DUDES, correct word is DxxDx, you get one green and one yellow D.
