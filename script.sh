#!/bin/bash

echo "Building project..."

# Checkout to the feature branch and pull changes
git checkout feature
git pull

# Get the latest commit message
COMMIT_MSG=$(git log -1 --pretty=%B)

# Print it for debugging
echo "Commit message: $COMMIT_MSG"

# Use grep to extract all matches
matches=()
while IFS= read -r match; do
	matches+=("$match")
done < <(echo "$COMMIT_MSG" | grep -oE '\[[^]]+\]')

# A list of all models of the project
models=("alignment" "classification" "clustering" "detection" "forecasting" "networks" "param_est" "regression" "transformations")


testing="false"   # Variable storing whether tests are to be run
to_test=()        # Variable storing the models to test


# Loop over the matches to find models to test
for match in "${matches[@]}"; do

	clean_match="${match#[}"
	clean_match="${clean_match%]}"
  
	for model in "${models[@]}"; do
		if [[ "$clean_match" == "$model" ]]; then
    		to_test+=("$model")
  		fi
  	done
  
  	if [[ "$clean_match" == "test" ]]; then
  		testing="true"
  	fi

done


# Print the variables
echo "$testing"
echo "${to_test[@]}"


# Build build-image to run tests
/usr/local/bin/docker build -f build.Dockerfile -t build-image:latest .


# Run tests
if [[ "$testing" == "true" ]]; then
	echo "running tests"

	for model in "${to_test[@]}"; do 
      /usr/local/bin/docker run -d build-image:latest python3 -m pytest "sktime/${model}" && [ "$(echo $?)" = 0 ] && echo "Passed: ${model}" || echo "Failed: ${model}"
   done

fi
