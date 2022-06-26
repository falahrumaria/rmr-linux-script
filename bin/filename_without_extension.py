#!/usr/bin/python3

import sys

pure_file_names = set()
for filename in sys.argv[1:]:
    last_index = filename.rindex('.')
    pure_file_names.add(filename[:last_index])

for i in pure_file_names:
    print(i)
