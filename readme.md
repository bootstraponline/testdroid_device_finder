# testdroid device finder

A port of the [testdroid device finder](https://github.com/bitbar/testdroid-samples/blob/03fc043ba98235b9ea46a0ab8646f3b20dd1960e/appium/sample-scripts/python/device_finder.py)
for Ruby.

```
export TESTDROID_USERNAME="..."
export TESTDROID_PASSWORD="..."
```

- `python device_finder_example.py`
- `ruby device_finder_example.rb`

```
$ python device_finder_example.py 
Searching Available Free iOS Device...
Found device 'iPhone 4S A1387 6.1.3'

Searching Available Free Android Device...
Found device 'Samsung Galaxy Nexus GT-I9250 4.2.2'
```

```
$ ruby device_finder_example.rb 
Searching Available Free iOS Device...
Found device iPhone 4S A1387 6.1.3

Searching Available Free Android Device...
Found device Samsung Galaxy Nexus GT-I9250 4.2.2
```
