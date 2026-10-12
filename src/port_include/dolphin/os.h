#ifndef SMS_PORT_DOLPHIN_OS_H
#define SMS_PORT_DOLPHIN_OS_H

#include_next <dolphin/os.h>

#if defined(__EMSCRIPTEN__)
#undef OSPhysicalToCached
#undef OSPhysicalToUncached
#undef OSCachedToPhysical
#undef OSUncachedToPhysical
#undef OSCachedToUncached
#undef OSUncachedToCached
#define OSPhysicalToCached(paddr) port_mem1_address((u32)(paddr))
#define OSPhysicalToUncached(paddr) port_mem1_address((u32)(paddr))
#define OSCachedToPhysical(caddr) port_mem1_offset((const void*)(caddr))
#define OSUncachedToPhysical(ucaddr) port_mem1_offset((const void*)(ucaddr))
#define OSCachedToUncached(caddr) ((void*)(caddr))
#define OSUncachedToCached(ucaddr) ((void*)(ucaddr))
#endif

#endif