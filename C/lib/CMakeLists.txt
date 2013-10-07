
add_library(ortc SHARED libortc.h ortc.c connection.c message.c channel.c balancer.c authentication.c presence.c dlist.c common.c)
add_library(ortc_static STATIC libortc.h ortc.c connection.c message.c channel.c balancer.c authentication.c presence.c dlist.c common.c)

target_link_libraries(ortc ${CURL_LIBRARIES} ${LWS_LIBRARIES})
target_link_libraries(ortc_static ${CURL_LIBRARIES} ${LWS_LIBRARIES})
if(NOT HAVE_REGEX_H)
  target_link_libraries(ortc ${REGEX_LIB})
  target_link_libraries(ortc_static ${REGEX_LIB})
endif()
if(NOT CMAKE_THREAD_LIBS_INIT)
  target_link_libraries(ortc ${PTHREAD_LIB})
  target_link_libraries(ortc_static ${PTHREAD_LIB})
else()
  target_link_libraries(ortc ${CMAKE_THREAD_LIBS_INIT})
  target_link_libraries(ortc_static ${CMAKE_THREAD_LIBS_INIT})
endif()

if(NOT UNIX)
  target_link_libraries(ortc Ws2_32)
  target_link_libraries(ortc_static Ws2_32)
endif()

