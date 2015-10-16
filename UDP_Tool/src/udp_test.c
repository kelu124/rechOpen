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

#define IPme "192.168.1.28"
#define PORT 7536   //The port on which to listen for incoming data
#define SWAP_UINT32(x) (((x) >> 24) | (((x) & 0x00FF0000) >> 8) | (((x) & 0x0000FF00) << 8) | ((x) << 24))

#define BUFLEN 16384  //Max length of buffer // 16*1024
#define nbline 64     //Number of line of the image
#define nbmean 16     //Number of signal for the average

int tbuff = 0;
int CheckUDP = 0;



void die(char *s)
{
    perror(s);
    exit(1);
}

long timediff(clock_t t1, clock_t t2) {
    long elapsed;
    elapsed = ((double)t2 - t1) / CLOCKS_PER_SEC * 1000;
    return elapsed;
}



// Pitaya code in itself
int main(int argc, char **argv){
	clock_t tStart, tTop, tEnd;


	/* Initialize UDP */
	struct sockaddr_in si_me, si_other;
	int s;
	int slen = sizeof(si_other);

	if ((s=socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1)
	{
	die("socket");
	}

	// zero out the structure
	memset((char *) &si_me, 0, sizeof(si_me));
	si_me.sin_family = AF_INET;
	si_other.sin_family = AF_INET;
	si_me.sin_port = htons(PORT); // Port
	si_other.sin_port = htons(PORT);
	si_other.sin_addr.s_addr = inet_addr(IPme); //specific binding to listenser
	if( bind(s , (struct sockaddr*)&si_me, sizeof(si_me) ) == -1){die("bind");}
	/* End of UDP initialization */



	/*size of the acquisition buffer*/
	uint32_t buff_size = BUFLEN;
	uint32_t HalfSignal = buff_size/2;
	/*allocation of buffer size in memory*/

	tStart = clock();
	/* Print error, if rp_Init() function failed */
	if(rp_Init() != RP_OK){
		fprintf(stderr, "Rp api init failed!\n");
	}


		

	for (int k=0; k < nbline ; k++){

		float *buff = (float *)malloc(buff_size * sizeof(float));
		int *ibuff = (int *)malloc(buff_size * sizeof(int));

		/*initialise to 0 the buffer*/
		for (int i=0 ; i<buff_size ; i++){buff[i]=0.0;}
		rp_AcqSetDecimation(RP_DEC_64);
		uint32_t buff_sizeW = 12000;
		float *buffW = (float *)malloc(buff_sizeW * sizeof(float));
	
		rp_acq_trig_state_t stateW = RP_TRIG_STATE_TRIGGERED;
		/*start acquisition must be set before trigger initiation*/
		rp_AcqStart();
		/*allocation of temporary buffer size in memory*/

	
		/*trigger source -- Channel B, Negatif*/ 
		rp_AcqSetTriggerSrc(RP_TRIG_SRC_CHA_PE);
		/*level of the trigger activation in volt*/
		double PWMTriggerLevel = 0.05;
		rp_AcqSetTriggerLevel(PWMTriggerLevel);
		/*waiting for trigger*/
		while(1){
			rp_AcqGetTriggerState(&stateW);
			if(stateW == RP_TRIG_STATE_TRIGGERED){
				break;
			}
		}		
		/*putt acquisition data in the temporary buffer*/
		rp_AcqGetOldestDataV(RP_CH_1, &buff_sizeW, tempW);

		int PWM_Position = 0;
		for (i=0 ; i<buff_sizeW ; i++) {
			if (buffW[i] > PWMTriggerLevel ){PWM_Position++;}	
			//printf("%f ",buffW[i]);
		}
		PWM_Position = PWM_Position -2000; //lowering the base, staying over max though
		printf("PWM : %i\n",PWM_Position);




		// On commence alors l'acquisition des échantillons
		/*init trigger state*/
		/* decimation n (=1,8,64...) : frequency = 125/n MHz*/
		rp_AcqSetDecimation(RP_DEC_1);
		rp_acq_trig_state_t state = RP_TRIG_STATE_TRIGGERED;
		tTop = clock();
		for (int i=0 ; i<nbmean ; i++) {

			/*start acquisition must be set before trigger initiation*/
			rp_AcqStart();

			/*allocation of temporary buffer size in memory*/
			float *temp = (float *)malloc(buff_size * sizeof(float));

			/*trigger source -- Channel B, Negatif*/ 
			rp_AcqSetTriggerSrc(RP_TRIG_SRC_CHB_NE);

			/*level of the trigger activation in volt*/
			rp_AcqSetTriggerLevel(-0.02); 

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



		/*raw data as integer*/
		int buff_size_udp=16000;
		for (int i=0 ; i<buff_size_udp ; i++) {
			buff[i] -= MoyenneFichier;
			ibuff[i] = (int16_t)(buff[i]*8191/22); //for HV, v~=int16*22/16384
		}
		free(buff);
	
		/*Sending the image
		int sampling = 16;
		int samples = 256;
		int PointsNb = buff_size/sampling;
	
		int *iToBuff = (int *)malloc(PointsNb * sizeof(int));
		int *tmp = (int *)malloc(PointsNb * sizeof(int));
	
		for (int i = 0 ; i < PointsNb ; ++i) {
			tmp[i] = 0;
			for (int j = 0 ; j < sampling ; ++j) {
		   		 tmp[i] += (int)(ibuff[i*sampling+j]*ibuff[i*sampling+j]) ;			
			}
			iToBuff[i] = (int)(abs((tmp[i] / sampling)));
		}
		free(ibuff);*/



		/* Checking for a file 
		//
		FILE * fm;
		fm = fopen ("moy.txt", "w+");
		for (int i=0 ; i<PointsNb ; i++) {
		fprintf(fm, "%i\n", iToBuff[i]);
		}
		fclose(fm);
		*/
	
		/* sending to UDP */
		int16_t DATA_Image = 0; //Number of the image in the acq 
		int MaxPointsPerPacket = 256; // (in bytes)
		int NbPackets = (int)(PointsNb/MaxPointsPerPacket);
		
		int TaillerBuffer = MaxPointsPerPacket+3+4;
		int16_t UDPBuffer[TaillerBuffer];

		int16_t DATA_Line = 0;
		for (int i=0 ; i<TaillerBuffer ; i++){UDPBuffer[i]=0;}
		for (int i=0 ; i < NbPackets ; i++) { // iteration sur l'ensemble des packets du buffer
	
			UDPBuffer[0] = (int16_t)i; // Position of the packet inside the line
			UDPBuffer[1] = DATA_Image; // Number of the line
			UDPBuffer[2] = DATA_Line; //Number of the image
			UDPBuffer[3] = 0;//PWM_Position; //BUG @corriger
			UDPBuffer[4] = (int16_t)k; //BUG @corriger à la reception -- je voulais mettre datetimestamp
			tEnd = clock();
			UDPBuffer[5] =  (int16_t)timediff(tStart, tTop); //BUG @corriger -- début de l'acquisition de la ligne
			UDPBuffer[6] = (int16_t)timediff(tStart, tEnd); //BUG @corriger -- fin de l'acquisition de la ligne
	
			for (int j=0; j < samples ; j++){ // iteration par points du packet
				if (i*MaxPointsPerPacket+j>16000) {UDPBuffer[7+j]=0;}
				else {UDPBuffer[7+j] = iToBuff[i*MaxPointsPerPacket+j]};
			}
	
			CheckUDP = sendto(s,UDPBuffer,sizeof(UDPBuffer),0,(struct sockaddr*) &si_other,slen);

			usleep(2);
			if (CheckUDP==-1) {die("sendto()");}
		}
	
		/* end of emission */
		free(iToBuff);
		free(tmp);
		usleep(2000);
	}
	/* Release rp resources */

	rp_Release();

	return 0;
}
