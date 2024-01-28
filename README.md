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


# mdtable-agrregator.rb

This can agrregate the result, which is intended for md-diff

```
| col1 | col2 |
| :--- | :--- |
| key1 | val1 |
| key1 | val2 |
```

If the above markdown table is input, the output is the following:

```
| col1 | col2 |
| :--- | :--- |
| key1 | val1 <br> val2 |
```

Same key's values are agrregated as one line and separated by ``` <br> ```.
