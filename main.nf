/*
    This is the main entrance of the workflow for differential
    gene expression analysis
*/

// Including modules
include { FASTQC }                  from "./modules/local/fastqc"
include { softwareVersionsToYAML }  from "./modules/nf-core/main.nf"



workflow {
    println "Hello World"
    /*
        Should take in a samplesheet.csv where each entry is geo accession code
        then have process to download fastq file from the accesion code

        Say format is:

        accession_code,some_other_column,...
        12345678,some_other_value,...
    */

    // Initialize version file to store
    ch_versions = Channel.empty()
    
    Channel
        .fromPath( params.samplesheet )
        .splitCsv( header: true )
        .set { record }


    record.view()
    // Process to download the GSE<accession_code> study
    FASTQC ( record )    

    // Collect versions from fastqc
    ch_versions.mix ( FASTQC.out.versions )

    // Lastly collect all software versions and to YAML
    softwareVersionsToYAML(ch_versions)
        .collectFile(
            storeDir: "${params.outdir}/pipeline_info", 
            name: 'dge_analysis_versions.yml', 
            sort: true, 
            newLine: true
            )

}