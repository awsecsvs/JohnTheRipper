#!/bin/sh
#
#  This script generates the source file dynamic_big_crypt.c
#

# first build the filter that sed replaces the variable items
# and removes sections that should be 'undefined'. It will
# use command line to be told how to edit the file, and it
# uses the specially crafted dynamic_big_crypt_hash.cin file.
# if we can not build this exe, or run it, then we MUST bail,
# and the makefile will copy a prebuilt version for us.
rm -f dynamic_big_crypt_chopper
rm -f dynamic_big_crypt_chopper.exe
rm -f dynamic_big_crypt.c
gcc -O dynamic_big_crypt_chopper.c -o dynamic_big_crypt_chopper || exit 1
./dynamic_big_crypt_chopper TEST || exit 1

# first timestamp the file generation.
echo "/*" > xxx
echo " * The source for this file AUTO-GENERATED on:" >> xxx
echo " * `date`" >> xxx
echo " *" >> xxx

# now add a STRONG warning
cat <<_EOF >>xxx
 * NOTE.  This file IS 100% auto-generated code.
 *
 * **DO NOT** edit any portion of this .c file. ANY change
 * made to this file WILL BE LOST, the next time the
 * ./configure script is run.
 *
 * If bugs are found, then they must be fixed in the file(s)
 * of dynamic_big_crypt_header.cin, which is the 'common'
 * functions, data and includes used by all hashes, OR
 * the bug must be fixed (carefully) in the file
 * dynamic_big_crypt_hash.cin   This second file is
 * a 100% common file.  Each of the hashes we have, MUST
 * be able to be run from this file, after it is run
 * through the dynamic_big_crypt_chopper filter program
 * which was built specifically for this task. The
 * existing command line arguments which run
 * dynamic_big_crypt_chopper are in the shell script
 * dynamic_big_crypt_generator.sh which is the script
 * what actually generated THIS file.
 */
 
_EOF

# append the header (which starts with a #ifndef DYNAMIC_DISABLED
cat dynamic_big_crypt_header.cin >> xxx

