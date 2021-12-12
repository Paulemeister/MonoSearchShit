#include <sys/uio.h>
#include <errno.h>
#include <iostream>
#include <string>
#define ASSEMBLYAMOUNT 1U
#define ASSEMBLYOFFSET 20U
#define DATAOFFSET 8U
#define IMAGEOFFSET 0x60U
#define ASSEMBLYNAMEOFFSET 0x28U
#define PID 16504

void* readMem(void* addr, int size=8){
    void* data;
    struct iovec local;
    struct iovec remote;
    char* buf[size];
    local.iov_base = buf;
    local.iov_len = size;
    remote.iov_base = addr;
    remote.iov_len = size;
    process_vm_readv(PID, &local, 1, &remote, 1, 0);
    if (size==4){
        data = (void*)*(unsigned int*)buf;
    }else{
        data = (void*)*(unsigned long*)buf;
    }
    return data;
}

std::string readString(void* addr){
    std::string str = "";
    struct iovec local;
    struct iovec remote;
    char buf;
    local.iov_base = &buf;
    local.iov_len = sizeof(char);
    remote.iov_base = addr;
    remote.iov_len = sizeof(char);
    int i = 1;
    do
    {
      process_vm_readv(PID, &local, 1, &remote, 1, 0);
      str.push_back(buf);
      remote.iov_base = addr + i*sizeof(char);
      //std::cout << buf << "\n";
      if(i++>128){return "";};
      
    } while (buf!= 0);
    return str;
}


int main(int argc, char const *argv[])
{
    // can be known somehow (get it from PINCE)
    void* mono_assembly_foreach = (void*)0x00007f1eb0d595f9U;
    std::cout << mono_assembly_foreach << "\n";

    void* help2 = mono_assembly_foreach+ 25U;
    std::cout << help2 << "\n";

    void* help = readMem(help2,4);
    std::cout << help << "\n";

    void* loaded_assemblies = (void*)(mono_assembly_foreach + (unsigned long)help + 29);
    std::cout << loaded_assemblies << "\n";

    void* GList = loaded_assemblies;
    std::cout << GList << "\n";

    void* GListData;
    // iterate through linked list, stop when .next is 0
    // ?: Why check GListData!=0 and not GList!=0 ?
    while((GListData = readMem(GList)) != 0)
    {
        //void* GListData = readMem(GList);
        //std::cout << GListData << "\n";

        void* GListDataImage = readMem(GListData) + IMAGEOFFSET;
        //std::cout << GListDataImage << "\n";

        void* GListDataImageAssemblyName = readMem(GListDataImage) + ASSEMBLYNAMEOFFSET;
        void* nameptr = readMem(GListDataImageAssemblyName);
        //std::cout << nameptr << "\n";

        std::string name = readString(nameptr);
        std::cout << "AssemblyName" << 1 << ": " << name << "\n";

        GList = GListData+8;
        //std::cout << GList << "\n";
    }
    

 

    // // my own stuff, maybe it got deleted in the call
    // void* assemblyDataMaybe = readMem(assembly0);
    // std::cout << assemblyDataMaybe << "\n";

    // void* assemblyDataImage = readMem(assemblyDataMaybe) + IMAGEOFFSET;
    // std::cout << assemblyDataImage << "\n";

    // void* assemblyDataImageAssemblyName = readMem(assemblyDataImage) + ASSEMBLYNAMEOFFSET;
    // void* nameptr = readMem(assemblyDataImageAssemblyName);
    // std::cout << nameptr << "\n";

    // std::string name = readString(nameptr);
    // std::cout << "AssemblyName" << 1 << ": " << name << "\n";
    

}
