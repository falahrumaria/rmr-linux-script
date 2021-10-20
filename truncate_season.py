import re
import sys

folder_names = set()
for i in sys.argv[1:]:
    folder_names.add(re.split('E\d\d', i)[0])

for i in folder_names:
    print(i)
