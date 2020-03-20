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
import seaborn as sns


def main():
    parser = argparse.ArgumentParser(description=__description__)
    parser.add_argument("--input_file", required=True)
    parser.add_argument("--output_pdf", required=True)
    parser.add_argument("--output_txt", required=True)
    args = parser.parse_args()

    seq_lengths = [
        len(seq_record) for seq_record in SeqIO.parse(args.input_file, "fasta")
    ]

    generate_histogram(seq_lengths, args.output_pdf)
    generate_report(seq_lengths, args.output_txt)


def generate_histogram(seq_lengths, output_pdf):
    hist_plot = sns.distplot(seq_lengths, kde=False, rug=True)
    fig = hist_plot.get_figure()
    fig.savefig(output_pdf)


def generate_report(seq_lengths, output_txt):
    long_seqs = filter(lambda lenght: lenght > 25000, seq_lengths)
    with open(output_txt, "w") as output_fh:
        output_fh.write(
            f"Number of sequences: {len(seq_lengths)}\n"
            f"Minimal seq length: {min(seq_lengths)}\n"
            f"Maximum seq length: {max(seq_lengths)}\n"
            f"Number of seqs over 25 kb: {len(list(long_seqs))}\n"
        )


if __name__ == "__main__":
    main()
