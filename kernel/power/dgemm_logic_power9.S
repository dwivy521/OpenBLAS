/***************************************************************************
Copyright (c) 2013-2019 The OpenBLAS Project
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:
1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in
the documentation and/or other materials provided with the
distribution.
3. Neither the name of the OpenBLAS project nor the names of
its contributors may be used to endorse or promote products
derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE OPENBLAS PROJECT OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*****************************************************************************/
 

#define MY_ALIGN .align 3

#if defined(TRMMKERNEL) && !defined(LEFT)
   neg TEMP_REG, OFFSET 
#endif

	srawi.		J,	N,	2
	ble		LDGEMM_L4_END

LDGEMM_L4_BEGIN:

 
	li		T1,	128
	li		T2,	256
 
	mr		AO,	A
	mr		CO,	C
	slwi		T3,	LDC	,	2
	add		C,	C,	T3

 
	dcbt		A,	T1
	dcbt		A,	T2
#if defined(TRMMKERNEL) && defined(LEFT)
	mr TEMP_REG, OFFSET	 /*off = offset;*/
#endif 
	srawi.		I,	M,	4
	ble		LDGEMM_L4x16_END

	MY_ALIGN
LDGEMM_L4x16_BEGIN:

	li		L,	-128


	SAVE4x16_REGS

#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,16,4
#else
	mr		BO,	B
#endif	
 
	and		T1,	CO,	L
	and		T2,	C2,	L
	and		T3,	C3,	L
	and		T4,	C4,	L

	dcbt		T1,	r0
	dcbt		T2,	r0
	dcbt		T3,	r0
	dcbt		T4,	r0
 

	addi		T1, T1, 128
	addi		T2, T2, 128
	addi		T3, T3, 128
	addi		T4, T4, 128

	dcbt		T1,	r0
	dcbt		T2,	r0
	dcbt		T3,	r0
	dcbt		T4,	r0

#if defined(TRMMKERNEL)
   REFRESH_TEMP_BK T3,K,TEMP_REG,16,4
   srawi.		L, T3,	5
#else
   srawi.		L,	K,	5
#endif 
	
	ble		LDGEMM_L4x16_SUB0


	MY_ALIGN
LDGEMM_L4x16_LOOP_START:

	li	T2,	512
 
 
	LOAD4x16_1
    ##OffsetA=128 OffsetB=32
    addi AO,AO,2176
 #   addi BO,BO,32 
	addic.		L,	L,	-1

	ble		LDGEMM_L4x16_LOOP_END

	
	mtctr		L

	MY_ALIGN

LDGEMM_L4x16_LOOP:

	#dcbt	AO,	PRE
    KERNEL4x16_I1_L2_2  -2048,32, 0,0
    KERNEL4x16_I1_L2_2  -2048,32, 1,0
    KERNEL4x16_I1_L2_2  -2048,32, 2,0
    KERNEL4x16_I1_L2_2  -2048,32, 3,0
    KERNEL4x16_I1_L2_2  -2048,32, 4,0
    KERNEL4x16_I1_L2_2  -2048,32, 5,0        
    KERNEL4x16_I1_L2_2  -2048,32, 6,0
    KERNEL4x16_I1_L2_2  -2048,32, 7,0  
    KERNEL4x16_I1_L2_2  -2048,32, 8,0      
    KERNEL4x16_I1_L2_2  -2048,32, 9,0
    KERNEL4x16_I1_L2_2  -2048,32, 10,0
    KERNEL4x16_I1_L2_2  -2048,32, 11,0
    KERNEL4x16_I1_L2_2  -2048,32, 12,0
    KERNEL4x16_I1_L2_2  -2048,32, 13,0    
    KERNEL4x16_I1_L2_2  -2048,32, 14,0    
    KERNEL4x16_I1_L2_2  -2048,32, 15,1  	


	bdnz		LDGEMM_L4x16_LOOP

	MY_ALIGN
	MY_ALIGN
LDGEMM_L4x16_LOOP_END:

    KERNEL4x16_I1_L2_2  -2048,32, 0,0
    KERNEL4x16_I1_L2_2  -2048,32, 1,0
    KERNEL4x16_I1_L2_2  -2048,32, 2,0
    KERNEL4x16_I1_L2_2  -2048,32, 3,0
    KERNEL4x16_I1_L2_2  -2048,32, 4,0
    KERNEL4x16_I1_L2_2  -2048,32, 5,0        
    KERNEL4x16_I1_L2_2  -2048,32, 6,0
    KERNEL4x16_I1_L2_2  -2048,32, 7,0  
    KERNEL4x16_I1_L2_2  -2048,32, 8,0      
    KERNEL4x16_I1_L2_2  -2048,32, 9,0
    KERNEL4x16_I1_L2_2  -2048,32, 10,0
    KERNEL4x16_I1_L2_2  -2048,32, 11,0
    KERNEL4x16_I1_L2_2  -2048,32, 12,0
    KERNEL4x16_I1_L2_2  -2048,32, 13,0    
    KERNEL4x16_I1_L2_2  -2048,32, 14,0    
    KERNEL4x16_I1_L2_3  -2048,32, 15,1    
	b		LDGEMM_L4x16_SUB1


	MY_ALIGN
LDGEMM_L4x16_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	31
#else
	andi.		L,	K,	31
