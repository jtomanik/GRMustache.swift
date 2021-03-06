# Copyright IBM Corporation 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Makefile

UNAME = ${shell uname}

CC_FLAGS =
SWIFTC_FLAGS =
LINKER_FLAGS = 
RESOURCE_DIR = ".build/debug/Mustache.xctest/Contents/Resources"

all: build

build:
	@echo --- Running build on $(UNAME)
	@echo --- Build scripts directory: ${KITURA_CI_BUILD_SCRIPTS_DIR}
	@echo --- Checking swift version
	swift --version
ifeq ($(UNAME), Linux)
	@echo --- Checking Linux release
	-lsb_release -d
	@echo --- Fetching dependencies
	swift build --fetch
endif
	@echo --- Invoking swift build
	swift build $(CC_FLAGS) $(SWIFTC_FLAGS) $(LINKER_FLAGS)

Tests/LinuxMain.swift:
ifeq ($(UNAME), Linux)
	@echo --- Generating $@
	bash generate_linux_main.sh
endif

test: build copytestresources Tests/LinuxMain.swift
	@echo --- Invoking swift test
	swift test

refetch:
	@echo --- Removing Packages directory
	rm -rf Packages
	@echo --- Fetching dependencies
	swift build --fetch

clean:
	@echo --- Invoking swift build --clean
	swift build --clean

Tests/vendor/groue/GRMustacheSpec/Tests:
	@echo --- Fetching GRMustacheSpec
	git submodule init
	git submodule update


copytestresources: Tests/vendor/groue/GRMustacheSpec/Tests
	@echo --- Copying test files
	mkdir -p ${RESOURCE_DIR}
	cp Tests/Mustache/*/*.mustache ${RESOURCE_DIR}
	cp Tests/Mustache/*/*/*.mustache ${RESOURCE_DIR}
	cp Tests/Mustache/*/*/*.text ${RESOURCE_DIR}
	cp -r Tests/Mustache/SuitesTests/twitter/hogan.js/HoganSuite ${RESOURCE_DIR}
	cp -r Tests/Mustache/TemplateRepositoryTests/TemplateRepositoryBundleTests/TemplateRepositoryBundleTests ${RESOURCE_DIR}
	cp -r Tests/Mustache/TemplateRepositoryTests/TemplateRepositoryBundleTests/TemplateRepositoryBundleTests_partial ${RESOURCE_DIR}
	cp -r Tests/Mustache/TemplateRepositoryTests/TemplateRepositoryBundleTests/TemplateRepositoryBundleTestsResources ${RESOURCE_DIR}
	cp -r Tests/Mustache/ServicesTests/LocalizerTestsBundle ${RESOURCE_DIR}
	cp -r Tests/Mustache/TemplateRepositoryTests/TemplateRepositoryFileSystemTests/TemplateRepositoryFileSystemTests ${RESOURCE_DIR}
	cp -r Tests/Mustache/TemplateRepositoryTests/TemplateRepositoryFileSystemTests/TemplateRepositoryFileSystemTests_* ${RESOURCE_DIR}
	cp -r Tests/vendor/groue/GRMustacheSpec/Tests ${RESOURCE_DIR}

.PHONY: clean build refetch run test 
