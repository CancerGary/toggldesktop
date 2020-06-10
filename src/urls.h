// Copyright 2015 Toggl Desktop developers.

#ifndef SRC_URLS_H_
#define SRC_URLS_H_

#include <string>

namespace toggl {

namespace urls {

std::string Main();
std::string API();
std::string SyncAPI();
std::string TimelineUpload();
std::string WebSocket();

void SetUseStagingAsBackend(const bool value);

bool IsUsingStagingAsBackend();

bool RequestsAllowed();

void SetRequestsAllowed(const bool value);

bool ImATeapot();

void SetImATeapot(const bool value);

}  // namespace urls

}  // namespace toggl

#endif  // SRC_URLS_H_
