_lstopo() {
  	local TYPES=("Machine" "Misc" "Group" "NUMANode" "Package" "L1" "L2" "L3" "L4" "L5" "L1i" "L2i" "L3i" "Core" "Bridge" "PCIDev" "OSDev" "PU")
    # All possible first values in command line
  	local SERVICES=(-i --input --only --ignore --of --output-format --whole-system --pid --thissystem --no-io -help --filter out.format --distances
  	 			--no-bridges --whole-io --no-collapse --merge --no-icaches --no-caches --no-useless-caches --verbose -v --silent -s)
  	local cur=${COMP_WORDS[COMP_CWORD]}
  	local FORMAT=(xml fig)


 	if [ $COMP_CWORD == 1 ]; then
    	COMPREPLY=($( compgen -W "${SERVICES[*]}" -- "$cur" ))

	else
		case "$3" in
	  	-i | --input)
			if [[ "$cur" == *" "* ]]
			then
			  echo "It contains one of those"
			fi
			COMPREPLY=($(compgen  -f -X !"*.xml" -o plusdirs -- "$cur" ) ) && compopt -o nospace  -o plusdirs 
			;;
		--only | --ignore)
			COMPREPLY=( `compgen -W "${TYPES[*]}" -- "$cur"` )
			;;
		--of | --output-format)
			COMPREPLY=( `compgen -W "${FORMAT[*]}" -- "$cur"` )
			;;
		--filter)
			COMPREPLY=( `compgen -W "type:none,all,structure" -- "$cur"` )
			;;
	  	esac
	fi
}

complete -F _lstopo lstopo


_hwloc-annotate(){
	# All possible first values in command line
	local SERVICES=(--ci --ri --cu --cd -h -help)
	local cur=${COMP_WORDS[COMP_CWORD]}
	echo ${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )

	 #elif arrayContains "*xml" "${COMP_WORDS[*]}";then


	fi
}
complete -F _hwloc-annotate hwloc-annotate


_hwloc-bind(){
	# All possible first values in command line
 	local SERVICES=(--cpubind --membind --mempolicy --logical -l --physical -p --single --strict --get -e --get-last-cpu-location -help
 		--nodeset --pid --tid --taskset --restrict --whole-system --hbm --no-hbm -f --force -q --quiet -v --verbose --version -h)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )


	else
	  case "$3" in
	    --mempolicy)
	      COMPREPLY=(`compgen -W "<default|firsttouch|bind|interleave|nexttouch>" -- "$cur"`)
	      ;;
	    --pid)
	        COMPREPLY=(`compgen -W "<pid>" -- "$cur"`)
	      ;;
	    --tid)
	      COMPREPLY=(`compgen -W "<tid>" -- "$cur"`)
	      ;;
	    --restrict)
	      COMPREPLY=(`compgen -W "<set>" -- "$cur"`)
	      ;;
	  esac
	fi
}
complete -F _hwloc-bind hwloc-bind


_hwloc-calc(){
	local SERVICES=(-l --logical -p --physical --li --logical-input --lo --logical-output -pi --physical-input -po --physical-output -n --nodeset -h -help
		--ni --nodeset-input --no --nodeset-output --sep --taskset --single --restrict --whole-system --input -i -q --quiet -v --verbose --version)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )

	else
	  case "$3" in
	    --sep)
	      COMPREPLY=(`compgen -W "<sep>" -- "$cur"`)
	      ;;
	    -i | --input)
			COMPREPLY=($(compgen  -f -X !"*.xml" -o plusdirs -- "$cur" ) ) && compopt -o nospace  -o plusdirs
			;;
	    --restrict)
	      COMPREPLY=(`compgen -W "<cpuset>" -- "$cur"`)
	      ;;
	  esac
	fi
}
complete -F _hwloc-calc hwloc-calc


_hwloc-compress-dir(){
	local SERVICES=(-R --reverse -v --verbose -h -help)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )
	fi
}
complete -F _hwloc-compress-dir hwloc-compress-dir


_hwloc-diff(){
	local SERVICES=(--refname --version -h -help)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )
	fi
}
complete -F _hwloc-diff hwloc-diff


_hwloc-distances(){
	local SERVICES=(-l --logical -p --physical --restrict --whole-system --input -i -v --verbose --version -h -help)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )

	else
	  case "$3" in
	    -i | --input)
			COMPREPLY=($(compgen  -f -X !"*.xml" -o plusdirs -- "$cur" ) ) && compopt -o nospace  -o plusdirs
			;;
	    --restrict)
	      COMPREPLY=(`compgen -W "<set>" -- "$cur"`)
	      ;;
	  esac

	fi
}
complete -F _hwloc-distances hwloc-distances


_hwloc-distrib(){
	local TYPES=("Machine" "Misc" "Group" "NUMANode" "Package" "L1" "L2" "L3" "L4" "L5" "L1i" "L2i" "L3i" "Core" "Bridge" "PCIDev" "OSDev" "PU")
	local SERVICES=(--restrict --whole-system --input -i -v --verbose --version -h -help --ignore --from --to --at --reverse --single --taskset)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )

	else
	  case "$3" in
	    -i | --input)
			COMPREPLY=($(compgen  -f -X !"*.xml" -o plusdirs -- "$cur" ) ) && compopt -o nospace  -o plusdirs 
			;;
	    --restrict)
	    	COMPREPLY=(`compgen -W "<set>" -- "$cur"`)
	    	;;
	    --ignore | --from | --to | --at | --reverse)
			COMPREPLY=( `compgen -W "${TYPES[*]}" -- "$cur"` )
			;;
	  esac

	fi
}
complete -F _hwloc-distrib hwloc-distrib