#endif
	KERNEL4x16 1

	addic.		L,	L,	-1
	ble		LDGEMM_L4x16_SAVE
	b		LDGEMM_L4x16_SUB2
	MY_ALIGN
LDGEMM_L4x16_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	31
#else
	andi.		L,	K,	31
#endif	
	ble		LDGEMM_L4x16_SAVE
	MY_ALIGN
LDGEMM_L4x16_SUB2:

    andi.      T1,L, 16
    ble LDGEMM_L4x16_SUB2_8
	LOAD4x16_0 
    KERNEL4x16_I1_L2_2  128,32, 0,0
    KERNEL4x16_I1_L2_2  128,32, 1,0
    KERNEL4x16_I1_L2_2  128,32, 2,0
    KERNEL4x16_I1_L2_2  128,32, 3,0
    KERNEL4x16_I1_L2_2  128,32, 4,0
    KERNEL4x16_I1_L2_2  128,32, 5,0        
    KERNEL4x16_I1_L2_2  128,32, 6,0
    KERNEL4x16_I1_L2_3  128,32, 7,1 
    MY_ALIGN
LDGEMM_L4x16_SUB2_8:
    andi.      T1,L, 8
    ble LDGEMM_L4x16_SUB2_4
	LOAD4x16_0
    KERNEL4x16_I1_L2_2  128,32, 0,0
    KERNEL4x16_I1_L2_2  128,32, 1,0
    KERNEL4x16_I1_L2_2  128,32, 2,0
    KERNEL4x16_I1_L2_3  128,32, 3,1
	MY_ALIGN
LDGEMM_L4x16_SUB2_4:
    andi.      T1,L, 4
    ble LDGEMM_L4x16_SUB2_2 
	LOAD4x16_0
    KERNEL4x16_I1_L2_2  128,32, 0,0
    KERNEL4x16_I1_L2_3  128,32, 1,1
	MY_ALIGN	
LDGEMM_L4x16_SUB2_2:
    andi.      T1,L, 2
    ble LDGEMM_L4x16_SUB2_1
    LOAD4x16_0
    KERNEL4x16_I1_L2_3  128,32, 0,1
    MY_ALIGN
LDGEMM_L4x16_SUB2_1:
    andi.      T1,L, 1
    ble LDGEMM_L4x16_SAVE	
    KERNEL4x16 0
#	addic.		L,	L,	-1
#	bgt		LDGEMM_L4x16_SUB2

	MY_ALIGN
LDGEMM_L4x16_SAVE:
	SAVE4x16
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,16,4
#endif	
	addic.		I,	I,	-1
	bgt+		LDGEMM_L4x16_BEGIN

LDGEMM_L4x16_END:

LDGEMM_L4x8_BEGIN:

	andi.		T2,	M,	15
	ble		LDGEMM_L4x1_END

	andi.		T1,	M,	8
	ble		LDGEMM_L4x8_END


#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,8,4
    REFRESH_TEMP_BK T3,K,TEMP_REG,8,4
    srawi.		L, T3,	4	
#else
	mr		BO,	B
	srawi.		L,	K,	4	
#endif		 
 

	ble		LDGEMM_L4x8_SUB0

LDGEMM_L4x8_LOOP_START:


	LOAD4x8_1
    ##OffsetA=64 OffsetB=32


	addic.		L,	L,	-1

	ble		LDGEMM_L4x8_LOOP_END

    mtctr		L
	MY_ALIGN

LDGEMM_L4x8_LOOP:

    KERNEL4x8_I1_L2_2  64,32, 0,0
    KERNEL4x8_I1_L2_2  64,32, 1,0
    KERNEL4x8_I1_L2_2  64,32, 2,0
    KERNEL4x8_I1_L2_2  64,32, 3,0
    KERNEL4x8_I1_L2_2  64,32, 4,0
    KERNEL4x8_I1_L2_2  64,32, 5,0        
    KERNEL4x8_I1_L2_2  64,32, 6,0
    KERNEL4x8_I1_L2_2  64,32, 7,1     

	bdnz		LDGEMM_L4x8_LOOP
	MY_ALIGN
LDGEMM_L4x8_LOOP_END:

    KERNEL4x8_I1_L2_2  64,32, 0,0
    KERNEL4x8_I1_L2_2  64,32, 1,0
    KERNEL4x8_I1_L2_2  64,32, 2,0
    KERNEL4x8_I1_L2_2  64,32, 3,0
    KERNEL4x8_I1_L2_2  64,32, 4,0
    KERNEL4x8_I1_L2_2  64,32, 5,0        
    KERNEL4x8_I1_L2_2  64,32, 6,0
    KERNEL4x8_I1_L2_3  64,32, 7,1  

	b		LDGEMM_L4x8_SUB1
	MY_ALIGN
LDGEMM_L4x8_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	15
#else
	andi.		L,	K,	15
#endif
	KERNEL4x8 1

	addic.		L,	L,	-1
	ble		LDGEMM_L4x8_SAVE
	b		LDGEMM_L4x8_SUB2
	MY_ALIGN
LDGEMM_L4x8_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	15
#else
	andi.		L,	K,	15
#endif	
	ble		LDGEMM_L4x8_SAVE
	MY_ALIGN
LDGEMM_L4x8_SUB2:

    andi.      T1,L, 8
    ble LDGEMM_L4x8_SUB2_4
	LOAD4x8_0
    KERNEL4x8_I1_L2_2  64,32, 0,0
    KERNEL4x8_I1_L2_2  64,32, 1,0
    KERNEL4x8_I1_L2_2  64,32, 2,0
    KERNEL4x8_I1_L2_3  64,32, 3,1
	MY_ALIGN
