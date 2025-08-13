from collections import defaultdict
import sys

def read_fasta(filename):
    seq = []
    with open(filename) as f:
        for line in f:
            if line.startswith('>'):
                continue
            seq.append(line.strip())
    return ''.join(seq)

def count_kmers(sequence, k):
    freq = defaultdict(int)
    for i in range(len(sequence) - k + 1):
        kmer = sequence[i:i+k]
        freq[kmer] += 1
    return freq

def main():
    if len(sys.argv) != 3:
        print(f"Usage: python {sys.argv[0]} <fasta_file> <k>")
        sys.exit(1)
    fasta_file = sys.argv[1]
    k = int(sys.argv[2])
    sequence = read_fasta(fasta_file)
    kmer_counts = count_kmers(sequence, k)
    for kmer, count in sorted(kmer_counts.items()):
        print(f"{kmer}\t{count}")

if __name__ == "__main__":
    main()
