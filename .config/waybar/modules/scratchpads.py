#!/usr/bin/python
import json
import subprocess
import sys

def findScratchpads(sway_tree: str) -> int:
    data = json.loads(sway_tree)
    scratchpad_count = len(data["nodes"][0]["nodes"][0]["floating_nodes"])
    return scratchpad_count

print(findScratchpads(sys.stdin.read()))
