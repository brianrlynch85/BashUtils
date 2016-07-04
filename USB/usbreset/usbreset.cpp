#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <cstdlib>

#include <linux/usbdevice_fs.h>

void print_usage();

int main(int argc, char **argv)
{
   char *filename = NULL;
   int opt = 0, fd = 0, rc = 0;

   //Parse the command line
   if(1 == argc){
      
      print_usage(); 
      exit(EXIT_FAILURE);
       
   }

   while((opt = getopt(argc, argv,"-f:")) != -1) {
     
      switch (opt) {
         
         case 'f' : //input filename option
            
            filename = optarg;
            fprintf(stderr, "Input Filename: %s\n", filename);

            break;
            
         case '?': //unrecognized command line option
            
            fprintf(stderr, "Unrecognized command line option. \n");
            print_usage();
            return(EXIT_FAILURE);
            
         case '\1': //the - in "-f:" finds non option command line params
            
            fprintf(stderr, "Passed non-option to command line.\n");
            print_usage();
            return(EXIT_FAILURE);
            
      }
        
   }

   fd = open(filename, O_WRONLY);
   if (fd < 0) {
      perror("Error opening output file");
      return(EXIT_FAILURE);
   }

   printf("Resetting USB device %s\n", filename);
   rc = ioctl(fd, USBDEVFS_RESET, 0);
   if (rc < 0) {
      perror("Error in ioctl");
      return(EXIT_FAILURE);
   }

   printf("Reset successful\n");

   close(fd);

return(EXIT_SUCCESS);

}

/************************************************************************/
void print_usage(){
   
   fprintf(stderr, "Find your device with the command lsusb\n");
   fprintf(stderr, "Usage: ./usbreset -f <filename from lsusb>\n");
   fprintf(stderr, "Example: ./usbreset -f /dev/bus/usb/002/003\n");
   
}