LDGEMM_L4x8_SUB2_4:
    andi.      T1,L, 4
    ble LDGEMM_L4x8_SUB2_2 
	LOAD4x8_0
    KERNEL4x8_I1_L2_2  64,32, 0,0
    KERNEL4x8_I1_L2_3  64,32, 1,1
	MY_ALIGN	
LDGEMM_L4x8_SUB2_2:
    andi.      T1,L, 2
    ble LDGEMM_L4x8_SUB2_1
    LOAD4x8_0
    KERNEL4x8_I1_L2_3  64,32, 0,1
    MY_ALIGN
LDGEMM_L4x8_SUB2_1:
    andi.      T1,L, 1
    ble LDGEMM_L4x8_SAVE	
    KERNEL4x8 0
 
	MY_ALIGN
LDGEMM_L4x8_SAVE:
	SAVE4x8
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,8,4
#endif	
LDGEMM_L4x8_END:

LDGEMM_L4x4_BEGIN:


	andi.		T1,	M,	4
	ble		LDGEMM_L4x4_END

#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,4,4
    REFRESH_TEMP_BK T3,K,TEMP_REG,4,4
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif		
	ble		LDGEMM_L4x4_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L4x4_SUB4

LDGEMM_L4x4_LOOP_START:

	#dcbt	AO,	PRE
	LOAD4x4_1
	KERNEL4x4_I1
	KERNEL4x4_2
	KERNEL4x4_1
	#dcbt	AO,	PRE
	KERNEL4x4_2

	KERNEL4x4_1
	KERNEL4x4_2
	KERNEL4x4_1
	#dcbt	AO,	PRE
	KERNEL4x4_2

	addic.		L,	L,	-2
	ble		LDGEMM_L4x4_LOOP_END

	MY_ALIGN

LDGEMM_L4x4_LOOP:

	KERNEL4x4_1
	KERNEL4x4_2
	KERNEL4x4_1
	#dcbt	AO,	PRE
	KERNEL4x4_2

	KERNEL4x4_1
	KERNEL4x4_2
	KERNEL4x4_1
	#dcbt	AO,	PRE
	KERNEL4x4_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L4x4_LOOP

LDGEMM_L4x4_LOOP_END:

	KERNEL4x4_1
	KERNEL4x4_2
	KERNEL4x4_1
	KERNEL4x4_2

	KERNEL4x4_1
	KERNEL4x4_2
	KERNEL4x4_1
	KERNEL4x4_E2

	b		LDGEMM_L4x4_SUB1

LDGEMM_L4x4_SUB4:

	KERNEL4x4_SUBI1
	KERNEL4x4_SUB1
	KERNEL4x4_SUB1
	KERNEL4x4_SUB1

	KERNEL4x4_SUB1
	KERNEL4x4_SUB1
	KERNEL4x4_SUB1
	KERNEL4x4_SUB1

	b		LDGEMM_L4x4_SUB1

LDGEMM_L4x4_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL4x4_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L4x4_SAVE
	b		LDGEMM_L4x4_SUB2

LDGEMM_L4x4_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L4x4_SAVE

LDGEMM_L4x4_SUB2:

	KERNEL4x4_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L4x4_SUB2

LDGEMM_L4x4_SAVE:

	SAVE4x4
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,4,4
#endif	
LDGEMM_L4x4_END:

LDGEMM_L4x2_BEGIN:


	andi.		T1,	M,	2
	ble		LDGEMM_L4x2_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,2,4
    REFRESH_TEMP_BK T3,K,TEMP_REG,2,4
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L4x2_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L4x2_SUB4

LDGEMM_L4x2_LOOP_START:

	LOAD4x2_1
	KERNEL4x2_I1
	KERNEL4x2_2
	KERNEL4x2_1
	KERNEL4x2_2

	KERNEL4x2_1
	KERNEL4x2_2
	KERNEL4x2_1
	KERNEL4x2_2

	addic.		L,	L,	-2
	ble		LDGEMM_L4x2_LOOP_END

	MY_ALIGN

LDGEMM_L4x2_LOOP:

	KERNEL4x2_1
	KERNEL4x2_2
	KERNEL4x2_1
	KERNEL4x2_2

	KERNEL4x2_1
	KERNEL4x2_2
	KERNEL4x2_1
	KERNEL4x2_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L4x2_LOOP

LDGEMM_L4x2_LOOP_END:

	KERNEL4x2_1
	KERNEL4x2_2
	KERNEL4x2_1
	KERNEL4x2_2

	KERNEL4x2_1
	KERNEL4x2_2
	KERNEL4x2_1
	KERNEL4x2_E2

	b		LDGEMM_L4x2_SUB1

LDGEMM_L4x2_SUB4:

	KERNEL4x2_SUBI1
	KERNEL4x2_SUB1
	KERNEL4x2_SUB1
	KERNEL4x2_SUB1

	KERNEL4x2_SUB1
	KERNEL4x2_SUB1
	KERNEL4x2_SUB1
	KERNEL4x2_SUB1

	b		LDGEMM_L4x2_SUB1

LDGEMM_L4x2_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL4x2_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L4x2_SAVE
	b		LDGEMM_L4x2_SUB2

LDGEMM_L4x2_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L4x2_SAVE

