#!/usr/bin/env python3

import sys
import json

def main():
    if len(sys.argv) < 3:
        print("Uso: process_json.py <input.json> <output.csv>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    with open(input_file, 'r') as f:
        data = json.load(f)

    with open(output_file, 'w') as out:
        out.write("id,name,role\n")
        for item in data:
            out.write(f"{item['id']},{item['name']},{item['role']}\n")

if __name__ == "__main__":
    main()
