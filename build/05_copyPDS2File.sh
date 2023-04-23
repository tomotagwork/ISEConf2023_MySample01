#!/bin/sh
#Copy SOURCE / COPYBOOK ---------------------------------------------------------------------------
copyFiles(){
	targetDir=$1
	suffix=$2
	sourcePDS=$3

	unset fileList
	fileList=$(ls -1 ${targetDir} | grep ${suffix})

	while read line
	do
		#echo ${line}
		fileName=$(basename ${line} ${suffix})
		echo "Copy " "//'${sourcePDS}(${fileName})'"  " to "  ${targetDir}/${line} " and set tag("${ParmSourceCodepage}")"
		cp "//'${sourcePDS}(${fileName})'"  ${targetDir}/${line}
                chtag -t -c ${ParmSourceCodepage} ${targetDir}/${line}

	done <<-END
	${fileList}
	END

}

copyLogs(){
	targetDir=$1
	suffix=$2
	sourcePDS=$3

	unset fileList
	fileList=


}


#Copy Logs---------------------------------------------------------------------------
displayPDSMemberList(){
	dsName=$1
	result=$(tsocmd "listds ('${dsName}') MEMBERS" 2> /dev/null)
	rc=$?

	if [[ ${rc} -gt 0 ]] ; then
		echo "Error: CWD is not PDS dataset!"
	else
		idx=0
		while read line
		do
			if [[ ${idx} -lt 6 ]]; then
				# do nothing
			else
				echo ${line}
			fi
			idx=$((idx+1))
		done <<-END
		${result}
		END
	fi

}

copyLogs(){
        targetDir=$1
        suffix=$2
        sourcePDS=$3

        unset fileList
        fileList=$(displayPDSMemberList ${sourcePDS})

	while read line
	do
		#echo ${line}
		echo "Copy " "//'${sourcePDS}(${fileName})'"  " to "  ${targetDir}/${line}${suffix} " and set tag(IBM-1047)"
		cp "//'${sourcePDS}(${line})'" ${targetDir}/${line}${suffix}
		chtag -t -c IBM-1047  ${targetDir}/${line}${suffix}

	done <<-END
	${fileList}
	END
}


#Main ---------------------

sed -e "s/^@/Parm/g" -e "s/@=/=/g" prop.txt > temp_prop.txt
. ./temp_prop.txt
rm temp_prop.txt

echo "ParmHLQ:" ${ParmHLQ}

#copy COBOL source
copyFiles "../cobol" ".cbl" "${ParmHLQ}.COBOL.SOURCE"

#copy COPYBOOK
copyFiles "../copybook" ".cpy" "${ParmHLQ}.COBOL.COPYLIB"

#copy Logs
if [ ! -e logs ] 
then
	mkdir logs
fi

copyLogs "./logs" ".txt" "${ParmHLQ}.COBOL.OUTPUT"


