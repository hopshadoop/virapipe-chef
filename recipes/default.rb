
include_recipe "java"

#hops_groups()

package 'unzip'

bash 'jbwa' do
  user "root"
  code <<-EOF
    set -e
    export JAVA_HOME=/usr/lib/jvm/default-java
#    cd #{Chef::Config['file_cache_path']} 
    mkdir -p #{node['hops']['base_dir']}/lib/native

    cd /usr/local
    git clone https://github.com/lindenb/jbwa
    cd jbwa
    make
    cp src/main/native/libbwajni.so #{node['hops']['base_dir']}/lib/native
  EOF
  not_if { File.directory?("#{node['hops']['base_dir']}/lib/native/libbwajni.so") }    
end


bash 'megahit' do
  user "root"
  code <<-EOF
    set -e
    export JAVA_HOME=/usr/lib/jvm/default-java
    cd /usr/local
    git clone https://github.com/voutcn/megahit
    cd megahit
    make
    ln -s /usr/local/megahit/bin/megahit /usr/bin/megahit
  EOF
  not_if { File.directory?("/usr/local/megahit") }  
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
  not_if { File.directory?("/usr/local/hmmer") }  
end


bash 'blastdb' do
  user "root"
  code <<-EOF
    set -e
    export JAVA_HOME=/usr/lib/jvm/default-java
       cd #{Chef::Config['file_cache_path']} 
       mkdir -p database
       cd database
       for i in {0..9}; do wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.0$i.tar.gz ; done
       for i in {10..50}; do wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.$i.tar.gz ; done
       for i in {0..9}; do wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/human_genomic.0$i.tar.gz ; done
       for i in {10..22}; do wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/human_genomic.$i.tar.gz ; done
       wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz
       cat *.gz | tar -xzvf - -i
       cd ..
       mkdir -p /var/blastdb
       mv database /var/blastdb
       # create database dir
       mkdir -p /database/blast/nt
       mkdir -p /database/blast/hg
       mkdir -p /database/blast/taxdb
       chmod -R 775 /database
       chown -R #{node['hops']['yarnapp']['user']}:#{node['hops']['group']} /var/blastdb
       chown -R #{node['hops']['yarnapp']['user']}:#{node['hops']['group']} /database

  EOF
  not_if { File.directory?("/var/blastdb/database") }  
end


magic_shell_environment 'BLASTDB' do
  value "/database"
end
