include_attribute "kagent"
include_attribute "ndb"
include_attribute "hops"

# http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2-linux-intel-x86_64.tar.gz
default['virapipe']['hmmer_url']     = node['download_url'] + "/ki/hmmer-3.1b2-linux-intel-x86_64.tar.gz"
# ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.6.0/ncbi-blast-2.6.0+-x64-linux.tar.gz
default['virapipe']['blast_url']     = node['download_url'] + "/ki/ncbi-blast-2.6.0+-x64-linux.tar.gz"
# http://derisilab.ucsf.edu/software/vFam/vFam-B_2014.hmm
default['virapipe']['vfam_url']      = node['download_url'] + "/ki/vFam-B_2014.hmm"
# wget -r ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/*
default['virapipe']['ch38_url']      = node['download_url'] + "/ki/ch38.tar.gz"
default['virapipe']['blast_url']     = node['download_url'] + "/ki/blast/"