LDGEMM_L4x2_SUB2:

	KERNEL4x2_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L4x2_SUB2

LDGEMM_L4x2_SAVE:

	SAVE4x2
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,2,4
#endif	
LDGEMM_L4x2_END:

LDGEMM_L4x1_BEGIN:


	andi.		T1,	M,	1
	ble		LDGEMM_L4x1_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,1,4
    REFRESH_TEMP_BK T3,K,TEMP_REG,1,4
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L4x1_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L4x1_SUB4

LDGEMM_L4x1_LOOP_START:

	LOAD4x1_1
	KERNEL4x1_I1
	KERNEL4x1_2
	KERNEL4x1_1
	KERNEL4x1_2

	KERNEL4x1_1
	KERNEL4x1_2
	KERNEL4x1_1
	KERNEL4x1_2

	addic.		L,	L,	-2
	ble		LDGEMM_L4x1_LOOP_END

	MY_ALIGN

LDGEMM_L4x1_LOOP:

	KERNEL4x1_1
	KERNEL4x1_2
	KERNEL4x1_1
	KERNEL4x1_2

	KERNEL4x1_1
	KERNEL4x1_2
	KERNEL4x1_1
	KERNEL4x1_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L4x1_LOOP

LDGEMM_L4x1_LOOP_END:

	KERNEL4x1_1
	KERNEL4x1_2
	KERNEL4x1_1
	KERNEL4x1_2

	KERNEL4x1_1
	KERNEL4x1_2
	KERNEL4x1_1
	KERNEL4x1_E2

	b		LDGEMM_L4x1_SUB1

LDGEMM_L4x1_SUB4:

	KERNEL4x1_SUBI1
	KERNEL4x1_SUB1
	KERNEL4x1_SUB1
	KERNEL4x1_SUB1

	KERNEL4x1_SUB1
	KERNEL4x1_SUB1
	KERNEL4x1_SUB1
	KERNEL4x1_SUB1

	b		LDGEMM_L4x1_SUB1

LDGEMM_L4x1_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL4x1_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L4x1_SAVE
	b		LDGEMM_L4x1_SUB2

LDGEMM_L4x1_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L4x1_SAVE

LDGEMM_L4x1_SUB2:

	KERNEL4x1_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L4x1_SUB2

LDGEMM_L4x1_SAVE:

	SAVE4x1
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,1,4
#endif	
LDGEMM_L4x1_END:

	slwi		T1,	K,	5
	add		B,	B,	T1
#if defined(TRMMKERNEL) && !defined(LEFT)
    addi TEMP_REG, TEMP_REG, 4
#endif
	addic.		J,	J,	-1
	bgt		LDGEMM_L4_BEGIN

	andi.		T2,	N,	3
	ble		.L999

LDGEMM_L4_END:

	b		LDGEMM_L2_BEGIN

.L999_H1:

	b		.L999

LDGEMM_L2_BEGIN:

#if defined(TRMMKERNEL) && defined(LEFT)
	mr TEMP_REG, OFFSET	 /*off = offset;*/
#endif 
	andi.		T1,	N,	2
	ble		LDGEMM_L2_END
	mr		CO,	C
	mr		AO,	A
	slwi		T1,	LDC	,	1
	add		C,	C,	T1
	srawi.		I,	M,	4
	ble		LDGEMM_L2x16_END

LDGEMM_L2x16_BEGIN:


#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,16,2
    REFRESH_TEMP_BK T3,K,TEMP_REG,16,2
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L2x16_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L2x16_SUB4

LDGEMM_L2x16_LOOP_START:

	#dcbt		AO,	PRE
	LOAD2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_I1
	#dcbt		AO,	PRE
	KERNEL2x16_2
	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2

	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2
	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2

	addic.		L,	L,	-2
	ble		LDGEMM_L2x16_LOOP_END

	MY_ALIGN

LDGEMM_L2x16_LOOP:

	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2
	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2

	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2
	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x16_LOOP

LDGEMM_L2x16_LOOP_END:

	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2
	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2

	#dcbt		AO,	PRE
	KERNEL2x16_1
	#dcbt		AO,	PRE
	KERNEL2x16_2
	#dcbt		AO,	PRE
	KERNEL2x16_1
	KERNEL2x16_E2

	b		LDGEMM_L2x16_SUB1

LDGEMM_L2x16_SUB4:

	#dcbt		AO,	PRE
	KERNEL2x16_SUBI1
	#dcbt		AO,	PRE
	KERNEL2x16_SUB1
	#dcbt		AO,	PRE
	KERNEL2x16_SUB1
	#dcbt		AO,	PRE
	KERNEL2x16_SUB1

	KERNEL2x16_SUB1
	KERNEL2x16_SUB1
	KERNEL2x16_SUB1
	KERNEL2x16_SUB1

	b		LDGEMM_L2x16_SUB1

LDGEMM_L2x16_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL2x16_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L2x16_SAVE
	b		LDGEMM_L2x16_SUB2

LDGEMM_L2x16_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L2x16_SAVE

LDGEMM_L2x16_SUB2:

	KERNEL2x16_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x16_SUB2

LDGEMM_L2x16_SAVE:

	SAVE2x16
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,16,2
#endif	
	addic.		I,	I,	-1
	bgt		LDGEMM_L2x16_BEGIN

LDGEMM_L2x16_END:

