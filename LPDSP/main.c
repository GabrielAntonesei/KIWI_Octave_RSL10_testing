/* ----------------------------------------------------------------------------
 * Copyright (c) 2017 Semiconductor Components Industries, LLC (d/b/a
 * ON Semiconductor), All Rights Reserved
 *
 * This code is the property of ON Semiconductor and may not be redistributed
 * in any form without prior written permission from ON Semiconductor.
 * The terms of use and warranty for this code are covered by contractual
 * agreements between ON Semiconductor and the licensee.
 *
 * This is Reusable Code.
 *
 * -----------------------------------------------------------------------------
 */

#include <stdlib.h>
#include <stdint.h>
#include <math.h>


// This is derived from SpikeDet1
// It computes a simpler version of standard deviation using only absolute "deviations" instead of squared ones


// In this version, only a basic comparison of the values from the input vector against a given threshold.
// The input vector has 1024 samples, but the last 24 samples are reserved for various parameters 
// (in this case, the last one is the actual threshold, which is set from outside)

// The DSP fills out a different output vector with 1000 processed samples 
// (again, the last 24 samples are used to send back some results, like the position of the thresshold crossing, the mean value )

// It will detect a maximum of 10 Spikes in a vector of 1000 samples because after each detection there is a resting period of 100 samples
// The index locations of detected Spikes are placed in the DSP Output results area starting with address 1000  
// At address 1000 will be the location (index) of first detected Spike
// At address 1001 will be the location (index) of second detected Spike and so on ...




// Define the location of the CSS command register, this would normally be
// taken from a standard include file however to provide clarity in this
// example we will define it explicitly
#define CSS_CMD                         0xC00004

// Define the specific interrupt that the ARM will trigger when it wants
// us to perform a calculation
#define CSS_CMD_0                       (1<<0)

// Define the shared memory between the ARM and LPDSP processors
//uint32_t chess_storage(DMB:0x00803800) sharedMemory[2];       // uint32_t *sharedMemory = (uint32_t *) 0x20011800;
//uint32_t chess_storage(DMB:0x00803000) sharedMemory[2];   	// uint32_t *sharedMemory = (uint32_t *) 0x20011000;
//uint32_t chess_storage(DMB:0x00802000) sharedMemory[2];       // uint32_t *sharedMemory = (uint32_t *) 0x20010000;
//uint32_t chess_storage(DMB:0x00801000) sharedMemory[2];       // uint32_t *sharedMemory = (uint32_t *) 0x2000F000;
//uint32_t chess_storage(DMB:0x00800000) sharedMemory[2];         // uint32_t *sharedMemory = (uint32_t *) 0x2000E000;

//uint32_t chess_storage(DMA:0x007F0000) sharedMemory[2];         // uint32_t *sharedMemory = (uint32_t *) 0x2000D000;

uint64_t chess_storage(DMA:0x002000) sharedMemory[2] ;      // uint32_t *sharedMemory = (uint32_t *) 0x20006000;

// Below as mapped by Cortex-M3
//uint32_t *sharedInputMemory = (uint32_t *) 0x20006118;//0x20006000;
//uint32_t *sharedOutputMemory = (uint32_t *) 0x20006018;//0x20011800;

//uint32_t chess_storage(DMA:0x007F8018) sharedOutputMemory[64];
//uint32_t chess_storage(DMA:0x007F8118) sharedInputMemory[64];

//uint32_t chess_storage(DMB:0x00803810) sharedInputMemory[64];
//uint32_t chess_storage(DMB:0x00803910) sharedOutputMemory[64];


//uint32_t chess_storage(DMB:0x00800000) sharedInputMemory[64];       // uint32_t *sharedMemory = (uint32_t *) 0x2000E000;
//uint32_t chess_storage(DMB:0x00800100) sharedOutputMemory[64];      // uint32_t *sharedMemory = (uint32_t *) 0x2000E100;

int32_t chess_storage(DMB:0x00800000) sharedInputMemory[1024];       // uint32_t *sharedMemory = (uint32_t *) 0x2000E000;
//int32_t chess_storage(DMB:0x00800100) sharedOutputMemory[64];      // uint32_t *sharedMemory = (uint32_t *) 0x2000E100;
int32_t chess_storage(DMB:0x00801000) sharedOutputMemory[1024];      // uint32_t *sharedMemory = (uint32_t *) 0x2000F000;







