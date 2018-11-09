WINDOWS_MAJOR=$(grep HWLOC_VERSION_MAJOR hwloc_config.h | grep -oP '[0-9]')
WINDOWS_MINOR=$(grep HWLOC_VERSION_MINOR hwloc_config.h | grep -oP '[0-9]') 
WINDOWS_RELEASE=$(grep HWLOC_VERSION_RELEASE hwloc_config.h | grep -oP '[0-9]')
WINDOWS_GREEK=$(grep HWLOC_VERSION_GREEK hwloc_config.h | grep -oP '"\w*"' | tr -d \")
WINDOWS_VERSION=$WINDOWS_MAJOR.$WINDOWS_MINOR.$WINDOWS_RELEASE
WINDOWS_HWLOC_VERSION=$(grep "HWLOC_VERSION " hwloc_config.h | grep -oP '"(\w|\.)*"' | tr -d \"\.)

MAJOR=$(grep HWLOC_VERSION_MAJOR ../../include/hwloc/autogen/config.h | grep -oP '[0-9]')
MINOR=$(grep HWLOC_VERSION_MINOR ../../include/hwloc/autogen/config.h | grep -oP '[0-9]') 
RELEASE=$(grep HWLOC_VERSION_RELEASE ../../include/hwloc/autogen/config.h | grep -oP '[0-9]')
VERSION=$MAJOR.$MINOR.$RELEASE


if [ $WINDOWS_MAJOR$WINDOWS_MINOR$WINDOWS_RELEASE$WINDOWS_GREEK = $WINDOWS_HWLOC_VERSION ]
then
	echo "COMIIIIIIIIING THROOOOOOOOOGHHTT"

	if [ $WINDOWS_VERSION = $VERSION ]
	then
			echo "true"
	        return 0;
	else
			echo "false"
			return 1;
	fi
else
	echo "error getting version"
	return 1
fi
