# Prevent re-defining the package target
if(TARGET OIDN::OIDN)
  return()
endif()

if(WIN32)
    set(OIDN_BUILD_CONFIG "windows-x64")
elseif(UNIX)
    set(OIDN_BUILD_CONFIG "linux-x64")
endif()

# Once the prioritized find_path succeeds the result variable will be set and stored in the cache
# so that no call will search again.
find_path(OIDN_INCLUDE_DIR                       # Set variable OIDN_INCLUDE_DIR
          OpenImageDenoise/oidn.h                # Find a path with oidn.h
          DOC "path to OIDN header files"
)
find_library(OIDN_LIBRARY       # Set variable OIDN_LIBRARY
             OpenImageDenoise   # Find library path with OpenImageDenoise.lib or OpenImageDenoise_core.lib
             DOC "path to OIDN library files"
)
find_library(OIDN_CORE_LIBRARY       # Set variable OIDN_CORE_LIBRARY
             OpenImageDenoise_core   # Find library path with OpenImageDenoise.lib or OpenImageDenoise_core.lib
             DOC "path to OIDN Core library file"
)
find_program(OIDN_DLL_DIR              # Set variable OIDN_DLL_DIR
             OpenImageDenoise.dll      # Find library path with OpenImageDenoise.dll or OpenImageDenoise_core.dll
             DOC "path to OIDN DLL library file"
)

set(OIDN_LIBRARIES ${OIDN_LIBRARY} ${OIDN_CORE_LIBRARY})
set(OIDN_INCLUDE_DIRS ${OIDN_INCLUDE_DIR})

get_filename_component(OIDN_LIBRARY_DIR ${OIDN_DLL_DIR} DIRECTORY)
if(WIN32)
    file(GLOB OIDN_LIBRARY_DLLS ${OIDN_LIBRARY_DIR}/*.dll)
endif()

include(FindPackageHandleStandardArgs)
# Handle the QUIETLY and REQUIRED arguments and set OIDN_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(oidn
                                  DEFAULT_MSG
                                  OIDN_INCLUDE_DIRS
                                  OIDN_LIBRARIES
)

if(OIDN_FOUND)
    add_library(OIDN::OIDN UNKNOWN IMPORTED)
 	set_target_properties(OIDN::OIDN PROPERTIES
		IMPORTED_LOCATION ${OIDN_LIBRARY} 
	    IMPORTED_LOCATION ${OIDN_CORE_LIBRARY}
		IMPORTED_LINK_INTERFACE_LIBRARIES "${OIDN_LIBRARIES}"
        INTERFACE_INCLUDE_DIRECTORIES "${OIDN_INCLUDE_DIRS}"
    )
endif()

mark_as_advanced(
    OIDN_INCLUDE_DIRS
    OIDN_INCLUDE_DIR
    OIDN_LIBRARIES
    OIDN_LIBRARY
	OIDN_CORE_LIBRARY
	OIDN_DLL_DIR
    OIDN_LIBRARY_DIR
    OIDN_LIBRARY_DLLS
)