uint32_t index_fib ;

    uint32_t    temp = 0   ;
    uint32_t    idx = 0   ;

// Define the interrupt register to notify the ARM of a completed operation
volatile static unsigned char chess_storage(DMIO:CSS_CMD) CssCmdGen;

// handling requests from the CM3 is activated
static volatile int actionRequired;

/* ----------------------------------------------------------------------------
 * Function : isr0
 * ----------------------------------------------------------------------------
 * Description : Interrupt service routine invoked on request from the CM3
 * Inputs : None
 * Outputs : sets flag indicating work needs to be done
 * Assumptions : None
 * ----------------------------------------------------------------------------
 */
extern "C" void isr0() property (isr) {
	// raise the flag indicating something needs to be processed
	actionRequired = true;
}

/* ----------------------------------------------------------------------------
 * Function : fibonacci
 * ----------------------------------------------------------------------------
 * Description : calculate the nth fibonacci number where:
 *                  0 is 0,
 *                  1 is 1,
 *                  2 is 1,
 *                  3 is 2, etc
 *
 * Inputs : nth, the number of the fibonacci sequence to return
 *
 * Outputs : the fibonacci number as defined above, or 0xFFFFFFFF if overflow
 *
 * Assumptions : None
 * ----------------------------------------------------------------------------
 */
uint32_t fibonacci(uint32_t nth) {
    
    // we know the 48th fibonacci number will be too large for a uint32_t
    if (nth >= 48)
        return 0xFFFFFFFF;

    // deal with trivial cases
    if ((nth == 0) || (nth == 1))
        return nth;

    // otherwise calculate the return value in a loop
    uint32_t value = 0, first = 0, second = 1;
    while (nth-- > 1) {
        //value = 1*(first + second);
        value = value + nth;
        first = second;
        second = value;
    }
    

    
    return value;
}

/* ----------------------------------------------------------------------------
 * Function : main
 * ----------------------------------------------------------------------------
 * Description : The main entry point for the program
 *
 * 	Note: this halts the core when not busy and is awoken by an interrupt
 *      from the CM3
 *
 * Inputs : None
 *
 * Outputs : returns zero but the code is not expected to ever complete
 *
 * Assumptions : None
 * ----------------------------------------------------------------------------
 */