# now generate a section for each hash
./dynamic_big_crypt_chopper BITS=32 HASH=MD5        PARAHASH=MD5        BIN_SZ=16 BIN_REAL_SZ=16 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=MD5_CTX                HASH_Init=MD5_Init            HASH_Update=MD5_Update       HASH_Final=MD5_Final            SSEBody=SSEmd5body    SSE_LIMBS=4 SSEFLAGS=' '                    UNDEFINED=TRUNC_TO16                                < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=MD4        PARAHASH=MD4        BIN_SZ=16 BIN_REAL_SZ=16 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=MD4_CTX                HASH_Init=MD4_Init            HASH_Update=MD4_Update       HASH_Final=MD4_Final            SSEBody=SSEmd4body    SSE_LIMBS=4 SSEFLAGS=' '                    UNDEFINED=TRUNC_TO16                                < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=SHA1       PARAHASH=SHA1       BIN_SZ=20 BIN_REAL_SZ=20 BE_HASH=1 JSWAPH='JOHNSWAP('   JSWAPT=');'  HASH_CTX=SHA_CTX                HASH_Init=SHA1_Init           HASH_Update=SHA1_Update      HASH_Final=SHA1_Final           SSEBody=SSESHA1body   SSE_LIMBS=4 SSEFLAGS=' '                      DEFINED=TRUNC_TO16                                < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=SHA224     PARAHASH=SHA256     BIN_SZ=32 BIN_REAL_SZ=28 BE_HASH=1 JSWAPH='JOHNSWAP('   JSWAPT=');'  HASH_CTX=SHA256_CTX             HASH_Init=SHA224_Init         HASH_Update=SHA256_Update    HASH_Final=SHA256_Final         SSEBody=SSESHA256body SSE_LIMBS=4 SSEFLAGS='|SSEi_CRYPT_SHA224'     DEFINED=TRUNC_TO16                                < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=SHA256     PARAHASH=SHA256     BIN_SZ=32 BIN_REAL_SZ=32 BE_HASH=1 JSWAPH='JOHNSWAP('   JSWAPT=');'  HASH_CTX=SHA256_CTX             HASH_Init=SHA256_Init         HASH_Update=SHA256_Update    HASH_Final=SHA256_Final         SSEBody=SSESHA256body SSE_LIMBS=4 SSEFLAGS=' '                      DEFINED=TRUNC_TO16                                < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=64 HASH=SHA384     PARAHASH=SHA512     BIN_SZ=64 BIN_REAL_SZ=48 BE_HASH=1 JSWAPH='JOHNSWAP64(' JSWAPT=');'  HASH_CTX=SHA512_CTX             HASH_Init=SHA384_Init         HASH_Update=SHA512_Update    HASH_Final=SHA512_Final         SSEBody=SSESHA512body SSE_LIMBS=2 SSEFLAGS='|SSEi_CRYPT_SHA384'     DEFINED=TRUNC_TO16                                < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=64 HASH=SHA512     PARAHASH=SHA512     BIN_SZ=64 BIN_REAL_SZ=64 BE_HASH=1 JSWAPH='JOHNSWAP64(' JSWAPT=');'  HASH_CTX=SHA512_CTX             HASH_Init=SHA512_Init         HASH_Update=SHA512_Update    HASH_Final=SHA512_Final         SSEBody=SSESHA512body SSE_LIMBS=2 SSEFLAGS=' '                      DEFINED=TRUNC_TO16                                < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=GOST       PARAHASH=GOST       BIN_SZ=32 BIN_REAL_SZ=32 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=gost_ctx               HASH_Init=john_gost_init      HASH_Update=john_gost_update HASH_Final=john_gost_final      SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_GOST       < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=64 HASH=WHIRLPOOL  PARAHASH=WHIRLPOOL  BIN_SZ=64 BIN_REAL_SZ=64 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=WHIRLPOOL_CTX          HASH_Init=WHIRLPOOL_Init      HASH_Update=WHIRLPOOL_Update HASH_Final=WHIRLPOOL_Final      SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_WHIRLPOOL  < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=Tiger      PARAHASH=Tiger      BIN_SZ=24 BIN_REAL_SZ=24 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_tiger_context      HASH_Init=sph_tiger_init      HASH_Update=sph_tiger        HASH_Final=sph_tiger_close      SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_Tiger      < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=RIPEMD128  PARAHASH=RIPEMD128  BIN_SZ=16 BIN_REAL_SZ=16 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_ripemd128_context  HASH_Init=sph_ripemd128_init  HASH_Update=sph_ripemd128    HASH_Final=sph_ripemd128_close  SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                    UNDEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_RIPEMD128  < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=RIPEMD160  PARAHASH=RIPEMD160  BIN_SZ=20 BIN_REAL_SZ=20 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_ripemd160_context  HASH_Init=sph_ripemd160_init  HASH_Update=sph_ripemd160    HASH_Final=sph_ripemd160_close  SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_RIPEMD160  < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=RIPEMD256  PARAHASH=RIPEMD256  BIN_SZ=32 BIN_REAL_SZ=32 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_ripemd256_context  HASH_Init=sph_ripemd256_init  HASH_Update=sph_ripemd256    HASH_Final=sph_ripemd256_close  SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_RIPEMD256  < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=RIPEMD320  PARAHASH=RIPEMD320  BIN_SZ=40 BIN_REAL_SZ=40 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_ripemd320_context  HASH_Init=sph_ripemd320_init  HASH_Update=sph_ripemd320    HASH_Final=sph_ripemd320_close  SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_RIPEMD320  < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL128_3 PARAHASH=HAVAL128_3 BIN_SZ=16 BIN_REAL_SZ=16 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval128_3_context HASH_Init=sph_haval128_3_init HASH_Update=sph_haval128_3   HASH_Final=sph_haval128_3_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL128_3 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL128_4 PARAHASH=HAVAL128_4 BIN_SZ=16 BIN_REAL_SZ=16 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval128_4_context HASH_Init=sph_haval128_4_init HASH_Update=sph_haval128_4   HASH_Final=sph_haval128_4_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL128_4 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL128_5 PARAHASH=HAVAL128_5 BIN_SZ=16 BIN_REAL_SZ=16 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval128_5_context HASH_Init=sph_haval128_5_init HASH_Update=sph_haval128_5   HASH_Final=sph_haval128_5_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL128_5 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL160_3 PARAHASH=HAVAL160_3 BIN_SZ=20 BIN_REAL_SZ=20 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval160_3_context HASH_Init=sph_haval160_3_init HASH_Update=sph_haval160_3   HASH_Final=sph_haval160_3_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL160_3 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL160_4 PARAHASH=HAVAL160_4 BIN_SZ=20 BIN_REAL_SZ=20 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval160_4_context HASH_Init=sph_haval160_4_init HASH_Update=sph_haval160_4   HASH_Final=sph_haval160_4_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL160_4 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL160_5 PARAHASH=HAVAL160_5 BIN_SZ=20 BIN_REAL_SZ=20 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval160_5_context HASH_Init=sph_haval160_5_init HASH_Update=sph_haval160_5   HASH_Final=sph_haval160_5_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL160_5 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL192_3 PARAHASH=HAVAL192_3 BIN_SZ=24 BIN_REAL_SZ=24 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval192_3_context HASH_Init=sph_haval192_3_init HASH_Update=sph_haval192_3   HASH_Final=sph_haval192_3_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL192_3 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL192_4 PARAHASH=HAVAL192_4 BIN_SZ=24 BIN_REAL_SZ=24 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval192_4_context HASH_Init=sph_haval192_4_init HASH_Update=sph_haval192_4   HASH_Final=sph_haval192_4_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL192_4 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL192_5 PARAHASH=HAVAL192_5 BIN_SZ=24 BIN_REAL_SZ=24 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval192_5_context HASH_Init=sph_haval192_5_init HASH_Update=sph_haval192_5   HASH_Final=sph_haval192_5_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL192_5 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL224_3 PARAHASH=HAVAL224_3 BIN_SZ=28 BIN_REAL_SZ=28 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval224_3_context HASH_Init=sph_haval224_3_init HASH_Update=sph_haval224_3   HASH_Final=sph_haval224_3_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL224_3 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL224_4 PARAHASH=HAVAL224_4 BIN_SZ=28 BIN_REAL_SZ=28 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval224_4_context HASH_Init=sph_haval224_4_init HASH_Update=sph_haval224_4   HASH_Final=sph_haval224_4_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL224_4 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL224_5 PARAHASH=HAVAL224_5 BIN_SZ=28 BIN_REAL_SZ=28 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval224_5_context HASH_Init=sph_haval224_5_init HASH_Update=sph_haval224_5   HASH_Final=sph_haval224_5_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL224_5 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL256_3 PARAHASH=HAVAL256_3 BIN_SZ=32 BIN_REAL_SZ=32 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval256_3_context HASH_Init=sph_haval256_3_init HASH_Update=sph_haval256_3   HASH_Final=sph_haval256_3_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL256_3 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL256_4 PARAHASH=HAVAL256_4 BIN_SZ=32 BIN_REAL_SZ=32 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval256_4_context HASH_Init=sph_haval256_4_init HASH_Update=sph_haval256_4   HASH_Final=sph_haval256_4_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL256_4 < dynamic_big_crypt_hash.cin  >> xxx
./dynamic_big_crypt_chopper BITS=32 HASH=HAVAL256_5 PARAHASH=HAVAL256_5 BIN_SZ=32 BIN_REAL_SZ=32 BE_HASH=0 JSWAPH=' '           JSWAPT=';'   HASH_CTX=sph_haval256_5_context HASH_Init=sph_haval256_5_init HASH_Update=sph_haval256_5   HASH_Final=sph_haval256_5_close SSEBody=' '           SSE_LIMBS=0 SSEFLAGS=' '                      DEFINED=TRUNC_TO16 UNDEFINED=SIMD_PARA_HAVAL256_5 < dynamic_big_crypt_hash.cin  >> xxx

# now we close out the #define DYNAMIC_DISABLED started at the very top
# of dynamic_big_crypt_header.cin
echo "" >> xxx
echo '#endif // DYNAMIC_DISABLED' >> xxx
mv xxx dynamic_big_crypt.c

# clean up, and return success (we hope it builds, lol).
rm -f dynamic_big_crypt_chopper
rm -f dynamic_big_crypt_chopper.exe

exit 0