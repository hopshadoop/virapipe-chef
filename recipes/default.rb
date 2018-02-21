
include_recipe "java"

#hops_groups()

package 'unzip'

bash 'jbwa' do
  user "root"
  code <<-EOF
    set -e
    export JAVA_HOME=/usr/lib/jvm/default-java
    #mkdir -p #{node['hops']['base_dir']}/lib/native
    cd /usr/local
    rm -rf jbwa
    git clone https://github.com/lindenb/jbwa
    cd jbwa
    make
    chmod +x jbwa.jar
    cp src/main/native/libbwajni.so #{node['hops']['base_dir']}/lib/native
    chown #{node['hops']['yarnapp']['user']}:#{node['hops']['group']} #{node['hops']['base_dir']}/lib/native/libbwajni.so
  EOF
  not_if { ::File.exist?("#{node['hops']['base_dir']}/lib/native/libbwajni.so") }    
end


# bash 'megahit' do
#   user "root"
#   code <<-EOF
#     set -e
#     export JAVA_HOME=/usr/lib/jvm/default-java
#     apt-get install build-essential -y
#     cd /usr/local
#     git clone https://github.com/voutcn/megahit
#     cd megahit
#     make
#     ln -s /usr/local/megahit/megahit /usr/bin/megahit
#   EOF
#   not_if { File.directory?("/usr/bin/megahit") }  
# end


bash 'megahit' do
  user "root"
  code <<-EOF
      set -e
      rm -f /usr/bin/megahit
      ln -s /usr/local/megahit/megahit /usr/bin/megahit
  EOF
end


hmmer =  File.basename(node['virapipe']['hmmer_url'])
hmmer_package =  File.basename(hmmer, ".tar.gz")

vfam_url = node['virapipe']['vfam_url']
vfam =  File.basename(node['virapipe']['vfam_url'])


bash 'hmmer' do
  user "root"
  code <<-EOF
    set -e
    export JAVA_HOME=/usr/lib/jvm/default-java
    cd /usr/local
    wget #{node['virapipe']['hmmer_url']}
    tar zxf #{hmmer}
    cd #{hmmer_package}
    ln -s /usr/local/#{hmmer_package} /usr/local/hmmer
    mkdir -p /database/hmmer
    cd /database/hmmer
    wget #{vfam_url}
  EOF
  not_if { ::File.directory?("/database/hmmer") }  
end


bash 'blastdb' do
  user "root"
  code <<-EOF
    set -e
    export JAVA_HOME=/usr/lib/jvm/default-java
       cd #{Chef::Config['file_cache_path']} 
       mkdir -p database
       cd database
       rm -rf *.1
       rm -rf *.2
       for i in {0..9}; do [ -f nt.0$i.tar.gz ] && echo "found nt.0$i.tar.gz" || wget #{node['virapipe']['blast_url']}/nt.0$i.tar.gz ; done
       for i in {10..50}; do [ -f nt.$i.tar.gz ] && echo "found nt.$i.tar.gz" || wget #{node['virapipe']['blast_url']}/nt.$i.tar.gz ; done
# Notice: {0..9} fails (from ViraPipe docs), as '9' is not found
       for i in {0..8}; do [ -f human_genomic.0$i.tar.gz ] && echo "found human_genomic.0$i.tar.gz" || wget #{node['virapipe']['blast_url']}/human_genomic.0$i.tar.gz ; done
       for i in {10..16}; do [ -f human_genomic.$i.tar.gz ] && echo "found human_genomic.$i.tar.gz" || wget #{node['virapipe']['blast_url']}/human_genomic.$i.tar.gz ; done
# Notice: {17} fails (from ViraPipe docs), as '17' is not found
       for i in {18..22}; do [ -f human_genomic.$i.tar.gz ] && echo "found human_genomic.$i.tar.gz" || wget #{node['virapipe']['blast_url']}/human_genomic.$i.tar.gz ; done
       [ -f taxdb.tar.gz ] && echo "found taxdb.tar.gz" || wget #{node['virapipe']['blast_url']}/taxdb.tar.gz
  EOF
  not_if { ::File.exist?("#{Chef::Config['file_cache_path']}/database/taxdb.tar.gz") }  
end

bash 'blastdb_extract' do
  user "root"
  code <<-EOF
    set -e
    export JAVA_HOME=/usr/lib/jvm/default-java
       cd #{Chef::Config['file_cache_path']} 
       cd database
       ls * | grep -v '.gz' | rm -f || echo "database was clean"
       cat *.gz | tar -xzvf - -i
       cd ..
       mkdir -p /database
       # create database dir
       mkdir -p /database/blast/nt
       mkdir -p /database/blast/hg
       mkdir -p /database/taxdb
       mv -f database/human_genomic* /database/blast/hg
       mv -f database/nt* /database/blast/nt
       mv -f database/taxdb* /database/taxdb
       chmod -R 775 /database
       chown -R #{node['hops']['yarnapp']['user']}:#{node['hops']['group']} /database
       touch /database/.installed
  EOF
  not_if { ::File.exist?("/database/.installed") }  
end


magic_shell_environment 'BLASTDB' do
  value "/database/blast/nt:/database/blast/hg:/database/taxdb"
end


bash 'human_genomic' do
  user "root"
  code <<-EOF
    set -e
    mkdir -p /index
    cd /index
    wget -R ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/*
    touch /index/.indexes_downloaded
  EOF
  not_if { ::File.exist?("/index/.indexes_downloaded") }  
end