LDGEMM_L2x8_BEGIN:

	andi.		T2,	M,	15
	ble		LDGEMM_L2x1_END

	andi.		T1,	M,	8
	ble		LDGEMM_L2x8_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,8,2
    REFRESH_TEMP_BK T3,K,TEMP_REG,8,2
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L2x8_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L2x8_SUB4

LDGEMM_L2x8_LOOP_START:

	#dcbt	AO,	PRE
	LOAD2x8_1
	KERNEL2x8_I1
	#dcbt	AO,	PRE
	KERNEL2x8_2
	KERNEL2x8_1
	#dcbt	AO,	PRE
	KERNEL2x8_2

	KERNEL2x8_1
	#dcbt	AO,	PRE
	KERNEL2x8_2
	KERNEL2x8_1
	#dcbt	AO,	PRE
	KERNEL2x8_2

	addic.		L,	L,	-2
	ble		LDGEMM_L2x8_LOOP_END

	MY_ALIGN

LDGEMM_L2x8_LOOP:

	KERNEL2x8_1
	#dcbt	AO,	PRE
	KERNEL2x8_2
	KERNEL2x8_1
	#dcbt	AO,	PRE
	KERNEL2x8_2

	KERNEL2x8_1
	#dcbt	AO,	PRE
	KERNEL2x8_2
	KERNEL2x8_1
	#dcbt	AO,	PRE
	KERNEL2x8_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x8_LOOP

LDGEMM_L2x8_LOOP_END:

	KERNEL2x8_1
	KERNEL2x8_2
	KERNEL2x8_1
	KERNEL2x8_2

	KERNEL2x8_1
	KERNEL2x8_2
	KERNEL2x8_1
	KERNEL2x8_E2

	b		LDGEMM_L2x8_SUB1

LDGEMM_L2x8_SUB4:

	KERNEL2x8_SUBI1
	KERNEL2x8_SUB1
	KERNEL2x8_SUB1
	KERNEL2x8_SUB1

	KERNEL2x8_SUB1
	KERNEL2x8_SUB1
	KERNEL2x8_SUB1
	KERNEL2x8_SUB1

	b		LDGEMM_L2x8_SUB1

LDGEMM_L2x8_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL2x8_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L2x8_SAVE
	b		LDGEMM_L2x8_SUB2

LDGEMM_L2x8_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L2x8_SAVE

LDGEMM_L2x8_SUB2:

	KERNEL2x8_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x8_SUB2

LDGEMM_L2x8_SAVE:

	SAVE2x8
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,8,2
#endif
LDGEMM_L2x8_END:

LDGEMM_L2x4_BEGIN:


	andi.		T1,	M,	4
	ble		LDGEMM_L2x4_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,4,2
    REFRESH_TEMP_BK T3,K,TEMP_REG,4,2
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L2x4_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L2x4_SUB4

LDGEMM_L2x4_LOOP_START:

	LOAD2x4_1
	KERNEL2x4_I1
	KERNEL2x4_2
	KERNEL2x4_1
	KERNEL2x4_2

	KERNEL2x4_1
	KERNEL2x4_2
	KERNEL2x4_1
	KERNEL2x4_2

	addic.		L,	L,	-2
	ble		LDGEMM_L2x4_LOOP_END

	MY_ALIGN

LDGEMM_L2x4_LOOP:

	KERNEL2x4_1
	KERNEL2x4_2
	KERNEL2x4_1
	KERNEL2x4_2

	KERNEL2x4_1
	KERNEL2x4_2
	KERNEL2x4_1
	KERNEL2x4_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x4_LOOP

LDGEMM_L2x4_LOOP_END:

	KERNEL2x4_1
	KERNEL2x4_2
	KERNEL2x4_1
	KERNEL2x4_2

	KERNEL2x4_1
	KERNEL2x4_2
	KERNEL2x4_1
	KERNEL2x4_E2

	b		LDGEMM_L2x4_SUB1

LDGEMM_L2x4_SUB4:

	KERNEL2x4_SUBI1
	KERNEL2x4_SUB1
	KERNEL2x4_SUB1
	KERNEL2x4_SUB1

	KERNEL2x4_SUB1
	KERNEL2x4_SUB1
	KERNEL2x4_SUB1
	KERNEL2x4_SUB1

	b		LDGEMM_L2x4_SUB1

LDGEMM_L2x4_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL2x4_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L2x4_SAVE
	b		LDGEMM_L2x4_SUB2

LDGEMM_L2x4_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L2x4_SAVE

LDGEMM_L2x4_SUB2:

	KERNEL2x4_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x4_SUB2

LDGEMM_L2x4_SAVE:

	SAVE2x4
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,4,2
#endif
LDGEMM_L2x4_END:

LDGEMM_L2x2_BEGIN:


	andi.		T1,	M,	2
	ble		LDGEMM_L2x2_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,2,2
    REFRESH_TEMP_BK T3,K,TEMP_REG,2,2
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L2x2_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L2x2_SUB4

LDGEMM_L2x2_LOOP_START:

	LOAD2x2_1
	KERNEL2x2_I1
	KERNEL2x2_2
	KERNEL2x2_1
	KERNEL2x2_2

	KERNEL2x2_1
	KERNEL2x2_2
	KERNEL2x2_1
	KERNEL2x2_2

	addic.		L,	L,	-2
	ble		LDGEMM_L2x2_LOOP_END

	MY_ALIGN

