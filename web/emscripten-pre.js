const onRuntimeInitialized = Module.onRuntimeInitialized;
Module.onRuntimeInitialized = function(...args) {
  if (typeof GL !== "undefined" && typeof GL.registerContext === "function") {
    const registerContext = GL.registerContext;
    GL.registerContext = function(...contextArgs) {
      const handle = registerContext.apply(this, contextArgs);
      if (handle && typeof HEAPU32 !== "undefined") HEAPU32[(handle >>> 2) + 1] = 1;
      return handle;
    };
  }
  if (typeof JSEvents !== "undefined") {
    const getTargetThread = JSEvents.getTargetThreadForEventCallback;
    JSEvents.getTargetThreadForEventCallback = function(targetThread) {
      if (targetThread === 2) return 1;
      return getTargetThread(targetThread);
    };
  }
  if (onRuntimeInitialized) return onRuntimeInitialized.apply(this, args);
};