#!/bin/sh

copyFiles(){
	sourceDir=$1
	suffix=$2
	targetPDS=$3

	unset fileList
	fileList=$(ls -1 ${sourceDir} | grep ${suffix})

	while read line
	do
		#echo ${line}
		fileName=$(basename ${line} ${suffix})
		echo "Untagged and Copy " ${sourceDir}/${line} " to " "//'${targetPDS}(${fileName})'"
		chtag -r ${sourceDir}/${line}
		cp ${sourceDir}/${line} "//'${targetPDS}(${fileName})'"

	done <<-END
	${fileList}
	END

}

sed -e "s/^@/Parm/g" -e "s/@=/=/g" prop.txt > temp_prop.txt
. ./temp_prop.txt
rm temp_prop.txt

echo "ParmHLQ:" ${ParmHLQ}

#copy COBOL source
copyFiles "../cobol" ".cbl" "${ParmHLQ}.COBOL.SOURCE"

#copy COPYBOOK
copyFiles "../copybook" ".cpy" "${ParmHLQ}.COBOL.COPYLIB"