LDGEMM_L2x2_LOOP:

	KERNEL2x2_1
	KERNEL2x2_2
	KERNEL2x2_1
	KERNEL2x2_2

	KERNEL2x2_1
	KERNEL2x2_2
	KERNEL2x2_1
	KERNEL2x2_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x2_LOOP

LDGEMM_L2x2_LOOP_END:

	KERNEL2x2_1
	KERNEL2x2_2
	KERNEL2x2_1
	KERNEL2x2_2

	KERNEL2x2_1
	KERNEL2x2_2
	KERNEL2x2_1
	KERNEL2x2_E2

	b		LDGEMM_L2x2_SUB1

LDGEMM_L2x2_SUB4:

	KERNEL2x2_SUBI1
	KERNEL2x2_SUB1
	KERNEL2x2_SUB1
	KERNEL2x2_SUB1

	KERNEL2x2_SUB1
	KERNEL2x2_SUB1
	KERNEL2x2_SUB1
	KERNEL2x2_SUB1

	b		LDGEMM_L2x2_SUB1

LDGEMM_L2x2_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL2x2_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L2x2_SAVE
	b		LDGEMM_L2x2_SUB2

LDGEMM_L2x2_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L2x2_SAVE

LDGEMM_L2x2_SUB2:

	KERNEL2x2_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x2_SUB2

LDGEMM_L2x2_SAVE:

	SAVE2x2
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,2,2
#endif
LDGEMM_L2x2_END:

LDGEMM_L2x1_BEGIN:


	andi.		T1,	M,	1
	ble		LDGEMM_L2x1_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,1,2
    REFRESH_TEMP_BK T3,K,TEMP_REG,1,2
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L2x1_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L2x1_SUB4

LDGEMM_L2x1_LOOP_START:

	LOAD2x1_1
	KERNEL2x1_I1
	KERNEL2x1_2
	KERNEL2x1_1
	KERNEL2x1_2

	KERNEL2x1_1
	KERNEL2x1_2
	KERNEL2x1_1
	KERNEL2x1_2

	addic.		L,	L,	-2
	ble		LDGEMM_L2x1_LOOP_END

	MY_ALIGN

LDGEMM_L2x1_LOOP:

	KERNEL2x1_1
	KERNEL2x1_2
	KERNEL2x1_1
	KERNEL2x1_2

	KERNEL2x1_1
	KERNEL2x1_2
	KERNEL2x1_1
	KERNEL2x1_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x1_LOOP

LDGEMM_L2x1_LOOP_END:

	KERNEL2x1_1
	KERNEL2x1_2
	KERNEL2x1_1
	KERNEL2x1_2

	KERNEL2x1_1
	KERNEL2x1_2
	KERNEL2x1_1
	KERNEL2x1_E2

	b		LDGEMM_L2x1_SUB1

LDGEMM_L2x1_SUB4:

	KERNEL2x1_SUBI1
	KERNEL2x1_SUB1
	KERNEL2x1_SUB1
	KERNEL2x1_SUB1

	KERNEL2x1_SUB1
	KERNEL2x1_SUB1
	KERNEL2x1_SUB1
	KERNEL2x1_SUB1

	b		LDGEMM_L2x1_SUB1

LDGEMM_L2x1_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL2x1_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L2x1_SAVE
	b		LDGEMM_L2x1_SUB2

LDGEMM_L2x1_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L2x1_SAVE

LDGEMM_L2x1_SUB2:

	KERNEL2x1_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L2x1_SUB2

LDGEMM_L2x1_SAVE:

	SAVE2x1
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,1,2
#endif
LDGEMM_L2x1_END:

	slwi		T1,	K,	4
	add		B,	B,	T1
#if defined(TRMMKERNEL) && !defined(LEFT)
    addi TEMP_REG, TEMP_REG, 2
#endif
LDGEMM_L2_END:
LDGEMM_L1_BEGIN:

#if defined(TRMMKERNEL) && defined(LEFT)
	mr TEMP_REG, OFFSET	 /*off = offset;*/
#endif 
	andi.		T1,	N,	1
	ble		LDGEMM_L1_END
	mr		CO,	C
	mr		AO,	A
	srawi.		I,	M,	4
	ble		LDGEMM_L1x16_END

LDGEMM_L1x16_BEGIN:


#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,16,1
    REFRESH_TEMP_BK T3,K,TEMP_REG,16,1
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L1x16_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L1x16_SUB4

LDGEMM_L1x16_LOOP_START:

	#dcbt		AO,	PRE
	LOAD1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_I1
	#dcbt		AO,	PRE
	KERNEL1x16_2
	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2

	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2
	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2

	addic.		L,	L,	-2
	ble		LDGEMM_L1x16_LOOP_END

	MY_ALIGN

LDGEMM_L1x16_LOOP:

	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2
	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2

	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2
	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x16_LOOP

LDGEMM_L1x16_LOOP_END:

	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2
	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2

	#dcbt		AO,	PRE
	KERNEL1x16_1
	#dcbt		AO,	PRE
	KERNEL1x16_2
	#dcbt		AO,	PRE
	KERNEL1x16_1
	KERNEL1x16_E2

	b		LDGEMM_L1x16_SUB1

