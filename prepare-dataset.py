#!/usr/bin/env python3
import sys
import yaml

def main(args):
    with open("./dataset.yml") as f:
        contents = yaml.safe_load(f)

    with open("metadata.csv", "w") as f:
        for (path,line) in contents[args.team].items():
            path = path[2:]
            f.write(path + "|" + line + "\n")

    exit(0)

def cli():
    import argparse
    parser = argparse.ArgumentParser(description="Convert dataset to metadata.csv")

    parser.add_argument("team", type=str, help="")

    args = parser.parse_args(sys.argv[1:])
    main(args)

if __name__ == "__main__":
    cli()
