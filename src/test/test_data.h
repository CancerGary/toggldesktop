// Copyright 2014 Toggl Track developers.

#ifndef SRC_TEST_TEST_DATA_H_
#define SRC_TEST_TEST_DATA_H_

#include <string>

std::string loadTestData();
std::string loadFromTestDataDir(const std::string &filename);
std::string loadTestDataFile(const std::string &filename);

#endif  // SRC_TEST_TEST_DATA_H_