LDGEMM_L1x16_SUB4:

	#dcbt		AO,	PRE
	KERNEL1x16_SUBI1
	#dcbt		AO,	PRE
	KERNEL1x16_SUB1
	#dcbt		AO,	PRE
	KERNEL1x16_SUB1
	#dcbt		AO,	PRE
	KERNEL1x16_SUB1

	KERNEL1x16_SUB1
	KERNEL1x16_SUB1
	KERNEL1x16_SUB1
	KERNEL1x16_SUB1

	b		LDGEMM_L1x16_SUB1

LDGEMM_L1x16_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL1x16_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L1x16_SAVE
	b		LDGEMM_L1x16_SUB2

LDGEMM_L1x16_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L1x16_SAVE

LDGEMM_L1x16_SUB2:

	KERNEL1x16_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x16_SUB2

LDGEMM_L1x16_SAVE:

	SAVE1x16
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,16,1
#endif
	addic.		I,	I,	-1
	bgt		LDGEMM_L1x16_BEGIN

LDGEMM_L1x16_END:

LDGEMM_L1x8_BEGIN:

	andi.		T2,	M,	15
	ble		LDGEMM_L1x1_END

	andi.		T1,	M,	8
	ble		LDGEMM_L1x8_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,8,1
    REFRESH_TEMP_BK T3,K,TEMP_REG,8,1
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L1x8_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L1x8_SUB4

LDGEMM_L1x8_LOOP_START:

	#dcbt	AO,	PRE
	LOAD1x8_1
	KERNEL1x8_I1
	#dcbt	AO,	PRE
	KERNEL1x8_2
	KERNEL1x8_1
	#dcbt	AO,	PRE
	KERNEL1x8_2

	KERNEL1x8_1
	#dcbt	AO,	PRE
	KERNEL1x8_2
	KERNEL1x8_1
	#dcbt	AO,	PRE
	KERNEL1x8_2

	addic.		L,	L,	-2
	ble		LDGEMM_L1x8_LOOP_END

	MY_ALIGN

LDGEMM_L1x8_LOOP:

	KERNEL1x8_1
	#dcbt	AO,	PRE
	KERNEL1x8_2
	KERNEL1x8_1
	#dcbt	AO,	PRE
	KERNEL1x8_2

	KERNEL1x8_1
	#dcbt	AO,	PRE
	KERNEL1x8_2
	KERNEL1x8_1
	#dcbt	AO,	PRE
	KERNEL1x8_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x8_LOOP

LDGEMM_L1x8_LOOP_END:

	KERNEL1x8_1
	KERNEL1x8_2
	KERNEL1x8_1
	KERNEL1x8_2

	KERNEL1x8_1
	KERNEL1x8_2
	KERNEL1x8_1
	KERNEL1x8_E2

	b		LDGEMM_L1x8_SUB1

LDGEMM_L1x8_SUB4:

	KERNEL1x8_SUBI1
	KERNEL1x8_SUB1
	KERNEL1x8_SUB1
	KERNEL1x8_SUB1

	KERNEL1x8_SUB1
	KERNEL1x8_SUB1
	KERNEL1x8_SUB1
	KERNEL1x8_SUB1

	b		LDGEMM_L1x8_SUB1

LDGEMM_L1x8_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL1x8_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L1x8_SAVE
	b		LDGEMM_L1x8_SUB2

LDGEMM_L1x8_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L1x8_SAVE

LDGEMM_L1x8_SUB2:

	KERNEL1x8_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x8_SUB2

LDGEMM_L1x8_SAVE:

	SAVE1x8
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,8,1
#endif
LDGEMM_L1x8_END:

LDGEMM_L1x4_BEGIN:


	andi.		T1,	M,	4
	ble		LDGEMM_L1x4_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,4,1
    REFRESH_TEMP_BK T3,K,TEMP_REG,4,1
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L1x4_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L1x4_SUB4

LDGEMM_L1x4_LOOP_START:

	LOAD1x4_1
	KERNEL1x4_I1
	KERNEL1x4_2
	KERNEL1x4_1
	KERNEL1x4_2

	KERNEL1x4_1
	KERNEL1x4_2
	KERNEL1x4_1
	KERNEL1x4_2

	addic.		L,	L,	-2
	ble		LDGEMM_L1x4_LOOP_END

	MY_ALIGN

LDGEMM_L1x4_LOOP:

	KERNEL1x4_1
	KERNEL1x4_2
	KERNEL1x4_1
	KERNEL1x4_2

	KERNEL1x4_1
	KERNEL1x4_2
	KERNEL1x4_1
	KERNEL1x4_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x4_LOOP

LDGEMM_L1x4_LOOP_END:

	KERNEL1x4_1
	KERNEL1x4_2
	KERNEL1x4_1
	KERNEL1x4_2

	KERNEL1x4_1
	KERNEL1x4_2
	KERNEL1x4_1
	KERNEL1x4_E2

	b		LDGEMM_L1x4_SUB1

LDGEMM_L1x4_SUB4:

	KERNEL1x4_SUBI1
	KERNEL1x4_SUB1
	KERNEL1x4_SUB1
	KERNEL1x4_SUB1

	KERNEL1x4_SUB1
	KERNEL1x4_SUB1
	KERNEL1x4_SUB1
	KERNEL1x4_SUB1

	b		LDGEMM_L1x4_SUB1

LDGEMM_L1x4_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL1x4_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L1x4_SAVE
	b		LDGEMM_L1x4_SUB2

LDGEMM_L1x4_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L1x4_SAVE

LDGEMM_L1x4_SUB2:

	KERNEL1x4_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x4_SUB2

