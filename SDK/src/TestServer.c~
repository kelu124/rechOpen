#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <arpa/inet.h>
#include <time.h>

#include <unistd.h>

#include <errno.h>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/uio.h>

#include "rp.h"

#define BUFLEN 16384  //Max length of buffer // 16*1024
#define PORT 7536   //The port on which to listen for incoming data

double SMAX = 0.255;
double SMIN = -0.255;

    int tbuff, i,j  = 0;
    int CheckUDP = 0;

// preparing the UDP connection

//
// ASUS : 192.168.1.47
// Port : 8888
//

void die(char *s)
{
    perror(s);
    exit(1);
}


// Pitaya code in itself
int main(int argc, char **argv){
	//int PORT = 7536;
	printf("DEBUG COMMENCE\n");
	/* Initialize UDP */
	struct sockaddr_in si_me, si_other;
	int s;
	int slen = sizeof(si_other);
	//char buf[BUFLEN];
	//create a UDP socket
	if ((s=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1)
	{
	die("socket");
	}
	//#DEBUG printf("Socket OK\n"); 
	// zero out the structure
	memset((char *) &si_me, 0, sizeof(si_me));
	si_me.sin_family = AF_INET;
	si_other.sin_family = AF_INET;
	si_me.sin_port = htons(PORT); // Port
	si_other.sin_port = htons(PORT);

	si_other.sin_addr.s_addr = inet_addr("192.168.1.23"); //specific binding to listenser
	//si_me.sin_addr.s_addr = htonl(INADDR_ANY);
	//bind socket to port
	if( bind(s , (struct sockaddr*)&si_me, sizeof(si_me) ) == -1){
		die("bind");
	}


	/* End of UDP initialization */
	//#DEBUG printf("UDP OK\n"); 
	/*number of acquision*/
	uint32_t N = 64;
	/*size of the acquisition buffer*/
	uint32_t buff_size = 16384;
	uint32_t HalfSignal = buff_size/2;
	/*allocation of buffer size in memory*/
	float *buff = (float *)malloc(buff_size * sizeof(float));
	int *ibuff = (int *)malloc(buff_size * sizeof(int));

	/*initialise to 0 the buffer*/
	for (int i=0 ; i<buff_size ; i++){buff[i]=0.0;}

	/* Print error, if rp_Init() function failed */
	if(rp_Init() != RP_OK){
		fprintf(stderr, "Rp api init failed!\n");
	}

	/* decimation n (=1,8,64...) : frequency = 125/n MHz*/
	rp_AcqSetDecimation(RP_DEC_1);


	//#DEBUG printf("Pretrigger\n");
	/*init trigger state*/
	rp_acq_trig_state_t state = RP_TRIG_STATE_TRIGGERED;

	for (int i=0 ; i<N ; i++) {

		/*start acquisition must be set before trigger initiation*/
		rp_AcqStart();

		/*allocation of temporary buffer size in memory*/
		float *temp = (float *)malloc(buff_size * sizeof(float));

		/*trigger source*/
		rp_AcqSetTriggerSrc(RP_TRIG_SRC_CHB_NE);

		/*level of the trigger activation in volt*/
		rp_AcqSetTriggerLevel(-0.03); 

		/*acquisition trigger delay*/
		rp_AcqSetTriggerDelay(HalfSignal);

		/*waiting for trigger*/
		while(1){
			rp_AcqGetTriggerState(&state);
			if(state == RP_TRIG_STATE_TRIGGERED){
				break;
			}
		}		

		/*putt acquisition data in the temporary buffer*/
		rp_AcqGetOldestDataV(RP_CH_2, &buff_size, temp);

		/*additionning the N signals*/
		for (int j = 0; j < buff_size; j++){
			buff[j]+=temp[j];
		}

		/*release memory*/
		free(temp);
	}
	
	double MoyenneFichier = 0;
	for (int i=HalfSignal ; i<buff_size ; i++) {
		MoyenneFichier += buff[i];	
	}
	MoyenneFichier = MoyenneFichier / HalfSignal;


	//#DEBUG printf("Size of INT : %i\n",sizeof(int));
	//#DEBUG printf("Fichier ouvert\n");
	/*open file and write the mean signal*/
	FILE * fm;

 	fm = fopen ("moy.txt", "w+");
	double ttmp = 0;
	//int RAWData = 0;



	/*Nettoyage et simplification du signal */
	for (int i=0 ; i<buff_size ; i++) {
		
		ttmp = buff[i]- MoyenneFichier;
		/* Ecretage moche */
		if(ttmp > (SMAX)){
			ttmp = SMAX;
		}
		if(ttmp < (SMIN)){
			ttmp = SMIN;
		}
		/* Fin ecretage */
		ibuff[i] = (int)(1000*ttmp);
	}
	/* End of cleaning*/

	for (int i=0 ; i<buff_size ; i++) {
		fprintf(fm, "%i\n", ibuff[i]);
	}
	fclose(fm);
	//#DEBUG printf("Fichier ferme\n");

	//Check taille des donnes	
	//printf("Taille des donnees: %d\n",sizeof(RAWData)*buff_size);


	/* sending to UDP */
	int DATA_Line = 0; // Number of the line in the image (ie 1 to 40 in our case)
	int DATA_Image = 0; //Number of the image in the acq 
	int MaxDataPerPacket = 256*4; // (in bytes)
	uint32_t DATA_Position = 0; 	// Position of the packet in the line  - 0 to 255
				// 256 packets of 256 bytes deliver 16k*4bytes of info
	int NbOfPacket = buff_size * sizeof(int)/MaxDataPerPacket; // nombre de packets
	int MaxPointsPerPacket = MaxDataPerPacket/sizeof(int);

	int SizeOfPacket = sizeof(DATA_Line)+sizeof(DATA_Image)+sizeof(DATA_Position);
	SizeOfPacket += MaxPointsPerPacket * sizeof(int);
	
	printf("buff number of points : %i\n",buff_size);
	printf("Port : %i\n",PORT);
	printf("MaxPointsPerPacket : %i\n",MaxPointsPerPacket);
	printf("MaxDataPerPacket : %i\n",MaxDataPerPacket);
	printf("Taille packet : %i\n",SizeOfPacket);
	printf("Nombre packet : %i\n",NbOfPacket);
	
	int TaillerBuffer = SizeOfPacket * sizeof(int);
	printf("TaillerBuffer : %i\n",TaillerBuffer);
	uint32_t UDPBuffer[MaxPointsPerPacket+3];

uint32_t iToBuff[buff_size];
for (int i = 0 ; i < buff_size ; ++i) {
    iToBuff[i] = htonl(ibuff[i]) ;
}


	for (i=0 ; i < NbOfPacket ; i++) { // iteration sur l'ensemble des packets du buffer
		UDPBuffer[0] = htonl(i);
		UDPBuffer[1] = htonl(DATA_Line);
		UDPBuffer[2] = htonl(DATA_Image);

		for (j=0; j < MaxPointsPerPacket ; j++){ // iteration par points du packet
			UDPBuffer[3+j] = iToBuff[i*MaxPointsPerPacket+j];
		}

		CheckUDP = sendto(s,UDPBuffer,sizeof(UDPBuffer),0,(struct sockaddr*) &si_other,slen);
		
		usleep(2);

		if (CheckUDP==-1) {
		    die("sendto()");
	       	}
		



	}


	/* end of emission */

	/* Release rp resources */
	rp_Release();

	return 0;
}
