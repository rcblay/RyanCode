/**
 * \file conf_swc.h
 * \brief This is the configuration file for the swc thread
 **/
#ifndef SRC_CONF_CONF_SWC_H_
#define SRC_CONF_CONF_SWC_H_
extern int make_ISO_compiler_happy;

#define SWC_MILLISEC 2

// DATAFILEIN for Virtualbox
#define DATAFILEIN "/home/dma/Documents/Test/input/Dynamic1/L1_201510161135_fs_4e6_if20e3_schar1bit.bin"

//L2DATAFILEIN
//#define L2DATAFILEIN "/home/dma/Documents/Test/input/Dynamic1/L2_201510161135_fs_4e6_if20e3_schar1bit.bin"


//DATAFILEOUT
#define DATAFILEOUT "/dev/null"

//OUTPUT File settings

//DATAFILEOUTNAV
#define DATAFILEOUTNAV "/dev/null"

//DATAFILEOUTLOCK
#define DATAFILEOUTLOCK "/tmp/PRNLock.bin"

//OUTPUT File settings
#ifdef USEUSB
#define APTOUT "/media/dma/2TB/NEWRUN/SHORTBinaries_%d_%d.bin"
#define KMLOUT "/media/dma/2TB/NEWRUN/GEarth.kml"
#define OBSOUT "/media/dma/2TB/NEWRUN/obsBinaries.bin"
#define RNXOUT "/media/dma/2TB/NEWRUN/NAVONLY/rnxBinaries_%d_%d.bin"
#endif


#ifdef USEFILE

#define APTOUT "/home/dma/Documents/Test/output/Dynamic1/timingaptBinaries_%d_%d.bin" //FAPT
#define KMLOUT "/home/dma/Documents/Test/output/Dynamic1/data.kml" //FKML
#define POSOUT "/home/dma/Documents/Test/output/Dynamic1/posBinaries.bin" //FPOS
#define OBSOUT "/home/dma/Documents/Test/output/Dynamic1/obsBinaries.bin" //FOBS
#define RNXOUT "/home/dma/Documents/Test/output/Dynamic1/timingrnxBinaries_%d_%d.bin" //FRNX

#endif


//SINCOSCA
// For Daehee & Sara
#define DATAFILESIN "/tmp/largeFiles/LookupTables/sinint.bin"
#define DATAFILECOS	"/tmp/largeFiles/LookupTables/cosint.bin"
#define DATAFILECATABLE "/tmp/largeFiles/LookupTables/casat%d.dat"
#define DATAFILECSTABLE "/tmp/largeFiles/LookupTables/cssat%d.dat"

// This function prints the last received error messaged and the current line
#define ERRORCHECK(a)\
		if (a)\
		{\
			perror("Error Message: ");\
			fprintf(stderr, "Error at %s line %d\n", __FILE__, __LINE__);\
			return EXIT_FAILURE;\
		}


#endif /* SRC_CONF_CONF_SWC_H_ */