LDGEMM_L1x4_SAVE:

	SAVE1x4
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,4,1
#endif
LDGEMM_L1x4_END:

LDGEMM_L1x2_BEGIN:


	andi.		T1,	M,	2
	ble		LDGEMM_L1x2_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,2,1
    REFRESH_TEMP_BK T3,K,TEMP_REG,2,1
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L1x2_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L1x2_SUB4

LDGEMM_L1x2_LOOP_START:

	LOAD1x2_1
	KERNEL1x2_I1
	KERNEL1x2_2
	KERNEL1x2_1
	KERNEL1x2_2

	KERNEL1x2_1
	KERNEL1x2_2
	KERNEL1x2_1
	KERNEL1x2_2

	addic.		L,	L,	-2
	ble		LDGEMM_L1x2_LOOP_END

	MY_ALIGN

LDGEMM_L1x2_LOOP:

	KERNEL1x2_1
	KERNEL1x2_2
	KERNEL1x2_1
	KERNEL1x2_2

	KERNEL1x2_1
	KERNEL1x2_2
	KERNEL1x2_1
	KERNEL1x2_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x2_LOOP

LDGEMM_L1x2_LOOP_END:

	KERNEL1x2_1
	KERNEL1x2_2
	KERNEL1x2_1
	KERNEL1x2_2

	KERNEL1x2_1
	KERNEL1x2_2
	KERNEL1x2_1
	KERNEL1x2_E2

	b		LDGEMM_L1x2_SUB1

LDGEMM_L1x2_SUB4:

	KERNEL1x2_SUBI1
	KERNEL1x2_SUB1
	KERNEL1x2_SUB1
	KERNEL1x2_SUB1

	KERNEL1x2_SUB1
	KERNEL1x2_SUB1
	KERNEL1x2_SUB1
	KERNEL1x2_SUB1

	b		LDGEMM_L1x2_SUB1

LDGEMM_L1x2_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL1x2_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L1x2_SAVE
	b		LDGEMM_L1x2_SUB2

LDGEMM_L1x2_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L1x2_SAVE

LDGEMM_L1x2_SUB2:

	KERNEL1x2_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x2_SUB2

LDGEMM_L1x2_SAVE:

	SAVE1x2
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,2,1
#endif
LDGEMM_L1x2_END:

LDGEMM_L1x1_BEGIN:


	andi.		T1,	M,	1
	ble		LDGEMM_L1x1_END
#if defined(TRMMKERNEL)
    REFRESH_POINTERS  AO,BO,TEMP_REG,B,1,1
    REFRESH_TEMP_BK T3,K,TEMP_REG,1,1
    srawi.		L, T3,	3	
#else
	mr		BO,	B
	srawi.		L,	K,	3	
#endif	
	ble		LDGEMM_L1x1_SUB0
	cmpwi		cr0,	L,	1
	ble		LDGEMM_L1x1_SUB4

LDGEMM_L1x1_LOOP_START:

	LOAD1x1_1
	KERNEL1x1_I1
	KERNEL1x1_2
	KERNEL1x1_1
	KERNEL1x1_2

	KERNEL1x1_1
	KERNEL1x1_2
	KERNEL1x1_1
	KERNEL1x1_2

	addic.		L,	L,	-2
	ble		LDGEMM_L1x1_LOOP_END

	MY_ALIGN

LDGEMM_L1x1_LOOP:

	KERNEL1x1_1
	KERNEL1x1_2
	KERNEL1x1_1
	KERNEL1x1_2

	KERNEL1x1_1
	KERNEL1x1_2
	KERNEL1x1_1
	KERNEL1x1_2

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x1_LOOP

LDGEMM_L1x1_LOOP_END:

	KERNEL1x1_1
	KERNEL1x1_2
	KERNEL1x1_1
	KERNEL1x1_2

	KERNEL1x1_1
	KERNEL1x1_2
	KERNEL1x1_1
	KERNEL1x1_E2

	b		LDGEMM_L1x1_SUB1

LDGEMM_L1x1_SUB4:

	KERNEL1x1_SUBI1
	KERNEL1x1_SUB1
	KERNEL1x1_SUB1
	KERNEL1x1_SUB1

	KERNEL1x1_SUB1
	KERNEL1x1_SUB1
	KERNEL1x1_SUB1
	KERNEL1x1_SUB1

	b		LDGEMM_L1x1_SUB1

LDGEMM_L1x1_SUB0:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif

	KERNEL1x1_SUBI1

	addic.		L,	L,	-1
	ble		LDGEMM_L1x1_SAVE
	b		LDGEMM_L1x1_SUB2

LDGEMM_L1x1_SUB1:
#if defined(TRMMKERNEL)
	andi.		L,	T3,	7
#else
	andi.		L,	K,	7
#endif
	ble		LDGEMM_L1x1_SAVE

LDGEMM_L1x1_SUB2:

	KERNEL1x1_SUB1

	addic.		L,	L,	-1
	bgt		LDGEMM_L1x1_SUB2

LDGEMM_L1x1_SAVE:

	SAVE1x1
#if defined(TRMMKERNEL)	
	REFRESH_AFTER_SAVE T3,K,TEMP_REG,BO,AO,1,1
#endif
LDGEMM_L1x1_END:
#if defined(TRMMKERNEL) && !defined(LEFT)
    addi TEMP_REG, TEMP_REG, 1
#endif
LDGEMM_L1_END:
