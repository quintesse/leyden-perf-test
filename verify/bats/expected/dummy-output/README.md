# dummy-output expected fixtures

These files are exact expected outputs for [dummy-output.bats](../../dummy-output.bats).

The test runs one case at a time and compares:
- expected fixture text
- actual log text filtered to only non-indented lines

Filtering rule used by the test:
- `grep -E '^[^[:space:]]'`

## Refresh all fixtures

Run this from the repository root:

```sh
for strategy in normal aot; do
  for test_id in dummy/override dummy/empty empty/override empty/empty; do
    case_name="${strategy}-${test_id//\//-}"
    tmp_dir="$(mktemp -d)"
    out_dir="${tmp_dir}/${case_name}-results"
    log_file="${tmp_dir}/${case_name}.log"
    fixture="verify/bats/expected/dummy-output/${case_name}.txt"

    ./run test -j 25 -d dummy -s "${strategy}" -T tests-dummy "${test_id}" -o "${out_dir}" > "${log_file}" 2>&1
    grep -E '^[^[:space:]]' "${log_file}" > "${fixture}"

    rm -rf "${tmp_dir}"
  done
done
```

## Refresh one fixture

Example for `aot dummy/override`:

```sh
strategy=aot
test_id=dummy/override
case_name="${strategy}-${test_id//\//-}"
tmp_dir="$(mktemp -d)"
out_dir="${tmp_dir}/${case_name}-results"
log_file="${tmp_dir}/${case_name}.log"
fixture="verify/bats/expected/dummy-output/${case_name}.txt"

./run test -j 25 -d dummy -s "${strategy}" -T tests-dummy "${test_id}" -o "${out_dir}" > "${log_file}" 2>&1
grep -E '^[^[:space:]]' "${log_file}" > "${fixture}"
rm -rf "${tmp_dir}"
```

## Validate

```sh
./bats verify/bats/dummy-output.bats
```
