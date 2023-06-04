# **Quake Log Parser**

### **Overview:**
QuakeParser is a ruby gem designed to parse Quake 3 Arena server log files and extract game data for further analysis.
This gem is designed to read a log file, group the game data of each match, collect kill data, generate a player ranking report, and generate a report of deaths grouped by death cause for each match.

### **Installation:**
To install the quake_parser gem, add the following line to your application's Gemfile:
```
gem 'quake_parser'
```
Then, execute:
```
bundle install
```
Or install it yourself as:
```
gem install quake_parser
```

### **Including the Gem in a Ruby Project:**
Once you have the gem installed, you can include it in your Ruby project by simply requiring it at the top of your Ruby file(s):
```
require 'quake_log_parser'
```

### **Usage:**
### Basic Usage
To use QuakeParser, you'll need to supply it with a path to a log file:
```
require 'quake_parser'

QuakeParser.run('path_to_your_log_file.log')
```

This will read the log file and print out a report for each match, as well as a global player ranking. Here is an example of a typical output:

```
{
  "game": 1,
  "total_kills": 11,
  "players": [
    "Isgalamido",
    "Mocinha"
  ],
  "kills": {
    "Isgalamido": -3,
    "Mocinha": 0
  },
  "kills_by_means": {
    "MOD_TRIGGER_HURT": 7,
    "MOD_ROCKET_SPLASH": 3,
    "MOD_FALLING": 1
  }
}
global_ranking: {
  "Mocinha": 0,
  "Isgalamido": -3
}
```

The output contains the following keys:

"game": This indicates the game number.
"total_kills": This shows the total number of kills in the game.
"players": This is an array of the player names that participated in the game.
"kills": This is an object where each key is a player's name and the corresponding value is the number of kills that the player made. Negative values indicate that the player was killed by the world a certain number of times.
"kills_by_means": This object has each method of killing as a key, and the corresponding value is the number of kills using that method.

### Advanced Usage
The quake_log_parser gem provides a variety of methods to further interact with and manipulate game data. Here are some of them:

- `add_player(name)`: Adds a new player to the game.
- `update_player_name(old_name, new_name)`: Updates a player's name.
- `increment_kill(killer, mod)`: Increments the kill count for a player.
- `decrement_kill(killed, mod)`: Decrements the kill count for a player.

#### **How it works**
QuakeParser contains four main classes: QuakeParser, Game, Main, and Parser.

QuakeParser acts as the entry point for the gem, with a single run method that takes a file path, creates a Main object, and calls its execute method.

Main is responsible for creating a Parser object and calling its parse_file method. This will read the log file line by line, creating a new Game object for each match and collecting data on each kill. After the file has been parsed, Main will print out the data for each game, as well as a global player ranking.

Game represents a single match. It keeps track of the total number of kills, the players involved, and how many kills each player made. It also records the cause of each death.

Parser is responsible for reading the log file and interpreting each line. It identifies the start of each game, the information changes of each player, and each kill event. For each kill, it will update the relevant Game object with the killer, the killed, and the cause of death.

#### **Log File Format**
Log files have a specific structure with actions being logged as they occur. A typical kill action in the log file looks like this:

```
2:22 Kill: 3 2 10: Isgalamido killed Dono da Bola by MOD_RAILGUN
````

The parts of this entry are:

- 2:22: This is the timestamp of the action, represented as minutes:seconds.
- Kill:: This signifies that the action being logged is a 'kill'.
- 3 2 10:: These are IDs related to the kill action. The first number (3) is the ID of the killer, the second number (2) is the ID of the player who was killed, and the third number (10) is the ID of the cause of death.
- Isgalamido killed Dono da Bola by MOD_RAILGUN: This is a descriptive sentence of the action that has occurred. It indicates that the player 'Isgalamido' killed the player 'Dono da Bola' using 'MOD_RAILGUN'.