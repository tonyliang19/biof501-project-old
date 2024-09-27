/*
    This is the main entrance of the workflow for differential
    gene expression analysis
*/

process DOWNLOAD_GSE_STUDY {
    debug "${params.verbose_debug}"
    tag "${accession_code}"
    // Also publish the output file for now
    publishDir (
		path: "${params.outdir}/${task.process.tokenize(':').join('/').toLowerCase()}",
		mode: 'copy',
	)

    input:
    tuple val(accession_code), val(dummy)

    output:
    path("GSE${accession_code}.tar")

    script:
    // This is dummy approach now to try to download from GEO
    def gse_name="GSE${accession_code}"
    def link="https://www.ncbi.nlm.nih.gov/geo/download/?acc=${gse_name}&format=file"
    """
    wget -O ${gse_name}.tar ${link} 
    """
}

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

    // Process to download the GSE<accession_code> study
    DOWNLOAD_GSE_STUDY ( record )
    


}