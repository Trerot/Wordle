# wordlist taken from nytimes assets
$nyTimesJs = Invoke-RestMethod https://www.nytimes.com/games-assets/v2/wordle.01277c06b8349a28c4ed9a9282e0b205c6b00cf8.js
# convert it to a ps list
$PsWordleList  = $nyTimesJs.split("it=[")[1].split('];')[0].split(',').Replace('"',"")
# convert it and save it as a json
$PsWordleList | ConvertTo-Json | set-content -Force 'NyTimesWordleList.json'
# now its here as a json for the masses!