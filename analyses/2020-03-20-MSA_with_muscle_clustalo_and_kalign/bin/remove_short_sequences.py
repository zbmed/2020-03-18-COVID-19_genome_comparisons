#!/usr/bin/env python
"""
FUNCTION: 

USAGE: 

Copyright (c) 2020, Konrad Foerstner <konrad@foerstner.org>

Permission to use, copy, modify, and/or distribute this software for
any purpose with or without fee is hereby granted, provided that the
above copyright notice and this permission notice appear in all
copies.

THE SOFTWARE IS PROVIDED 'AS IS' AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
         
"""
__description__ = ""
__author__ = "Konrad Foerstner <konrad@foerstner.org>"
__copyright__ = "2020 by Konrad Foerstner <konrad@foerstner.org>"
__license__ = "ISC license"
__email__ = "konrad@foerstner.org"
__version__ = ""

import argparse
from Bio import SeqIO


def main():
    parser = argparse.ArgumentParser(description=__description__)
    parser.add_argument("--input", required=True)
    parser.add_argument("--min_length", type=int, required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    with open(args.output, "w") as output_fh:
        for seq_record in SeqIO.parse(args.input, "fasta"):
            if len(seq_record) < args.min_length:
                continue
            output_fh.write(f">{seq_record.id}\n{str(seq_record.seq)}\n")


if __name__ == "__main__":
    main()
