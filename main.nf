/*
    This is the main entrance of the workflow for differential
    gene expression analysis
*/

// TODO: This should go to cli arg, and have default option in config
params.samplesheet = "data/samplesheet.csv"

workflow {
    println "Hello World"
    /*
        Should take in a samplesheet.csv where each entry is geo accession code
        then have process to download fastq file from the accesion code

        Say format is:

        accession_code,some_other_column,...
        12345678,some_other_value,...
    */

    Channel
        .fromPath( params.samplesheet )
        .splitCsv( header: true )
        .set { record }
    
    record.view()


}