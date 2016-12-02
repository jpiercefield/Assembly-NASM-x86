#ifndef COMPUTE_BS
#define COMPUTE_BS

void cBsRecur(int MaxBn, int CurN, int Indx, int Times, float exStk[8], float arr[40]);
void baseCase(float exStack[8], float arr[40]);
float EvalPolynomialProc(float arr[40], float xCoord, int WhichBofN, float exStack[8]);

#endif