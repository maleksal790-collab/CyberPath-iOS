PROJECT=CyberPath.xcodeproj
SCHEME=CyberPath
DESTINATION?=platform=iOS Simulator,name=iPhone 15

.PHONY: validate build test archive export package

validate:
	./scripts/ci/validate_structure.sh

build:
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)' build

test:
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)' test

archive:
	./scripts/release/archive_release.sh

export:
	./scripts/release/export_appstore.sh

package:
	./scripts/release/package_release.sh
