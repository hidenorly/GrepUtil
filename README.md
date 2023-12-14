# GrepUtil

This is utility for grep to make markdown table from the grep result.

# How to use?

## without grep2markdown
```
grep "hidenorly" -nr ./*                        
./grep2markdown.rb:3:# Copyright 2023 hidenorly
```

## with grep2markdown

```
$ grep "hidenorly" -nr ./* | ruby grep2markdown.rb
| path | line | result |
| :--- | :--- | :--- |
| ./grep2markdown.rb | 3 | ```# Copyright 2023 hidenorly``` |
```

You can see the output is as markdown table.
