#include <stdio.h>
#include <dlfcn.h>
typedef int (*fptr)(int,int); // A function pointer for equating signatures (int,int)->int
int main()
{
    int a,b;
    char op[6];
    while(1)
    {
        if(scanf("%s%d%d",op,&a,&b)!=3) break; //terminate when no of arguments not equal to 3
        char lib[20]; // a string of the form ./libop.so as used for handle
        sprintf(lib,"./lib%s.so",op);
        void *handle=dlopen(lib,RTLD_LAZY); //bringing the library into memory
        fptr operation=dlsym(handle,op); // assign operation at run time
        int result=operation(a,b);
        printf("%d\n",result);
        dlclose(handle); //closing library to free memory
    }
    return 0;
}
