#ifdef __cplusplus
extern "C" {
#endif

// Declare your functions with __declspec(dllexport)
__declspec(dllexport) int add_numbers(int a, int b);
__declspec(dllexport) void print_hello();

#ifdef __cplusplus
}
#endif