extern "C" int main(void) {
    

    
    
    // assume nothing ready to be processed yet
    actionRequired = false;

    // enable the interrupts
    enable_interrupts();
    
    
    // spin forever, waiting for interrupts from the CM3
    while (true) {        
        core_halt();

        // only do something if we are responding to an interrupt from the CM3
        if (actionRequired == true) {
            actionRequired = false;

            // calculate the nth fibonacci number
            index_fib = sharedMemory[0] ;
            sharedMemory[1] = fibonacci(sharedMemory[0]);
            
            

    // This writes incremented values on the input data vector as well as the output data vector (both used for synchronization with ARM)
    // In theory, only the output data vector should be written, but the input one is also written for test purposes
    
    sharedOutputMemory[0] = 0 ;
    // acc_0 = 0 ;
    
    long sum = 0 ;
    long sum_sqr = 0 ;
    long mean_value ;
    long tmp_value ;
    long std_dev_abs ;      // Compute standard deviation using only absolute deviations (not squared)
    long std_dev_sqr ;
    long thrshld_mult_fact ;    // Threshold multiplication factor
    long IntThreshold ;         // Internal threshold value (to be sure there no memory writing issues)
    
    
    //int32_t
    int  flag_crossing = 0 ;        // flags if a crossing was already detected
    int  spike_idx = 0 ;            // Keeps track of how many Spikes have been detected so far
                                    // It's needed in order to place the index location of detected crossings starting with address 1000
                                    
    int  resting_counter = 0 ;      // Counter used to signal the blocked period for detecting another crossing
                                    // It's considered that a neuron needs some time to rest after firing a pulse
                                    // We will give a resting time of 100 samples (at 30kHz sampling rate)
    
    
    
    for ( idx=0;idx<1000;idx++)           // Consider only 60 samples from the vector as being real waveform data
    { 
     
    sum += sharedInputMemory[idx] ;
         
    } 
        
        mean_value = sum/1000 ;
        sharedOutputMemory[1010]  = mean_value ;
      
            
                

// Compute standard deviation

    sum = 0 ;
    sum_sqr = 0 ;

    for ( idx=0;idx<1000;idx++)           // Consider only 60 samples from the vector as being real waveform data
    { 
     tmp_value = abs(sharedInputMemory[idx]-mean_value);
     //sum += abs(sharedInputMemory[idx]-mean_value);
     sum += tmp_value ;
     sum_sqr += tmp_value*tmp_value ;   
    }

    std_dev_abs = sum/1000;
    std_dev_sqr = sum_sqr/1000;
    sharedOutputMemory[1011]  = std_dev_abs ;
    std_dev_sqr = sqrt(std_dev_sqr) ;
    sharedOutputMemory[1012]  = std_dev_sqr ;
  
  
    thrshld_mult_fact = sharedInputMemory[1022];
  
  
    if(sharedInputMemory[1023]==0)
    {
    IntThreshold = thrshld_mult_fact*std_dev_abs ;       // Override the Threshold
    }
    else if (sharedInputMemory[1023]==1)
    {
        IntThreshold = thrshld_mult_fact*std_dev_sqr  ;
    }
    else 
    {
        IntThreshold = sharedInputMemory[1023] ;
    }
    
    
      
    //if( sharedInputMemory[1023]==1 )
    //{
    //sharedInputMemory[1023] = thrshld_mult_fact*std_dev_sqr ;     // Override the Threshold
    //IntThreshold = thrshld_mult_fact*std_dev_sqr ;       // Override the Threshold
    //}  
    //else
    //{
    //    IntThreshold = sharedInputMemory[1023] ;
    //}
      
      
      
                                  
     sharedOutputMemory[1013]  = IntThreshold ;     
     
     //sharedOutputMemory[1013] = 123;                                          
                                                                                                                                   
        
    // Detect Spikes now, using the auto-threshold number, after the waveform is corrected with the mean_value      
              
    
    for ( idx=0;idx<1000;idx++)           // Consider only 60 samples from the vector as being real waveform data
    { 
    //acc_0 += fract_mult(coef[i], data[i]); 
    //acc_1 += fract_mult(coef[i+1], data[i+1]); 
    //out[i] = rnd_saturate(acc_0 + acc_1); 
    //out[i+1] = rnd_saturate(acc_0 - acc_1); 
    
    
    //temp = sharedInputMemory[idx] ;
    //sharedOutputMemory[idx] = idx+200 ;  
    //sharedInputMemory[idx] = idx+100 ;
    //sharedMemory[idx+2] = idx+200 ;
    

    
//    if((sharedInputMemory[idx]-mean_value)<sharedInputMemory[1023])        // because the threshold is placed in the last location of the buffer
    if((sharedInputMemory[idx]-mean_value)<IntThreshold)        // because the threshold is placed in the last location of the buffer
      {
      sharedOutputMemory[idx] = 0 ;
      }
    else
        {
                
        //sharedOutputMemory[idx] = sharedInputMemory[1023] ;     // Places the value of the Threshold
        sharedOutputMemory[idx] = IntThreshold ;     // Places the value of the Threshold
        
        if(flag_crossing == 0)
            {
                flag_crossing = 1 ;
                resting_counter = 100 ;
                sharedOutputMemory[1000+spike_idx] = idx ;  // this indicates the location of the threshold crossing
                spike_idx = spike_idx + 1 ;
            }
        }
    
    
    //sum += sharedInputMemory[idx] ;   // It was computed earlier
    
    if(resting_counter>0)
        {
            resting_counter = resting_counter - 1;
        }
    else
        {
            flag_crossing = 0;
            resting_counter = 0;
        }
        
    
   // sharedOutputMemory[idx] = abs(sharedInputMemory[idx]);
    
    
    } 
    
    
    
    
            
            // notify the CM3 that we have completed processing
            CssCmdGen = CSS_CMD_0;
        }

    }
    
    return 0;
}
