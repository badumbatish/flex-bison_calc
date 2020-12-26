double factorial(double n) {
    double prod=1;
    for(size_t i=1;i<=n;i++) {
        prod*=i;
    }
    return prod;
}