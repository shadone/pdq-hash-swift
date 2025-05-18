#ifndef PDQ_H
#define PDQ_H

#ifdef __cplusplus
#include <cstdint>
#else
#include <stdint.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

// Add Swift interop attributes
#if defined(__has_attribute) && __has_attribute(swift_name)
#define SWIFT_NAME(x) __attribute__((swift_name(x)))
#else
#define SWIFT_NAME(x)
#endif

/**
 * @brief Generates a PDQ hash from image data
 * @param data Pointer to the image data array (float values)
 * @param numRows Number of rows in the image
 * @param numCols Number of columns in the image
 * @param hash Output array for the 16 uint16_t hash values
 * @param quality Output parameter for the quality score
 * @return 0 on success, non-zero on failure
 */
int pdq_from_luma_data(const float *data, int numRows, int numCols,
                       uint16_t *hash, int *quality)
    SWIFT_NAME("pdqFromLumaData(data:numRows:numCols:hash:quality:)");

#ifdef __cplusplus
}
#endif

#endif
