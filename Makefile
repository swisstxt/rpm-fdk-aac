HOME=$(shell pwd)
VERSION="0.1.3"
RELEASE=$(shell /opt/buildhelper/buildhelper getgitrev .)
NAME=fdk-aac
SPEC=$(shell /opt/buildhelper/buildhelper getspec ${NAME})
ARCH=$(shell /opt/buildhelper/buildhelper getarch)
OS_RELEASE=$(shell /opt/buildhelper/buildhelper getosrelease)

all: build

clean:
	rm -rf ./rpmbuild
	rm -rf ./SOURCES
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/
	mkdir -p ./SPECS ./SOURCES

getsources:
	wget  -P ./SOURCES/ -q http://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-${VERSION}.tar.gz
	
build: clean getsources
	cp -r ./SPECS/* ./rpmbuild/SPECS/ || true
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/ || true
	rpmbuild -ba ${SPEC} \
	--define "ver ${VERSION}" \
	--define "rel ${RELEASE}" \
	--define "name ${NAME}" \
	--define "os_rel ${OS_RELEASE}" \
	--define "arch ${ARCH}" \
	--define "_topdir %(pwd)/rpmbuild" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \

publish:
	/opt/buildhelper/buildhelper pushrpm yum-01.stxt.media.int:8080/swisstxt-centos
