/**
 * \file conf_swc.h
 * \brief This is the configuration file for the swc thread
 **/
#ifndef SRC_CONF_CONF_SWC_H_
#define SRC_CONF_CONF_SWC_H_
extern int make_ISO_compiler_happy;

#define SWC_MILLISEC 2

// DATAFILEIN for Virtualbox
#define DATAFILEIN "/home/dma/Documents/Test/input/Static_6864e6/MAX2769_L1_20150828_20150831_fs_6864e6_if21912e6_schar_20GB.bin"

//L2DATAFILEIN
//#define L2DATAFILEIN "/home/dma/Documents/Test/input/Static_6864e6/MAX2769_L2_20150828_20150831_fs_6864e6_if21912e6_schar_20GB.bin"


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

#define APTOUT "/home/dma/Documents/Test/output/Static/timingaptBinaries_%d_%d.bin" //FAPT
#define KMLOUT "/home/dma/Documents/Test/output/Static/data.kml" //FKML
#define POSOUT "/home/dma/Documents/Test/output/Static/posBinaries.bin" //FPOS
#define OBSOUT "/home/dma/Documents/Test/output/Static/obsBinaries.bin" //FOBS
#define RNXOUT "/home/dma/Documents/Test/output/Static/timingrnxBinaries_%d_%d.bin" //FRNX

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