_hwloc-gather-cpuid(){
	local SERVICES=(-h -help -c)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )

	else
	  case "$3" in
	    -c)
	    	COMPREPLY=(`compgen -W "<n>" -- "$cur"`)
	    	;;
	  esac

	fi
}
complete -F _hwloc-gather-cpuid hwloc-gather-cpuid


_hwloc-gather-topology(){
	local SERVICES=(-h -help --io --dmi --keep)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )
	fi
}
complete -F _hwloc-gather-topology hwloc-gather-topology


_hwloc-info(){
	local FORMAT=(xml fig)
	local TYPES=("Machine" "Misc" "Group" "NUMANode" "Package" "L1" "L2" "L3" "L4" "L5" "L1i" "L2i" "L3i" "Core" "Bridge" "PCIDev" "OSDev" "PU")
	local SERVICES=(-h -help --objects --topology --support -v --verbose -s --silent --ancestors --ancestor --children --descendants -n --restrict --filter 
		--no-icaches --no-io --no-bridges --whole-io --input -i --input-format --if --thissystem --pid --whole-system -l --logical -p --physical --version)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )
	fi

	case "$3" in
  	-i | --input)
		COMPREPLY=($(compgen  -f -X !"*.xml" -o plusdirs -- "$cur" ) ) && compopt -o nospace  -o plusdirs
		;;
	--filter)
		COMPREPLY=( `compgen -W "type:none,all,structure" -- "$cur"` )
		;;
	--ancestors)
		COMPREPLY=( `compgen -W "${TYPES[*]}" -- "$cur"` )
		;;
	--descendants)
		COMPREPLY=( `compgen -W "${TYPES[*]}" -- "$cur"` )
		;;
	--if | --input-format)
		COMPREPLY=( `compgen -W "${FORMAT[*]}" -- "$cur"` )
		;;
	--pid)
		COMPREPLY=( `compgen -W "<pid>" -- "$cur"` )
		;;
	--restrict)
		COMPREPLY=( `compgen -W "<cpuset> binding" -- "$cur"` )
		;;
  	esac
}
complete -F _hwloc-info hwloc-info


_hwloc-ls(){
	local FORMAT=(xml fig)
	local TYPES=("Machine" "Misc" "Group" "NUMANode" "Package" "L1" "L2" "L3" "L4" "L5" "L1i" "L2i" "L3i" "Core" "Bridge" "PCIDev" "OSDev" "PU")
	local SERVICES=(-h -help --output-format --only --of -f --force -v --verbose -s --silent --distances -c --cpuset -C --cpuset-only --taskset --filter -i --input --no-caches --ignore
		--no-useless-caches no-icaches --merge --no-collapse --restrict --restrict-flags --no-io --no-bridges --whole-io --input-format --if --thissystem --pid --whole-system
		--export-xml-flags --export-synthetic-flags --version --ps --top)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )
	fi

	case "$3" in
  	-i | --input)
		COMPREPLY=($(compgen  -f -X !"*.xml" -o plusdirs -- "$cur" ) ) && compopt -o nospace  -o plusdirs
		;;
	--filter)
		COMPREPLY=( `compgen -W "type:none,all,structure" -- "$cur"` )
		;;
	--if | --input-format)
		COMPREPLY=( `compgen -W "${FORMAT[*]}" -- "$cur"` )
		;;
	--pid)
		COMPREPLY=( `compgen -W "<pid>" -- "$cur"` )
		;;
	--restrict)
		COMPREPLY=( `compgen -W "<cpuset> binding" -- "$cur"` )
		;;
	--restrict-flags)
		COMPREPLY=( `compgen -W "<n>" -- "$cur"` )
		;;
	--only | --ignore)
			COMPREPLY=( `compgen -W "${TYPES[*]}" -- "$cur"` )
			;;
  	esac
}
complete -F _hwloc-ls hwloc-ls


_hwloc-patch(){
	local SERVICES=(-h -help --R --reverse --version)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=( `compgen -W "${SERVICES[*]}" -- "$cur"` )
	fi
}
complete -F _hwloc-patch hwloc-patch


_hwloc-ps(){
	local SERVICES=(-h -help -a --pid --name -l --logical -p --physical -c --cpuset -t --threads -e --get-last-cpu-location --pid-cmd --whole-system)
	local cur=${COMP_WORDS[COMP_CWORD]}

	if [ $COMP_CWORD == 1 ]; then
	    COMPREPLY=($(compgen  -f -X !"*.xml" -o plusdirs -- "$cur" ) ) && compopt -o nospace  -o plusdirs
	fi

	case "$3" in
	--name)
		COMPREPLY=( `compgen -W "<name>" -- "$cur"` )
		;;
	--pid)
		COMPREPLY=( `compgen -W "<pid>" -- "$cur"` )
		;;
	--pid-cmd)
		COMPREPLY=( `compgen -W "<cmd>" -- "$cur"` )
		;;
  	esac
}
complete -F _hwloc-ps hwloc-ps
