#!/bin/bash

described_params='described-params.txt'
new_described_params='new-described-params.txt'
all_params_names='all-params-names.txt'
described_params_names='described-params-names.txt'
new_params_names='new-params-names.txt'

./generate_api_documentation.sh | grep name: | sed -E 's/  name: (.*)/\1/' | sort | uniq > "$all_params_names"
cat "$described_params" | cut -d' ' -f1 > "$described_params_names"
diff "$all_params_names" "$described_params_names" | grep \< | sed 's/< //' > "$new_params_names"
cat "$described_params" "$new_params_names" | sort | uniq > "$new_described_params"
rm "$all_params_names" "$described_params_names" "$new_params_names"
