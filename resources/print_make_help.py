import re, sys

with open(sys.argv[1], 'r') as f:
    for line in f:
        if "##" in line:
            target, help = line.split(":")
            target = target.strip()
            help = help.split("##")[1].strip()
            print("%-20s %s" % (target, help))
