// Copyright 2015 Toggl Track developers.

#ifndef SRC_NETCONF_H_
#define SRC_NETCONF_H_

#include <string>
#include <vector>

#include "types.h"

namespace Poco {

namespace Net {

class HTTPClientSession;

}  // namespace Net

}  // namespace Poco

namespace toggl {

class TOGGL_INTERNAL_EXPORT Netconf {
 public:
    Netconf() {}
    virtual ~Netconf() {}

    static error ConfigureProxy(
        const std::string &encoded_url,
        Poco::Net::HTTPClientSession *session);

 private:
    static error autodetectProxy(
        const std::string &encoded_url,
        std::vector<std::string> *proxy_strings);
};

}  // namespace toggl

#endif  // SRC_NETCONF_H_
