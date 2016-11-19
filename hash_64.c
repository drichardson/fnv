/*
 * hash_64 - 64 bit Fowler/Noll/Vo-0 hash code
 *
 * @(#) $Revision: 5.1 $
 * @(#) $Id: hash_64.c,v 5.1 2009/06/30 09:01:38 chongo Exp $
 * @(#) $Source: /usr/local/src/cmd/fnv/RCS/hash_64.c,v $
 *
 ***
 *
 * Fowler/Noll/Vo hash
 *
 * The basis of this hash algorithm was taken from an idea sent
 * as reviewer comments to the IEEE POSIX P1003.2 committee by:
 *
 *      Phong Vo (http://www.research.att.com/info/kpv/)
 *      Glenn Fowler (http://www.research.att.com/~gsf/)
 *
 * In a subsequent ballot round:
 *
 *      Landon Curt Noll (http://www.isthe.com/chongo/)
 *
 * improved on their algorithm.  Some people tried this hash
 * and found that it worked rather well.  In an EMail message
 * to Landon, they named it the ``Fowler/Noll/Vo'' or FNV hash.
 *
 * FNV hashes are designed to be fast while maintaining a low
 * collision rate. The FNV speed allows one to quickly hash lots
 * of data while maintaining a reasonable collision rate.  See:
 *
 *      http://www.isthe.com/chongo/tech/comp/fnv/index.html
 *
 * for more details as well as other forms of the FNV hash.
 *
 ***
 *
 * NOTE: The FNV-0 historic hash is not recommended.  One should use
 *	 the FNV-1 hash instead.
 *
 * To use the 64 bit FNV-0 historic hash, pass FNV0_64_INIT as the
 * Fnv64_t hashval argument to fnv_64_buf() or fnv_64_str().
 *
 * To use the recommended 64 bit FNV-1 hash, pass FNV1_64_INIT as the
 * Fnv64_t hashval argument to fnv_64_buf() or fnv_64_str().
 *
 ***
 *
 * Please do not copyright this code.  This code is in the public domain.
 *
 * LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
 * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
 * EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
 * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 *
 * By:
 *	chongo <Landon Curt Noll> /\oo/\
 *      http://www.isthe.com/chongo/
 *
 * Share and Enjoy!	:-)
 */

#include <stdlib.h>
#include "fnv.h"


/*
 * 64 bit magic FNV-0 and FNV-1 prime
 */
#define FNV_64_PRIME ((Fnv64_t)0x100000001b3ULL)


/*
 * fnv_64_buf - perform a 64 bit Fowler/Noll/Vo hash on a buffer
 *
 * input:
 *	buf	- start of buffer to hash
 *	len	- length of buffer in octets
 *	hval	- previous hash value or 0 if first call
 *
 * returns:
 *	64 bit hash as a static hash type
 *
 * NOTE: To use the 64 bit FNV-0 historic hash, use FNV0_64_INIT as the hval
 *	 argument on the first call to either fnv_64_buf() or fnv_64_str().
 *
 * NOTE: To use the recommended 64 bit FNV-1 hash, use FNV1_64_INIT as the hval
 *	 argument on the first call to either fnv_64_buf() or fnv_64_str().
 */
Fnv64_t
fnv_64_buf(const void *buf, size_t len, Fnv64_t hval)
{
    const unsigned char *bp = (const unsigned char *)buf;	/* start of buffer */
    const unsigned char *be = bp + len;		/* beyond end of buffer */

    /*
     * FNV-1 hash each octet of the buffer
     */
    while (bp < be) {

	/* multiply by the 64 bit FNV magic prime mod 2^64 */
#if defined(NO_FNV_GCC_OPTIMIZATION)
	hval *= FNV_64_PRIME;
#else /* NO_FNV_GCC_OPTIMIZATION */
	hval += (hval << 1) + (hval << 4) + (hval << 5) +
		(hval << 7) + (hval << 8) + (hval << 40);
#endif /* NO_FNV_GCC_OPTIMIZATION */

	/* xor the bottom with the current octet */
	hval ^= (Fnv64_t)*bp++;
    }

    /* return our new hash value */
    return hval;
}


/*
 * fnv_64_str - perform a 64 bit Fowler/Noll/Vo hash on a buffer
 *
 * input:
 *	buf	- start of buffer to hash
 *	hval	- previous hash value or 0 if first call
 *
 * returns:
 *	64 bit hash as a static hash type
 *
 * NOTE: To use the 64 bit FNV-0 historic hash, use FNV0_64_INIT as the hval
 *	 argument on the first call to either fnv_64_buf() or fnv_64_str().
 *
 * NOTE: To use the recommended 64 bit FNV-1 hash, use FNV1_64_INIT as the hval
 *	 argument on the first call to either fnv_64_buf() or fnv_64_str().
 */
Fnv64_t
fnv_64_str(const char *str, Fnv64_t hval)
{
    const unsigned char *s = (const unsigned char *)str;	/* unsigned string */

    /*
     * FNV-1 hash each octet of the string
     */
    while (*s) {

	/* multiply by the 64 bit FNV magic prime mod 2^64 */
#if defined(NO_FNV_GCC_OPTIMIZATION)
	hval *= FNV_64_PRIME;
#else /* NO_FNV_GCC_OPTIMIZATION */
	hval += (hval << 1) + (hval << 4) + (hval << 5) +
		(hval << 7) + (hval << 8) + (hval << 40);
#endif /* NO_FNV_GCC_OPTIMIZATION */

	/* xor the bottom with the current octet */
	hval ^= (Fnv64_t)*s++;
    }

    /* return our new hash value */
    return hval;
}
