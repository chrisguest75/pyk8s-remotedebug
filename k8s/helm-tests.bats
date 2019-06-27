#!/usr/bin/env bats

@test "Verify namespace and app label" {
    run helm install ./pyk8s-remotedebug-chart --name pyk8s-remotedebug-v1 --dry-run --debug --values ./values.yaml
    echo $output >&3
    manifest=$(echo $output | sed '1,/MANIFEST/d')
    tmp_file=mktemp
    tmp_file="./temp.txt"
    echo $manifest > $tmp_file
    cat $tmp_file >&3
    #namespace=$(yq r $tmp_file metadata.name -d 0)
    #applabel=$(yq r $tmp_file spec.template.metadata.labels.app -d 1)
    #[ "$namespace" -eq "helmtest" ]
    #[ "$applabel" -eq "pyk8s-remotedebug-v1-pyk8s-remotedebug-chart" ]

    [ "false" -eq "true" ]
}

