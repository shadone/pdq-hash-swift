#include "downscaling.h"
#include "pdqhashing.h"
#include "pdqhashtypes.h"

void pdqHash256(
    float* data,
    int numRows,
    int numCols,
    facebook::pdq::hashing::Hash256& hash,
    int& quality) {
  float* fullBuffer2 = new float[numRows * numCols];
  float buffer64x64[64][64];
  float buffer16x64[16][64];
  float buffer16x16[16][16];

  pdqHash256FromFloatLuma(
      data,
      fullBuffer2,
      numRows,
      numCols,
      buffer64x64,
      buffer16x64,
      buffer16x16,
      hash,
      quality);

  delete[] fullBuffer2;
}

extern "C" {
int pdq_from_luma_data(
    const float* data,
    int numRows,
    int numCols,
    std::uint16_t* hash,
    int* quality) {
  facebook::pdq::hashing::Hash256 hash256;
  pdqHash256(const_cast<float*>(data), numRows, numCols, hash256, *quality);
  for (int i = 0; i < 16; i++) {
    hash[i] = hash256.w[i];
  }
  return 0;
}
}